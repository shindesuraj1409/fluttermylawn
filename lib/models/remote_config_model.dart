import 'package:bus/bus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/remote_config_data.dart';
import 'package:package_info/package_info.dart';
import 'package:pedantic/pedantic.dart';
import 'package:pub_semver/pub_semver.dart';

class RemoteConfigModel with Bus {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final RemoteConfig remoteConfig;
  final bool debugMode;

  var _didConfigure = false;
  var _didUpdate = false;

  RemoteConfigModel({
    this.remoteConfig,
    this.debugMode = false,
  });

  @override
  void onInit() {
    assert(_didUpdate, 'You must call updateRemoteConfig() before use.');

    _firebaseMessaging.configure(
      onMessage: _onFcmMessage,
      onLaunch: null,
      onResume: null,
      onBackgroundMessage: null,
    );
    _firebaseMessaging.subscribeToTopic('ML_remoteConfig');

    super.onInit();
  }

  @override
  void onDestroy() {
    _firebaseMessaging.unsubscribeFromTopic('ML_remoteConfig');

    remoteConfig.dispose();

    super.onDestroy();
  }

  Future<dynamic> _onFcmMessage(Map<String, dynamic> message) async =>
      registry<RemoteConfigModel>().updateRemoteConfig(forceRefetch: true);

  Future<bool> _isUpdateNeeded(String forceUpdateVersion) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final buildVersion = Version.parse(packageInfo.version);
      final forceVersion = Version.parse(forceUpdateVersion);

      return buildVersion < forceVersion;
    } on Exception catch (e) {
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }

    return false;
  }

  void updateRemoteConfig({forceRefetch = false}) async {
    if (!_didConfigure) {
      try {
        await remoteConfig
            .setConfigSettings(RemoteConfigSettings(debugMode: debugMode));
        _didConfigure = true;
      } catch (e) {
        log.warning('Exception: ${e.toString()}');
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }

    try {
      // Try to always fetch the very latest remote config.
      await remoteConfig.fetch(
          expiration: Duration(hours: debugMode || forceRefetch ? 0 : 1));
    } on FetchThrottledException catch (e) {
      log.warning('Throttled until ${e.throttleEnd.toIso8601String()}');
    } catch (e) {
      log.warning('Exception: ${e.toString()}');
    }
    await remoteConfig.activateFetched();

    // RemoteConfig.setDefaults threw a PlatformException, so defaults
    // are defined here instead. Different strategy, same result.
    final isKillSwitchActive =
        (remoteConfig.getInt('ML_kill_switch_active') ?? 1) == 1;
    final killSwitchMessage =
        remoteConfig.getString('ML_kill_switch_message') ??
            'My Lawn is currently unavailable. '
                'Please check back in a little while. '
                'We apologize for the inconvenience.';
    final isForceUpdateActive =
        (remoteConfig.getInt('ML_force_update_active') ?? 0) == 1;
    final forceUpdateVersion =
        remoteConfig.getString('ML_force_update_minimum_version');
    final forceUpdateMessage =
        remoteConfig.getString('ML_force_update_message');

    _didUpdate = true;

    publish(
      data: RemoteConfigData(
        isKillSwitchActive: isKillSwitchActive,
        killSwitchMessage: killSwitchMessage,
        isForceUpdateActive:
            isForceUpdateActive && await _isUpdateNeeded(forceUpdateVersion),
        forceUpdateVersion: forceUpdateVersion,
        forceUpdateMessage: forceUpdateMessage,
      ),
    );
  }

  @override
  List<Channel> get channels => [Channel(RemoteConfigData)];
}
