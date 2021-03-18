import 'package:flutter/material.dart';

class CompletedImage extends StatelessWidget {
  const CompletedImage({
    Key key,
    @required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      width: 114,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary, shape: BoxShape.circle),
      child: Image.asset(
        'assets/icons/completed_outline.png',
        height: 75,
      ),
    );
  }
}
