import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_event.dart';
import 'package:my_lawn/blocs/activity/activity_state.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/extensions/nozzle_type_extension.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_form_field.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_header_widget.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_notes_field.dart';
import 'package:my_lawn/screens/home/actions/widgets/date_form_field.dart';
import 'package:my_lawn/screens/home/actions/widgets/lawn_utils.dart';
import 'package:my_lawn/screens/home/actions/widgets/like_widget.dart';
import 'package:my_lawn/screens/home/actions/widgets/save_activity_button.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/action.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';

const _howMuchFieldTypes = [ActivityType.waterLawn];
const _repeatFieldTypes = kDebugMode
    ? [
        ActivityType.waterLawn,
        ActivityType.mowLawn,
        ActivityType.aerateLawn,
        ActivityType.dethatchLawn,
        ActivityType.overseedLawn,
        ActivityType.mulchBeds,
        ActivityType.cleanDeckPatio,
        ActivityType.winterizeSprinklerSystem,
        ActivityType.tuneUpMower,
        ActivityType.createYourOwn,
        ActivityType.userAddedProduct,
        ActivityType.recommended,
      ]
    : [];
const _remindFieldTypes = [ActivityType.waterLawn, ActivityType.mowLawn];

class ActivityScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActivityState();
}

class _ActivityState extends State<ActivityScreen> {
  final _notesController = TextEditingController();

  ActivityData _activityData;
  ActivityType _activityType;
  StreamSubscription _blocSubscription;

  String _selectedHowMuch;
  int _selectedDuration;
  String _selectedFrequencyString;
  String _selectedFrequency;
  var _remind = false;
  DateTime _selectedDate = DateTime.now();
  ActivityBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<ActivityBloc>();
    _blocSubscription = _bloc.listen((state) {
      if (state is SuccessActivityState ||
          state is SuccessUpdateActivityState) {
        final message = state is SuccessActivityState
            ? 'Added to Calendar'
            : 'Task updated!';
        registry<Navigation>().popToRoot().then(
              (_) => showSnackbar(
                context: context,
                text: message,
                duration: Duration(seconds: 2),
              ),
            );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initArguments();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _blocSubscription.cancel();
    super.dispose();
  }

  void _initArguments() {
    final args = ModalRoute.of(context).settings?.arguments;
    assert(args != null);

    if (args is ActivityData) {
      _activityData = args;
      _activityType = _activityData.activityType;

      _selectedHowMuch = registry<WaterBloc>()
          .state
          .waterData
          .selectedNozzleType
          .howMuchFieldString(args.duration);
      _selectedDuration = _activityData.duration;
      _selectedFrequencyString = _activityData.frequency;
      _selectedFrequency = frequencyListMap[_selectedFrequencyString];
      _remind = _activityData.remind ?? false;
      _selectedDate = _activityData.activityDate ?? DateTime.now();
      _notesController.text = _activityData.description ?? '';
    } else {
      _activityType = args as ActivityType;
    }
  }

  void sendAdobeActionAnalytic(String type) {
    registry<AdobeRepository>().trackAppActions(
      TaskAddedScreenAdobeAction(taskType: type),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = registry<AuthenticationBloc>().state.isGuest;
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          cubit: registry<LoginBloc>(),
          listener: (context, state) {
            if (state is PendingRegistrationState) {
              registry<Navigation>().push(
                '/auth/pendingregistration',
                arguments: {'email': state.email, 'regToken': state.regToken},
              );
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          cubit: registry<AuthenticationBloc>(),
          listener: (context, state) {
            if (!state.isGuest) {
              _saveActivity();
            }
          },
        ),
      ],
      child: BasicScaffoldWithSliverAppBar(
        isNotUsingWillPop: true,
        child: _buildContent(),
        bottom: SaveActivityButton(
          onTap: () {
            if (isGuest) {
              buildLoginBottomCard(context);
            } else {
              _saveActivity();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<ActivityBloc, ActivityState>(
      cubit: _bloc,
      builder: (ctx, state) => state is LoadingActivityState
          ? Center(child: ProgressSpinner())
          : Column(
              children: [
                ActivityHeaderWidget(activityType: _activityType),
                _buildFormWidget(),
                LikeWidget(activityType: _activityType),
              ],
            ),
    );
  }

  Widget _buildFormWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (_howMuchFieldTypes.contains(_activityType)) _buildHowMuchField(),
          _buildWhenField(),
          if (_repeatFieldTypes.contains(_activityType)) _buildRepeatField(),
          if (_remindFieldTypes.contains(_activityType)) _buildRemindField(),
          _buildNotesField(),
        ],
      ),
    );
  }

  Widget _buildHowMuchField() {
    // TODO: IF THE WATERBLOC FAILS, THE HOW MUCH SECTION WONT BE DISPLAYED WE HAVE 2 OPTIONS,
    // BE OPTIMISTIC AND ASSUME IT WONT FAIL OR CACHE A SUCCESSFUL RESPONSE
    if (registry<WaterBloc>()
            .state
            .waterData
            ?.selectedNozzleType
            ?.activityHowMuchFields !=
        null) {
      return ActivityFormField<String>(
        title: 'How much',
        selectedItem: _selectedHowMuch ?? '',
        items: registry<WaterBloc>()
            .state
            .waterData
            .selectedNozzleType
            .activityHowMuchFields,
        onValueSelected: (value) {
          setState(() {
            _selectedHowMuch = value;
            _selectedDuration = registry<WaterBloc>()
                .state
                .waterData
                .selectedNozzleType
                .howMuchFieldDuration(value);
          });
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildWhenField() {
    return DateFormField(
      selectedItem: _selectedDate,
      onValueSelected: (value) {
        setState(() {
          _selectedDate = value;
        });
      },
    );
  }

  Widget _buildRepeatField() {
    return ActivityFormField<String>(
      title: 'Repeat',
      selectedItem: _selectedFrequencyString,
      items: frequencyList,
      onValueSelected: (value) {
        setState(() {
          _selectedFrequencyString = value;
          _selectedFrequency = frequencyListMap[value];
        });
      },
    );
  }

  Widget _buildRemindField() {
    return ActivityFormField<bool>(
      title: 'Remind me',
      selected: _remind,
      selectable: true,
      onValueSelected: (value) {
        setState(() {
          _remind = value;
        });
      },
    );
  }

  Widget _buildNotesField() {
    return ActivityNotesField(controller: _notesController);
  }

  void _saveActivity() {
    sendAdobeActionAnalytic(_activityType.title.toLowerCase());

    _bloc.add(
      SaveActivityEvent(
        ActivityData(
          activityId: _activityData?.activityId,
          activityType: _activityType,
          activityDate: _selectedDate,
          applicationWindow: ProductApplicationWindow(startDate: _selectedDate),
          duration: _selectedDuration,
          remind: _remind,
          frequency: _selectedFrequency,
          description: _notesController.text,
        ),
      ),
    );
  }
}
