import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:navigation/navigation.dart';

typedef OnSearchValueChanged = Function(String searchValue);

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    @required this.onSearchValueChanged,
    @required this.searchValue,
    Key key,
  }) : super(key: key);

  final OnSearchValueChanged onSearchValueChanged;
  final String searchValue;

  void _onSearchTap() async {
    final value = await registry<Navigation>().push(
      '/calendar/search',
      arguments: searchValue,
    );

    onSearchValueChanged(value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onSearchTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset(
          'assets/icons/search.png',
          width: 26,
          height: 26,
          key: Key('search_icon'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
