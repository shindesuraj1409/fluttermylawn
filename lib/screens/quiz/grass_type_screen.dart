import 'dart:io';

import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/quiz/grass_type_model.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/settings_screen/state.dart';
import 'package:my_lawn/widgets/animated_linear_progress_indicator_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/quiz/option_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:permission_handler/permission_handler.dart';

class GrassTypeScreen extends StatefulWidget {
  @override
  _GrassTypeScreenState createState() => _GrassTypeScreenState();
}

class _GrassTypeScreenState extends State<GrassTypeScreen>
    with RouteMixin<GrassTypeScreen, LawnData> {
  QuizModel _quizModel;
  LawnData _lawnData;
  GrassTypeModel _model;

  PermissionStatus notificationPermissionStatus;
  PermissionStatus locationPermissionStatus;

  @override
  void initState() {
    super.initState();
    _model = GrassTypeModel();
    _getPermissionStatuses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      _lawnData = routeArguments;
      _model.getGrassTypes(_lawnData.lawnAddress.zip);
    } else {
      _quizModel = registry<QuizModel>();
      _model.getGrassTypes(_quizModel.getZipCode());
    }
  }

  void _getPermissionStatuses() async {
    notificationPermissionStatus = await Permission.notification.status;
    locationPermissionStatus = await Permission.location.status;
  }

  void _tryAgain() {
    if (_lawnData != null) {
      _model.getGrassTypes(_lawnData.lawnAddress.zip);
    } else {
      _model.getGrassTypes(_quizModel.getZipCode());
    }
  }

  void pushAdobeAnalyticCall() {
    registry<AdobeRepository>()
        .trackAppState(SoftAskScreenAdobeState(askType: 'push notification'));
  }

  void locationAdobeAnalyticCall() {
    registry<AdobeRepository>()
        .trackAppState(SoftAskScreenAdobeState(askType: 'location'));
  }

  void _saveAnswer(Option option) {
    if (_lawnData != null) {
      _saveLawnProfile(option); // Edit Lawn Profile flow
    } else {
      _quizModel.saveGrassType(
          option.value, option.imageUrl, option.label); // Quiz flow
      if (Platform.isIOS) {
        if (!notificationPermissionStatus.isGranted) {
          pushAdobeAnalyticCall();

          registry<Navigation>().push(
              '/quiz/softask/push'); // Only show push notification opt-in screen in iOS.
        } else if (!locationPermissionStatus.isGranted) {
          locationAdobeAnalyticCall();

          registry<Navigation>().push('/quiz/softask/location');
        } else {
          registry<Navigation>().setRoot(
            '/quiz/submit',
            rootName: '/welcome',
          );
        }
      } else {
        if (!locationPermissionStatus.isGranted) {
          locationAdobeAnalyticCall();

          registry<Navigation>().push('/quiz/softask/location');
        } else {
          registry<Navigation>().setRoot(
            '/quiz/submit',
            rootName: '/welcome',
          );
        }
      }
    }
  }

  void _saveLawnProfile(Option option) {
    final selectedGrassType = option.value;
    final selectedGrassTypeImageUrl = option.imageUrl;
    final selectedGrassTypeName = option.label;
    final updatedLawnData = _lawnData.copyWith(
      grassType: selectedGrassType,
      grassTypeImageUrl: selectedGrassTypeImageUrl,
      grassTypeName: selectedGrassTypeName,
    );

    registry<Navigation>().pop<LawnData>(updatedLawnData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithAppBar(
      isNotUsingWillPop: true,
      appBarElevation: 0,
      appBarBrightness: Brightness.dark,
      backgroundColor: theme.primaryColor,
      appBarBackgroundColor: theme.primaryColor,
      appBarForegroundColor: theme.colorScheme.onPrimary,
      trailing:
          // This means screen is opened in quiz flow and
          // we need to show progress percentage of quiz flow
          _quizModel != null
              ? Expanded(
                  child: AnimatedLinearProgressIndicator(
                    initialValue: 0.75,
                    finalValue: 1.0,
                    backgroundColor: theme.colorScheme.background,
                    foregroundColor: theme.colorScheme.secondaryVariant,
                  ),
                )
              : SizedBox(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    'What is your grass type?',
                    style: theme.textTheme.headline2.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'This helps us send you the right amount of products.',
                    style: theme.textTheme.subtitle2.copyWith(
                      color: theme.colorScheme.onPrimary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          busStreamBuilder<GrassTypeModel, GrassTypeData>(
            busInstance: _model,
            builder: (context, model, data) {
              switch (data.state) {
                case GrassTypeState.loading:
                  return SliverFillRemaining(
                    child: Center(
                      child:
                          ProgressSpinner(color: theme.colorScheme.onPrimary),
                    ),
                  );
                  break;
                case GrassTypeState.invalid_zip_prefix:
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        data.errorMessage,
                        style: theme.textTheme.headline5.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                case GrassTypeState.error:
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            data.errorMessage,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.subtitle1.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              'Try again',
                              style: theme.textTheme.headline4.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            onPressed: _tryAgain,
                          ),
                        ],
                      ),
                    ),
                  );
                case GrassTypeState.success:
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ImageOption(
                            ObjectKey(data.grassTypeOptions[index].value),
                            option: data.grassTypeOptions[index],
                            onSelected: _saveAnswer,
                          );
                        },
                        childCount: data.grassTypeOptions.length,
                      ),
                    ),
                  );
                default:
                  throw UnimplementedError(
                      'Invalid state reached : ${data.state}');
              }
            },
          ),
        ],
      ),
    );
  }
}
