import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class QuestionText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showToolTip;
  final Function onToolTipClicked;

  QuestionText({
    this.title,
    this.subtitle,
    this.showToolTip = false,
    this.onToolTipClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.headline2.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Visibility(
              visible: showToolTip,
              child: IconButton(
                onPressed: onToolTipClicked,
                icon: Image.asset(
                  'assets/icons/info.png',
                  color: Styleguide.color_gray_0,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: subtitle != null && subtitle.isNotEmpty,
          child: Text(
            subtitle,
            style: theme.textTheme.subtitle2.copyWith(
              color: theme.colorScheme.onPrimary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
