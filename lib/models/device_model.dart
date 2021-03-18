import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:bus/bus.dart';
import 'package:my_lawn/data/device_data.dart';

class DeviceModel with Bus {
  DeviceModel() {
    _updateDeviceData();
  }

  @override
  List<Channel> get channels => [Channel(DeviceData)];

  Future<void> _updateDeviceData() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      DeviceData deviceData;
      if (Platform.isAndroid) {
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        deviceData = DeviceData(
          manufacturer: deviceInfo.manufacturer,
          model: deviceInfo.model,
          version: 'Android ${deviceInfo.version.release}',
        );
      } else if (Platform.isIOS) {
        final deviceInfo = await deviceInfoPlugin.iosInfo;
        deviceData = DeviceData(
          manufacturer: 'Apple',
          model: deviceInfo.model,
          version: '${deviceInfo.systemName} ${deviceInfo.systemVersion}',
        );
      }
      if (deviceData != null) {
        log.fine(deviceData);
        publish(data: deviceData);
      }
    } on PlatformException {
      // Do nothing.
    }
  }
}
