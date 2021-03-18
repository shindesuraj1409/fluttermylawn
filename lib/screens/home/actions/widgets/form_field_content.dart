import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class FormFieldContent extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Widget child;

  const FormFieldContent({
    @required this.onTap,
    @required this.title,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Styleguide.color_gray_1,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.headline4,
            ),
            Spacer(),
            child,
          ],
        ),
      ),
    );
  }
}
