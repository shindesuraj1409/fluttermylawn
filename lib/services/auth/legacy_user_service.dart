import 'dart:convert';
import 'dart:io';

import 'package:analytics/analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:local_storage/local_storage.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/auth/i_legacy_user_service.dart';

class LegacyUserServiceImpl extends LegacyUserService {
  final GigyaService _gigyaService;
  final LocalStorage _localStorage;
  final Analytics _analytics;
  final MethodChannel realmChannel =
      const MethodChannel('com.scotts.lawnapp/realm');

  LegacyUserServiceImpl(
      this._gigyaService, this._localStorage, this._analytics);

  @override
  Future<void> saveLegacyUserId() async {
    try {
      final userId = Platform.isIOS
          ? await _fetchIOSUserId()
          : await _fetchAndroidUserId();

      if (userId == 0) return;

      final response =
          await _gigyaService.setAccountInfo(data: {'legacyUserId': '$userId'});

      //Fire save_legacy_user event so we can keep track of user transition occurrences.
      //Delete the old data after its backed up, in the event they log out, then log back in.
      if (response.statusCode == 200) {
        await _analytics
            .logEvent('save_legacy_user', parameters: {'legacyUserId': userId});

        Platform.isIOS
            ? await realmChannel.invokeMethod('deleteRealm')
            : await _localStorage.delete('user_multiple_lawns');
      }
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  Future<int> _fetchIOSUserId() async {
    final userId = await realmChannel.invokeMethod('getLegacyUserId');
    return userId;
  }

  Future<int> _fetchAndroidUserId() async {
    final jsonString = await _localStorage.read('user_multiple_lawns');
    if (jsonString == null) return 0;
    final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return userMap['userId'] ?? 0;
  }
}
