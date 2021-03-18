import 'package:flutter/widgets.dart';

mixin RouteMixin<S extends StatefulWidget, T> on State<S> {
  String _routeName;
  T _routeArguments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _routeArguments = ModalRoute.of(context)?.settings?.arguments;
    _routeName = ModalRoute.of(context)?.settings?.name;
  }

  /// Shorthand for retrieving name from ModalRoute.
  String get routeName => _routeName;

  /// Shorthand for retrieving arguments from ModalRoute.
  T get routeArguments => _routeArguments;
}
