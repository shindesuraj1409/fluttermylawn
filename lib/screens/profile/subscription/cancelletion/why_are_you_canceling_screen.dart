import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/profile/subscription/widgets/cancelation_bottom_nav_bar.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class WhyAreYouCancelingScreen extends StatefulWidget {
  @override
  _WhyAreYouCancelingScreenState createState() =>
      _WhyAreYouCancelingScreenState();
}

class _WhyAreYouCancelingScreenState extends State<WhyAreYouCancelingScreen> {
  final List<String> selectedReasons = <String>[];

  @override
  void initState() {
    super.initState();
    registry<CancellingReasonsBloc>().add(FetchCancellingReasonsEvent());
  }

  BoxDecoration _radioDecoration(bool isSelected) => BoxDecoration(
        color: isSelected ? Styleguide.color_green_2 : Styleguide.color_gray_0,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      );

  Widget _textContainer(String data, ThemeData theme) => GestureDetector(
        onTap: () {
          if (!selectedReasons.contains(data)) {
            setState(() {
              selectedReasons.add(data);
            });
          } else {
            setState(() {
              selectedReasons.remove(data);
            });
          }
        },
        child: Container(
            height: 52,
            width: double.infinity,
            decoration: _radioDecoration(selectedReasons.contains(data)),
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(16),
            child: Text(data,
                style: theme.textTheme.button.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selectedReasons.contains(data)
                        ? Styleguide.color_gray_0
                        : Styleguide.color_gray_9))),
      );

  void _sendAdobeAnalyticState(List<String> list) {
    registry<AdobeRepository>().trackAppState(
      CancelReasonScreenAdobeState(cancelList: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithSliverAppBar(
      hasScrollBody: true,
      titleString: 'Why Are You Canceling?',
      leading: GestureDetector(
        onTap: () => registry<Navigation>().pop(),
        child: Icon(
          Icons.close,
          size: 32,
          key: Key('close_icon'),
        ),
      ),
      appBarForegroundColor: theme.colorScheme.onPrimary,
      appBarBackgroundColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary,
      bottom: Container(
        height: 181,
        child: CancelationBottomNavBar(onPressed: () {
          _sendAdobeAnalyticState(selectedReasons);
          registry<Navigation>()
              .pushReplacement('/profile/subscription/canceling_screen');
        }),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: BlocBuilder(
              cubit: registry<CancellingReasonsBloc>(),
              builder: (context, state) =>
                  state is CancellingReasonsSuccessState
                      ? Column(
                          children: [
                            ...state.cancellingReasonsList
                                .map((e) => _textContainer(e.reason, theme))
                                .toList(),
                          ],
                        )
                      : Column(
                          children: [Container()],
                        ),
            ),
          ),
        ),
      ],
    );
  }
}
