import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_lawn/config/colors_config.dart';

class AddNoteFab extends StatefulWidget {
  final void Function(ImageSource, BuildContext) callback;

  AddNoteFab(this.callback);

  @override
  _AddNoteFabState createState() => _AddNoteFabState();
}

class _AddNoteFabState extends State<AddNoteFab>
    with SingleTickerProviderStateMixin {
  ThemeData _theme;

  TextEditingController textFieldController = TextEditingController();
  String fieldValue = '';
  AnimationController animationController;
  Animation<double> _cameraTranslationAnimation, _galleryTranslationAnimation;
  Animation<double> _rotationAnimation;
  Animation<double> _mainRotationAnimation;

  bool _isFABOpen = false;

  String iconName = 'pic.png';

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _cameraTranslationAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);

    _galleryTranslationAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);

    _rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    _mainRotationAnimation = Tween<double>(begin: 0.0, end: 180.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    super.initState();

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
  }

  double getRadiansFromDegree(double degree) => degree / 57.295779513;

  @override
  Widget build(BuildContext context) {
    Widget _floatingButtons() {
      Widget _item(icon, size, color, dynamic onClick) => Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
                  blurRadius: 5.0,
                  spreadRadius: -1.0,
                  offset: Offset(
                    0.0,
                    3.0,
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
                  blurRadius: 18.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    6.0,
                  ),
                ),
              ],
            ),
            width: size,
            height: size,
            child: IconButton(
                icon: icon, enableFeedback: true, onPressed: onClick),
          );

      return Stack(
        children: <Widget>[
          Visibility(
            visible: _isFABOpen,
            child: GestureDetector(
              onTap: () {
                animationController.reverse();
                setState(() {
                  _isFABOpen = false;
                  iconName = 'pic.png';
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
          Stack(children: <Widget>[
            Positioned(
                left: 16,
                bottom: 16,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Colors.black.withOpacity(
                            0), // comment or change to transparent color
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                        offset: Offset.fromDirection(getRadiansFromDegree(8),
                            _cameraTranslationAnimation.value * 100),
                        child: Transform(
                            transform: Matrix4.rotationZ(
                                getRadiansFromDegree(_rotationAnimation.value))
                              ..scale(_cameraTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                _item(
                                    Image.asset(
                                      'assets/icons/camera.png',
                                      width: 30,
                                      height: 30,
                                      key: Key('take_photo_icon'),
                                    ),
                                    48.0,
                                    _theme.colorScheme.onPrimary, () {
                                  animationController.reverse();
                                  setState(() {
                                    iconName =
                                        _isFABOpen ? 'pic.png' : 'close.png';
                                    _isFABOpen = false;
                                  });
                                  widget.callback(ImageSource.camera, context);
                                }),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text(
                                    'Camera',
                                    style: _theme.textTheme.bodyText1.copyWith(
                                        color: Styleguide.color_gray_9,
                                        fontSize: 10),
                                  ),
                                )
                              ],
                            ))),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(-65),
                          _galleryTranslationAnimation.value * 80),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(_rotationAnimation.value))
                          ..scale(_galleryTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            _item(
                                Image.asset(
                                  'assets/icons/gallery.png',
                                  width: 30,
                                  height: 30,
                                  key: Key('from_gallery_icon'),
                                ),
                                48.0,
                                _theme.colorScheme.onPrimary, () {
                              animationController.reverse();
                              setState(() {
                                iconName = _isFABOpen ? 'pic.png' : 'close.png';
                                _isFABOpen = false;
                              });
                              widget.callback(ImageSource.gallery, context);
                            }),
                            Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                'Gallery',
                                style: _theme.textTheme.bodyText1.copyWith(
                                    color: Styleguide.color_gray_9,
                                    fontSize: 10),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    _item(
                        Transform(
                          transform: Matrix4.rotationZ(getRadiansFromDegree(
                              _mainRotationAnimation.value)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/icons/${iconName}',
                            width: 30,
                            height: 30,
                            key: Key('attachment_button'),
                          ),
                        ),
                        56.0,
                        _theme.colorScheme.onPrimary, () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                      setState(() {
                        iconName = _isFABOpen ? 'pic.png' : 'close.png';
                        _isFABOpen = !_isFABOpen;
                      });
                    })
                  ],
                )),
          ])
        ],
      );
    }

    return _floatingButtons();
  }
}
