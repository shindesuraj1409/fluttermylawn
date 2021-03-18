import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import '../config/colors_config.dart';
import '../config/registry_config.dart';

class CircularFab extends StatefulWidget {
  @override
  _CircularFabState createState() => _CircularFabState();
}

class _CircularFabState extends State<CircularFab>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation noteFabTranslationAnimation,
      taskFabTranslationAnimation,
      productFabTranslationAnimation;
  Animation rotationAnimation;

  bool _isFABOpen = false;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    noteFabTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);

    taskFabTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);

    productFabTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);

    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  double _getRadiansFromDegree(double degree) => degree / 57.295779513;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        Visibility(
          visible: _isFABOpen,
          child: GestureDetector(
            onTap: () {
              animationController.reverse();
              setState(() {
                _isFABOpen = false;
              });
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Styleguide.color_gray_0.withOpacity(0.80),
                ),
              ),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Positioned(
                right: 16,
                bottom: 16,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Styleguide.color_gray_9.withOpacity(0),
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(_getRadiansFromDegree(270),
                          noteFabTranslationAnimation.value * 100),
                      child: Transform(
                          transform: Matrix4.rotationZ(
                              _getRadiansFromDegree(rotationAnimation.value))
                            ..scale(noteFabTranslationAnimation.value),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              _SizedFAB(
                                color: Styleguide.color_accents_yellow_1,
                                width: 48,
                                height: 48,
                                icon: Image.asset(
                                  'assets/icons/note.png',
                                  key: Key('note_icon'),
                                  width: 32,
                                  height: 32,
                                ),
                                onClick: () {
                                  animationController.reverse();
                                  setState(() {
                                    _isFABOpen = false;
                                  });

                                  unawaited(
                                      registry<Navigation>().push('/addnote'));
                                },
                              ),
                              Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text('Note',
                                      style: _theme.textTheme.overline.copyWith(
                                          color: Styleguide.color_gray_9,
                                          fontWeight: FontWeight.bold)))
                            ],
                          )),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(_getRadiansFromDegree(225),
                          taskFabTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            _getRadiansFromDegree(rotationAnimation.value))
                          ..scale(taskFabTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            _SizedFAB(
                              color: Styleguide.color_gray_4,
                              width: 48,
                              height: 48,
                              icon: Image.asset(
                                'assets/icons/task.png',
                                key: Key('task_icon'),
                                width: 32,
                                height: 32,
                              ),
                              onClick: () {
                                animationController.reverse();
                                setState(() {
                                  _isFABOpen = false;
                                });
                                unawaited(
                                    registry<Navigation>().push('/addtask'));
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                'Task',
                                style: _theme.textTheme.overline.copyWith(
                                  color: Styleguide.color_gray_9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(_getRadiansFromDegree(180),
                          productFabTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            _getRadiansFromDegree(rotationAnimation.value))
                          ..scale(productFabTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            _SizedFAB(
                              color: Styleguide.color_green_2,
                              width: 48,
                              height: 48,
                              icon: Image.asset(
                                'assets/icons/product.png',
                                key: Key('product_icon'),
                                width: 32,
                                height: 32,
                              ),
                              onClick: () {
                                animationController.reverse();
                                setState(() {
                                  _isFABOpen = false;
                                });

                                unawaited(
                                  registry<Navigation>().push('/plp'),
                                );
                              },
                            ),
                            Padding(
                                padding: EdgeInsets.all(3),
                                child: Text('Product',
                                    style: _theme.textTheme.overline.copyWith(
                                        color: Styleguide.color_gray_9,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.rotationZ(
                          _getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: _SizedFAB(
                        color: Styleguide.color_accents_yellow_3,
                        width: 56,
                        height: 56,
                        icon: Icon(
                          _isFABOpen ? Icons.close : Icons.add,
                          key: Key('floating_action_button'),
                          color: _theme.colorScheme.onPrimary,
                          size: 16,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                          setState(() {
                            _isFABOpen = !_isFABOpen;
                          });
                        },
                      ),
                    )
                  ],
                )),
          ],
        ),
      ],
    );
  }
}

class _SizedFAB extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget icon;
  final Function onClick;

  _SizedFAB({
    this.color,
    this.width,
    this.height,
    this.icon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: null,
          onPressed: onClick,
          backgroundColor: color,
          child: icon,
        ),
      ),
    );
  }
}
