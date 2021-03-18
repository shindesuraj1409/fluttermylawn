import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/registry_config.dart';

/// A basic text span, optionally interspersed with web links,
/// navigational links, or callback functions.
class TextWithOptionalActions extends StatelessWidget {
  final List<dynamic> children;
  final TextStyle style;
  final TextStyle actionStyle;
  final TextAlign textAlign;

  TextWithOptionalActions({
    @required this.children,
    this.style,
    this.actionStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        style: style ?? theme.textTheme.bodyText2,
        children: children
            .map(
              (child) => child is List
                  ? TextSpan(
                      text: child.first,
                      style: actionStyle ??
                          theme.textTheme.bodyText1.copyWith(
                            color: theme.primaryColor,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (child.last is Function) {
                            child.last();
                          } else if (child.last is String) {
                            if (child.last.toString().startsWith('http://') ||
                                child.last.toString().startsWith('https://')) {
                              launch(child.last);
                            } else {
                              registry<Navigation>().push(
                                child.last,
                              );
                            }
                          }
                        })
                  : child is String
                      ? TextSpan(text: child)
                      : child as InlineSpan,
            )
            .toList(),
      ),
      textAlign: textAlign,
    );
  }
}
