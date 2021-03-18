import 'package:data/data.dart';

class AppData extends Data {
  final bool isFirstRun;
  final bool isDarkModeEnabled;
  final bool arePushNotificationsEnabled;
  final bool isLocationEnabled;

  AppData({
    AppData appData,
    bool isFirstRun,
    bool isDarkModeEnabled,
    bool arePushNotificationsEnabled,
    bool isLocationEnabled,
  })  : isFirstRun = isFirstRun ?? appData?.isFirstRun ?? true,
        isDarkModeEnabled =
            isDarkModeEnabled ?? appData?.isDarkModeEnabled ?? false,
        arePushNotificationsEnabled = arePushNotificationsEnabled ??
            appData?.arePushNotificationsEnabled ??
            false,
        isLocationEnabled =
            isLocationEnabled ?? appData?.isLocationEnabled ?? false;

  @override
  List<String> get propsNames => [
        'isFirstRun',
        'isDarkModeEnabled',
        'arePushNotificationsEnabled',
        'isLocationEnabled',
      ];

  @override
  List<Object> get props => [
        isFirstRun,
        isDarkModeEnabled,
        arePushNotificationsEnabled,
        isLocationEnabled,
      ];
}
