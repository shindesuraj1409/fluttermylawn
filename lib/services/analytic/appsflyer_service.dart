import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/appsflyer_event.dart';

const _options = {
  'afDevKey': String.fromEnvironment('APPSFLYER_DEV_KEY'),
  'afAppId': 'com.scotts.lawnapp',
};

class AppsFlyerService {
  AppsFlyerService() : _appsflyerSdk = AppsflyerSdk(_options);

  final AppsflyerSdk _appsflyerSdk;

  void initAppsFlyer() {
    if (kReleaseMode) {
      _appsflyerSdk.initSdk();
    }
  }

  void tagEvent(AppsFlyerEvent event) {
    if (kReleaseMode) {
      _appsflyerSdk.logEvent(event.eventName, event.args);
    }
  }
}
