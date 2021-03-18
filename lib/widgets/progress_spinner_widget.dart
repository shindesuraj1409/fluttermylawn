import 'package:flutter/material.dart';

/// A simple progress spinner, with reasonable defaults for this app.
class ProgressSpinner extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final double value;

  const ProgressSpinner({
    this.color,
    this.size = 32.0,
    this.strokeWidth = 3.0,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ExcludeSemantics(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
