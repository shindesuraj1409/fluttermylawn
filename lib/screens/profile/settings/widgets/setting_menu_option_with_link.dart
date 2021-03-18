import 'package:navigation/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class SettingMenuOptionWithLink extends StatelessWidget {
  final String imageName;
  final IconData iconData;
  final String description;
  final String route;
  final String url;
  final VoidCallback onTap;

  SettingMenuOptionWithLink({this.imageName, this.iconData, this.description, this.route, this.url, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: textTheme.bodyText2.color,
              key: Key(description.removeNonCharsMakeLowerCaseMethod(identifier: '_goto_icon')),
            ),
          ],
        ),
      ),
      //TODO: @EUGENE change onTap function
      onTap: onTap ??
              () => route != null
              ? registry<Navigation>().push(route)
              : url != null ? launch(url) : null,
    );
  }
}
