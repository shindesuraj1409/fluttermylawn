import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ProductHtmlWrapper extends StatelessWidget {
  final String text;

  const ProductHtmlWrapper({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text.replaceAll(RegExp(r'\n'), '<br>'),
      style: {
        'body': Style(
          fontSize: FontSize(14.0),
          fontFamily: 'ProximaNova',
        ),
      },
    );
  }
}
