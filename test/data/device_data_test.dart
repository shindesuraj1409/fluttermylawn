import 'package:my_lawn/data/device_data.dart';
import 'package:test/test.dart';

void main() {
  group('constructors', () {
    test('() default constructor', () {
      final deviceData = DeviceData();

      expect(deviceData.manufacturer, isNull);
      expect(deviceData.model, isNull);
      expect(deviceData.version, isNull);
    });
    test('() default constructor with values', () {
      final deviceData = DeviceData(
        manufacturer: 'manufacturer',
        model: 'model',
        version: 'version',
      );

      expect(deviceData.manufacturer, equals('manufacturer'));
      expect(deviceData.model, equals('model'));
      expect(deviceData.version, equals('version'));
    });
  });
  group('operators', () {
    test('== equality', () {
      expect(DeviceData(), equals(DeviceData()));
      expect(
        DeviceData(
          manufacturer: 'manufacturer',
          model: 'model',
          version: 'version',
        ),
        equals(
          DeviceData(
            manufacturer: 'manufacturer',
            model: 'model',
            version: 'version',
          ),
        ),
      );
      expect(
        DeviceData(),
        isNot(equals(
          DeviceData(
            manufacturer: 'manufacturer',
            model: 'model',
            version: 'version',
          ),
        )),
      );
    });
  });
  group('methods', () {
    test('.toString()', () {
      final deviceData = DeviceData();

      expect(deviceData.toString(), isA<String>());
      expect(deviceData.toString(), isNotNull);
    });
  });
}
