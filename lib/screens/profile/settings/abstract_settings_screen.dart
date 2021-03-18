import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/help_bloc/help_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_event.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/build_data.dart';
import 'package:my_lawn/data/device_data.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/models/device_model.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:bus/bus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

abstract class AbstractSettingsScreen extends StatelessWidget {
  String get title;

  List<Widget> buildItems(BuildContext context);

  Widget buildSectionHeader(BuildContext context, [String headerTitle = '']) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Text(
          headerTitle.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ),
      );

  Widget buildGraySpacer(BuildContext context, {Widget child}) => Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Styleguide.color_gray_1
            : Styleguide.color_gray_8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: child ?? Container(),
        ),
      );

  Widget buildHorizontalDivider() => Divider();

  Widget buildSwitch({
    BuildContext context,
    String imageName,
    IconData iconData,
    String description,
    bool value,
    void Function(bool) onChanged,
  }) {
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
                      key: Key(description
                              .toLowerCase()
                              .replaceAll(RegExp(r'\s+'), '_') +
                          '_icon'),
                    )
                  : Icon(
                      iconData,
                      size: 20,
                      color: theme.primaryColor,
                      key: Key(description
                              .toLowerCase()
                              .replaceAll(RegExp(r'\s+'), '_') +
                          '_icon'),
                    ),
            ),
          Expanded(child: Text(description, style: textTheme.subtitle2)),
          Switch(
            key: Key(description),
            value: value,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget buildLink({
    BuildContext context,
    String imageName,
    IconData iconData,
    String description,
    String route,
    String url,
    VoidCallback onTap,
  }) {
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
                        key: Key(description
                                .toLowerCase()
                                .replaceAll(RegExp(r'\s+'), '_') +
                            '_icon'),
                      )
                    : Icon(
                        iconData,
                        size: 20,
                        color: theme.primaryColor,
                        key: Key(description
                                .toLowerCase()
                                .replaceAll(RegExp(r'\s+'), '_') +
                            '_icon'),
                      ),
              ),
            Expanded(child: Text(description, style: textTheme.subtitle2)),
            Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: textTheme.bodyText2.color,
              key: Key(description.removeNonCharsMakeLowerCaseMethod(identifier: '_goto_icon')),
            )],
        ),
      ),
      onTap: onTap ??
          () => route != null
              ? registry<Navigation>().push(route)
              : url != null
                  ? launch(url)
                  : null,
    );
  }

  Widget _buildDeviceAndBuild(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceData = busSnapshot<DeviceModel, DeviceData>();
    final buildData = busSnapshot<AppModel, BuildData>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${deviceData.manufacturer ?? '?'} ${deviceData.model ?? '?'}, ${deviceData.version ?? '?'}',
            textAlign: TextAlign.start,
            style: textTheme.caption,
          ),
          Text(
            '${buildData.version ?? '-'}+${buildData.build ?? '-'}',
            textAlign: TextAlign.end,
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    registry<HelpBloc>().add(FetchHelpEvent());
    return BasicScaffoldWithSliverAppBar(
      titleString: title,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...buildItems(context),
          Expanded(
            child: buildGraySpacer(
              context,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: _buildDeviceAndBuild(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
