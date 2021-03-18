import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final Function(int) callback;
  final int quantity;
  final int coverageArea;

  Counter(this.callback, this.quantity, this.coverageArea);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  ThemeData _theme;
  int _number;
  @override
  void initState() {
    _number = widget.quantity;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  void subtract() {
    if (_number > 0) {
      setState(() {
        widget.callback(--_number);
      });
    }
  }

  void add() {
    setState(() {
      widget.callback(++_number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.zero,
          minWidth: 32,
          height: 32,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: _theme.colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: _theme.colorScheme.onPrimary,
                size: 18,
              )),
          onPressed: subtract,
        ),
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: _theme.colorScheme.onPrimary,
            border: Border.all(
              color: _theme.colorScheme.primary,
              width: 1,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text('${_number}',
                style: _theme.textTheme.bodyText1.copyWith(
                  color: _theme.colorScheme.primary,
                )),
          ),
        ),
        FlatButton(
          key: Key('coverage_add_icon'),
          padding: EdgeInsets.zero,
          minWidth: 32,
          height: 32,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: _theme.colorScheme.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Icon(
              Icons.add,
              color: _theme.colorScheme.onPrimary,
              size: 18,
            ),
          ),
          onPressed: add,
        ),
      ],
    );
  }
}
