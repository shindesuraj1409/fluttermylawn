import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget child;

  const CustomExpansionTile({
    this.title,
    this.child,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  ThemeData _theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.colorScheme.background,
      child: Column(
        children: <Widget>[
          Theme(
            data: ThemeData(
              accentColor: _theme.colorScheme.onBackground,
              dividerColor: Colors.transparent,
              unselectedWidgetColor: _theme.colorScheme.onBackground,
            ),
            child: ExpansionTile(
              expandedAlignment: Alignment.topLeft,
              title: Text(
                widget.title,
                style: _theme.textTheme.headline6
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: widget.child,
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onBackground,
            thickness: 0.25,
            height: 1,
          ),
        ],
      ),
    );
  }
}
