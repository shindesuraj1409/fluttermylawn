import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final TextStyle style;
  final int maxLines;
  final String text;
  final Gradient gradient;

  GradientText(
    this.text, {
    @required this.gradient,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
      ),
    );
  }
}
