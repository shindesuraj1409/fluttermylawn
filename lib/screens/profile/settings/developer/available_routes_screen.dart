import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/config/routes_config.dart' as routes_config;
import 'package:my_lawn/data/back_button_state.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class AvailableRoutesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routes = routes_config.debugRoutes;
    final sortedKeys = routes.keys.toList()..sort();

    return BasicScaffoldWithSliverAppBar(
      titleString: 'Available Routes',
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedKeys
            .map((key) => ListTile(
                  key: Key(key),
                  title: Text(key),
                  subtitle: Text(routes[key].toString()),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => registry<Navigation>().push(
                    key,
                    arguments: BackButtonState.Enabled,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
