import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class SettingMenuSpacer extends StatelessWidget {
  final Widget child;

  const SettingMenuSpacer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Styleguide.color_gray_1
          : Styleguide.color_gray_8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: child ?? Container(),
      ),
    );
  }
}
