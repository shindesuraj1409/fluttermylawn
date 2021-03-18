import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/call_and_mail_widget.dart';

class CancelationBottomNavBar extends StatelessWidget {
  const CancelationBottomNavBar({
    Key key,
    @required this.onPressed,
    this.hasDescription = false,
  }) : super(key: key);

  final Function onPressed;
  final bool hasDescription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
      color: theme.colorScheme.onPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasDescription)
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                'Our service team is here to help you get your best lawn. ',
                style: theme.textTheme.subtitle1.copyWith(fontSize: 14),
              ),
            ),
          CallAndMailWidget(EdgeInsets.fromLTRB(40, 0, 40, 0), '1-877-220-3091',
              'orders@scotts.com'),
          Container(
            margin: EdgeInsets.fromLTRB(24, 24, 24, 0),
            width: double.infinity,
            child: RaisedButton(
              child: Text('CONTINUE'),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
