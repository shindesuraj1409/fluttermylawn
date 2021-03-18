import 'package:flutter/material.dart';

class TipsFooter extends StatelessWidget {
  final int readTime;
  final Function(bool) onPressed;
  final EdgeInsets margin;

  const TipsFooter({Key key, this.readTime, this.margin, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomLeft,
        margin: margin,
        child: readTime != null
            ? Text(
                '${readTime} min Read',
              )
            : Container());
  }
}
