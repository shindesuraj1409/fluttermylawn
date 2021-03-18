import 'package:flutter/material.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class SettingMenuSwitch extends StatelessWidget {
  final String imageName;
  final IconData iconData;
  final String description;
  final bool value;
  final void Function(bool) onChanged;

  SettingMenuSwitch({this.imageName, this.iconData, this.description, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (imageName != null || iconData != null)
            Padding(
              padding: EdgeInsets.only(right: imageName != null ? 16 : 20),
              child: imageName != null
                  ? Image.asset(
                imageName,
                width: 24,
                height: 24,
                color: theme.primaryColor,
                key: Key(description.removeNonCharsMakeLowerCaseMethod(identifier: '_icon')),
              )
                  : Icon(
                iconData,
                size: 20,
                color: theme.primaryColor,
                key: Key(description.removeNonCharsMakeLowerCaseMethod(identifier: '_icon')),
              ),
            ),
          Expanded(child: Text(description, style: textTheme.subtitle2)),
          Switch(
            key: Key(description.removeNonCharsMakeLowerCaseMethod()),
            value: value,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
