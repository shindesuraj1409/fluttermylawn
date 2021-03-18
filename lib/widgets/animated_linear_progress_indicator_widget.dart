import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double initialValue;
  final double finalValue;
  final double minHeight;

  const AnimatedLinearProgressIndicator({
    Key key,
    @required this.backgroundColor,
    @required this.foregroundColor,
    @required this.initialValue,
    @required this.finalValue,
    this.minHeight = 3,
  }) : super(key: key);

  @override
  _AnimatedLinearProgressIndicatorState createState() =>
      _AnimatedLinearProgressIndicatorState();
}

class _AnimatedLinearProgressIndicatorState
    extends State<AnimatedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();

    _tween = Tween<double>(
      begin: widget.initialValue,
      end: widget.finalValue,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _tween.evaluate(_controller),
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation(widget.foregroundColor),
          minHeight: widget.minHeight,
          key: Key('progress_bar_value_'+_tween.evaluate(_controller).toString()),
        );
      },
    );
  }
}
