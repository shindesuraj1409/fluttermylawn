import 'package:flutter/material.dart';

class Ribbon extends StatelessWidget {
  final Color color;

  const Ribbon({this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(8, 26),
      painter: RibbonPainter(color: color),
    );
  }
}

class RibbonPainter extends CustomPainter {
  final Color color;

  RibbonPainter({@required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - 4)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RibbonPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
