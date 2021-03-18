import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final dynamic node;
  final List<dynamic> assets;
  Images({this.node, this.assets});

  @override
  Widget build(BuildContext context) {
    final String imageId = node['data']['target']['sys']['id'];

    final url = 'http:' +
        assets.firstWhere((el) => el['sys']['id'] == imageId)['fields']['file']
            ['url'];

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Image.network(
          url,
          frameBuilder: (BuildContext context, Widget child, int frame,
              bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              child: child,
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
            );
          },
        ));
  }
}
