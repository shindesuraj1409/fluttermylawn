import 'package:my_lawn/data/connectivity_data.dart';
import 'package:test/test.dart';

void main() {
  group('constructors', () {
    test('() default constructor', () {
      final connectivityData = ConnectivityData();

      expect(connectivityData.isValid, isFalse);
      expect(connectivityData.isMobile, isFalse);
      expect(connectivityData.isWifi, isFalse);
      expect(connectivityData.hasInternet, isFalse);
    });
    test('() default constructor with values', () {
      final connectivityData = ConnectivityData(
        isValid: true,
        isMobile: false,
        isWifi: true,
        hasInternet: false,
      );

      expect(connectivityData.isValid, isTrue);
      expect(connectivityData.isMobile, isFalse);
      expect(connectivityData.isWifi, isTrue);
      expect(connectivityData.hasInternet, isFalse);
    });
    test('.clone() clone default constructor', () {
      final emptyConnectivityData = ConnectivityData();

      final clonedConnectivityData =
          ConnectivityData(connectivityData: emptyConnectivityData);

      expect(clonedConnectivityData.isValid, isFalse);
      expect(clonedConnectivityData.isMobile, isFalse);
      expect(clonedConnectivityData.isWifi, isFalse);
      expect(clonedConnectivityData.hasInternet, isFalse);
    });
    test('.clone() clone default constructor with values', () {
      final emptyConnectivityData = ConnectivityData();

      final clonedConnectivityData = ConnectivityData(
        connectivityData: emptyConnectivityData,
        isMobile: false,
        isWifi: true,
        hasInternet: false,
      );

      expect(clonedConnectivityData.isValid, isFalse);
      expect(clonedConnectivityData.isMobile, isFalse);
      expect(clonedConnectivityData.isWifi, isTrue);
      expect(clonedConnectivityData.hasInternet, isFalse);
    });
  });
  group('operators', () {
    test('== equality', () {
      expect(ConnectivityData(), equals(ConnectivityData()));
      expect(
        ConnectivityData(
          isValid: true,
          isMobile: false,
          isWifi: true,
          hasInternet: false,
        ),
        equals(
          ConnectivityData(
            isValid: true,
            isMobile: false,
            isWifi: true,
            hasInternet: false,
          ),
        ),
      );
      expect(
        ConnectivityData(),
        isNot(equals(
          ConnectivityData(
            isValid: true,
            isMobile: false,
            isWifi: true,
            hasInternet: false,
          ),
        )),
      );
    });
  });
  group('methods', () {
    test('.toString()', () {
      final connectivityData = ConnectivityData();

      expect(connectivityData.toString(), isA<String>());
      expect(connectivityData.toString(), isNotNull);
    });
  });
}
