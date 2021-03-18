import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends TextSpan {
  Hyperlink(node, next, BuildContext context)
      : assert(node['data'] != null),
        assert(node['data']['uri'] != null), // ensure uri exists for hyperlink
        assert(node['data']['uri'] != ''),
        super(
          text: node['value'],
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Styleguide.color_green_4, fontWeight: FontWeight.w600),
          children: next(node['content']),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              registry<Logger>().d(node['data']['uri']);
              final uri = node['data']['uri'];
              // NOTE: Defaults to Url_Launcher, but component can be overridden
              if (await canLaunch(uri)) {
                await launch(uri);
              }
            },
        );
}
