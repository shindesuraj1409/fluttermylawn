import 'package:flutter/widgets.dart';

extension RouteArgumentsExtension on StatelessWidget {
  /// Shorthand for retrieving arguments from ModalRoute.
  T routeArguments<T>(BuildContext context) =>
      ModalRoute.of(context)?.settings?.arguments;

  /// Shorthand for retrieving name from ModalRoute.
  String routeName(BuildContext context) =>
      ModalRoute.of(context)?.settings?.name;
}
