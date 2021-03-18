import 'package:flutter/material.dart';
import 'package:my_lawn/extensions/route_arguments_extension.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

/// A screen that has a scaffold with titled app bar, and a web view child.
class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;

  WebViewScreen({
    this.title,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    final arguments = routeArguments(context);
    // NOTE: WebView does not play nice with nested scrolling,
    // which is why we are not using the sliver app bar version.
    return BasicScaffoldWithAppBar(
      titleString: title ?? arguments['title'] ?? arguments?.title,
      child: WebView(
        initialUrl: url ?? arguments['url'] ?? arguments?.url,
        javascriptMode: JavascriptMode.unrestricted,
        key: Key(
            title.removeNonCharsMakeLowerCaseMethod(identifier: '_webview')),
      ),
    );
  }
}
