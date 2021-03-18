import 'package:data/data.dart';

class DeviceData extends Data {
  final String manufacturer;
  final String model;
  final String version;

  DeviceData({
    this.manufacturer,
    this.model,
    this.version,
  });

  @override
  List<Object> get props => [manufacturer, model, version];
}

