import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const CustomIcon(
    this.name, {
    this.height,
    this.width,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      child: Image(
        image: AssetImage('assets/icons/${name}.png'),
        height: height,
        width: width,
      ),
    );
  }
}
