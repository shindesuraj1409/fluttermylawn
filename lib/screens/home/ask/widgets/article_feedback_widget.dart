import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/text_with_optional_actions_widget.dart';
import 'package:navigation/navigation.dart';

class ArticleFeedback extends StatefulWidget {
  @override
  _ArticleFeedbackState createState() => _ArticleFeedbackState();
}

class _ArticleFeedbackState extends State<ArticleFeedback> {
  bool isHelpfulSelected = false;
  bool isNotHelpfulSelected = false;

  final defaultHelpfulIcon = Image.asset(
    'assets/icons/thumbs_up.png',
    width: 32,
    height: 32,
  );

  final selectedHelpfulIcon = Image.asset(
    'assets/icons/thumbs_up_filled.png',
    width: 32,
    height: 32,
  );

  final defaultNotHelpfulIcon = Image.asset(
    'assets/icons/thumbs_down.png',
    width: 32,
    height: 32,
  );

  final selectedNotHelpfulIcon = Image.asset(
    'assets/icons/thumbs_down_filled.png',
    width: 32,
    height: 32,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          color: Styleguide.nearBackground(theme),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Was this article helpful?',
                  style: theme.textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: isHelpfulSelected
                                ? selectedHelpfulIcon
                                : defaultHelpfulIcon,
                            onPressed: () {
                              if (!isHelpfulSelected) {
                                // TODO : Add an api call to send feedback
                                setState(() {
                                  isHelpfulSelected = true;
                                  isNotHelpfulSelected = false;
                                });
                              }
                            },
                          ),
                          Text(
                            'Yes',
                            style: theme.textTheme.caption,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: VerticalDivider(),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: isNotHelpfulSelected
                                ? selectedNotHelpfulIcon
                                : defaultNotHelpfulIcon,
                            onPressed: () {
                              if (!isNotHelpfulSelected) {
                                // TODO : Add an api call to send feedback
                                setState(() {
                                  isNotHelpfulSelected = true;
                                  isHelpfulSelected = false;
                                });
                              }
                            },
                          ),
                          Text(
                            'No',
                            style: theme.textTheme.caption,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: isNotHelpfulSelected
              ? TextWithOptionalActions(children: [
                  'Sorry to hear that',
                  [
                    ' Ask us ',
                    () {
                      registry<Navigation>().pop(context);
                    },
                  ],
                  'if you need more help!'
                ])
              : isHelpfulSelected
                  ? Text(
                      'Thank you for your feedback!',
                      style: theme.textTheme.caption,
                    )
                  : Container(),
        ),
      ],
    );
  }
}
