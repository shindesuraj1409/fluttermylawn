import 'package:flutter_acpplaces_monitor/flutter_acpplaces_monitor.dart' show  FlutterACPPlacesMonitor;

import 'package:flutter_acpplaces_monitor/src/flutter_acpplaces_monitor_location_permission.dart';
import 'package:flutter_acpplaces_monitor/src/flutter_acpplaces_monitor_modes.dart';
import 'package:my_lawn/services/places/places_enum.dart';

abstract class AdobeMonitorPlacesService {
  Future<String> getSdkVersion();

  void startMonitoring();

  void stopMonitoring();

  void updateLocation();

  void setRequestLocationPermission(
    FlutterACPPlacesMonitorLocationPermission monitorLocationPermission,
  );

  void setPlacesMonitorMode(
    FlutterACPPlacesMonitorModes flutterACPPlacesMonitorModes,
  );

  FlutterACPPlacesMonitorLocationPermission getMonitorLocationPermissionEnum(
    MonitorLocationPermission monitorLocationPermission,
  );

  FlutterACPPlacesMonitorModes getPlacesMonitorModeEnum(
    PlacesMonitorModes placesMonitorModes,
  );
}

class AdobeMonitorPlacesServiceImpl implements AdobeMonitorPlacesService {
  static const String TAG = 'AdobeMonitorPlacesService';

  @override
  Future<String> getSdkVersion() async {
    final version = await FlutterACPPlacesMonitor.extensionVersion;

    return version;
  }

  ///Start the Places Monitor
  @override
  void startMonitoring() {
    FlutterACPPlacesMonitor.start();
  }

  ///Stop the Places Monitor
  @override
  void stopMonitoring() {
    const clearData = true;

    FlutterACPPlacesMonitor.stop(clearData);
  }

  ///Update the device's location
  @override
  void updateLocation() {
    FlutterACPPlacesMonitor.updateLocation();
  }

  ///Set or upgrade the location permission request (Android) / request authorization level (iOS)
  @override
  void setRequestLocationPermission(
    FlutterACPPlacesMonitorLocationPermission monitorLocationPermission,
  ) {
    FlutterACPPlacesMonitor.setRequestLocationPermission(
      monitorLocationPermission,
    );
  }

  ///Set the monitoring mode (iOS only):
  @override
  void setPlacesMonitorMode(
    FlutterACPPlacesMonitorModes flutterACPPlacesMonitorModes,
  ) {
    FlutterACPPlacesMonitor.setPlacesMonitorMode(flutterACPPlacesMonitorModes);
  }

  ///Function for converting [MonitorLocationPermission] for inide app enum to [FlutterACPPlacesMonitorLocationPermission] enum
  ///from package:flutter_acpplaces_monitor/flutter_acpplaces_monitor.dart
  @override
  FlutterACPPlacesMonitorLocationPermission getMonitorLocationPermissionEnum(
    MonitorLocationPermission monitorLocationPermission,
  ) {
    switch (monitorLocationPermission) {
      case MonitorLocationPermission.WHILE_USING_APP:
        return FlutterACPPlacesMonitorLocationPermission.WHILE_USING_APP;
      case MonitorLocationPermission.ALWAYS_ALLOW:
        return FlutterACPPlacesMonitorLocationPermission.ALWAYS_ALLOW;
      case MonitorLocationPermission.NONE:
        return FlutterACPPlacesMonitorLocationPermission.NONE;

      default:
        return FlutterACPPlacesMonitorLocationPermission.NONE;
    }
  }

  @override
  FlutterACPPlacesMonitorModes getPlacesMonitorModeEnum(
    PlacesMonitorModes placesMonitorModes,
  ) {
    switch (placesMonitorModes) {
      case PlacesMonitorModes.CONTINUOUS:
        return FlutterACPPlacesMonitorModes.CONTINUOUS;
      case PlacesMonitorModes.SIGNIFICANT_CHANGES:
        return FlutterACPPlacesMonitorModes.SIGNIFICANT_CHANGES;

      default:
        return FlutterACPPlacesMonitorModes.SIGNIFICANT_CHANGES;
    }
  }
}


