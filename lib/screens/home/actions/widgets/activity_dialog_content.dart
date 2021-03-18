import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityDialogContent<T> extends StatelessWidget {
  const ActivityDialogContent({
    @required this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12),
          child: Divider(),
        ),
        Container(
          height: 189,
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 20),
          child: child,
        ),
      ],
    );
  }
}
