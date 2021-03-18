import 'package:flutter/material.dart';
import 'package:bus/bus.dart';
import 'package:my_lawn/models/theme_model.dart';

class Heading1 extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle theme;

  const Heading1(
    this.text, {
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = busSnapshot<ThemeModel, ThemeData>().textTheme;
    return Container(
      padding: padding,
      margin: margin,
      child: Text(
        text,
        style: textTheme.headline1,
      ),
    );
  }
}

class Heading2 extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle theme;

  const Heading2(
    this.text, {
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = busSnapshot<ThemeModel, ThemeData>().textTheme;
    return Container(
      padding: padding,
      margin: margin,
      child: Text(
        text,
        style: textTheme.headline2,
      ),
    );
  }
}

class Heading3 extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle theme;

  const Heading3(
    this.text, {
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = busSnapshot<ThemeModel, ThemeData>().textTheme;
    return Container(
      padding: padding,
      margin: margin,
      child: Text(
        text,
        style: textTheme.headline3,
      ),
    );
  }
}
