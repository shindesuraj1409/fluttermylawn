import 'dart:io';

import 'package:http_proxy/http_proxy.dart';

Future<void> configureProxy() async {
  final httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
}
