import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class OverlayWithChild extends StatelessWidget {
  final Widget child;
  final Function delayedFunction;

  const OverlayWithChild({
    @required this.child,
    @required this.delayedFunction,
  })  : assert(child != null, 'child shouldn\'t be null'),
        assert(delayedFunction != null, 'Image shouldn\'t be null');

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      delayedFunction();
    });

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Styleguide.color_gray_5.withOpacity(0.4),
        body: Center(
          child: Container(
            height: 156,
            width: 156,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
