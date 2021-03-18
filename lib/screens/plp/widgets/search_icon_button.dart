import 'package:flutter/material.dart';

class SearchIconButton extends StatelessWidget {
  const SearchIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      key: Key('plp_search_button'),
      icon: SizedBox(
        height: 16,
        width: 16,
        child: Image.asset('assets/icons/plp_search_icon.png'),
      ),
    );
  }
}
