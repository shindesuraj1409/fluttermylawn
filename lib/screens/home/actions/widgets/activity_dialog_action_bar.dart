import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/widgets/button_widget.dart';

class ActivityDialogActionBar extends StatelessWidget {
  const ActivityDialogActionBar({
    @required this.onSelectTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onSelectTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TappableText(
            child: Text(
              'CANCEL',
              style: theme.textTheme.bodyText1.copyWith(
                color: Styleguide.color_gray_4,
                fontSize: 14,
              ),
              key: Key('cancel_button'),
            ),
            onTap: Navigator.of(context).pop,
          ),
          TappableText(
            child: Text(
              'SELECT',
              style: theme.textTheme.bodyText1.copyWith(
                color: theme.primaryColor,
                fontSize: 14,
              ),
              key: Key('select_button'),
            ),
            onTap: () {
              onSelectTap();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
