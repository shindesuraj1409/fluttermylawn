import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

const _defaultBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(4)),
  side: BorderSide(color: Styleguide.color_green_4),
);

class BaseButton extends StatelessWidget {
  final Alignment alignment;
  final BorderRadius borderRadius;
  final Color color;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double height;
  final double width;
  final Widget child;
  final GestureTapCallback onTap;

  BaseButton({
    this.alignment,
    this.borderRadius,
    this.color,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: alignment,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: color,
          ),
          child: child,
        ),
      ),
    );
  }
}

class FullTextButton extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final bool isDisabled;
  final Color disabledColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String text;
  final GestureTapCallback onTap;
  final Color borderColor;
  final ShapeBorder border;

  FullTextButton({
    key,
    this.backgroundColor = Styleguide.color_gray_0,
    this.color,
    this.isDisabled = false,
    this.disabledColor,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.text = 'TEST',
    this.onTap,
    this.borderColor = Styleguide.color_green_4,
    this.border = _defaultBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final raisedButton = RaisedButton(
      onPressed: isDisabled ? null : onTap,
      color: backgroundColor,
      disabledColor: disabledColor,
      shape: border,
      elevation: 0,
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        padding: padding,
        width: double.infinity,
        child: Text(
          text,
          style: _theme.textTheme.button.copyWith(color: color),
        ),
      ),
    );

    return isDisabled
        ? Opacity(
            opacity: 0.6,
            child: raisedButton,
          )
        : raisedButton;
  }
}

class TappableText extends StatelessWidget {
  final Alignment alignment;
  final Color backgroundColor;
  final Color color;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final GestureTapCallback onTap;

  TappableText({
    this.alignment,
    this.backgroundColor,
    this.color,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.child,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: child,
        alignment: alignment,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
      ),
    );
  }
}
