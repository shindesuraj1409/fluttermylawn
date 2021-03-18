import 'dart:async';

import 'package:my_lawn/services/deep_links/i_deep_links.dart';

class FakeDeeplink extends DeepLinks {
  final _streamController = StreamController<Uri>.broadcast();

  void dispose() {
    _streamController.close();
  }

  @override
  Future<Uri> getInitialUri() => Future.value(Uri(path: '/'));

  @override
  Stream<Uri> getUriLinksStream() => _streamController.stream;

  void raise(Uri uri) {
    _streamController.sink.add(uri);
  }
}
