import 'package:my_lawn/data/app_data.dart';
import 'package:test/test.dart';

void main() {
  group('constructors', () {
    test('() default constructor', () {
      final appData = AppData();

      expect(appData.isFirstRun, isTrue);
      expect(appData.isDarkModeEnabled, isFalse);
    });
    test('() default constructor with values', () {
      final appData = AppData(
        isFirstRun: false,
        isDarkModeEnabled: true,
      );

      expect(appData.isFirstRun, isFalse);
      expect(appData.isDarkModeEnabled, isTrue);
    });
    test('() default constructor with model', () {
      final appData = AppData();

      final clonedAppData = AppData(appData: appData);

      expect(clonedAppData.isFirstRun, isTrue);
      expect(clonedAppData.isDarkModeEnabled, isFalse);
    });
    test('() default constructor with model and values', () {
      final appData = AppData();

      final clonedAppData = AppData(
        appData: appData,
        isFirstRun: false,
        isDarkModeEnabled: true,
      );

      expect(clonedAppData.isFirstRun, isFalse);
      expect(clonedAppData.isDarkModeEnabled, isTrue);
    });
  });
  group('operators', () {
    test('== equality', () {
      expect(AppData(), equals(AppData()));
      expect(
        AppData(
          isFirstRun: false,
          isDarkModeEnabled: true,
        ),
        equals(
          AppData(
            isFirstRun: false,
            isDarkModeEnabled: true,
          ),
        ),
      );
      expect(
        AppData(
          isFirstRun: true,
          isDarkModeEnabled: false,
        ),
        isNot(equals(
          AppData(
            isFirstRun: false,
            isDarkModeEnabled: true,
          ),
        )),
      );
    });
  });
  group('methods', () {
    test('.toString()', () {
      final appData = AppData();

      expect(appData.toString(), isA<String>());
      expect(appData.toString(), isNotNull);
    });
    test('.toMap() create map from default AppData', () {
      final appData = AppData();

      final appDataMap = appData.toMap();

      expect(appDataMap['isFirstRun'], equals(appData.isFirstRun));
      expect(
          appDataMap['isDarkModeEnabled'], equals(appData.isDarkModeEnabled));
    });
    test('.toMap() create map from empty AppData', () {
      final appData = AppData();

      final appDataMap = appData.toMap();

      expect(appDataMap['isFirstRun'], equals(appData.isFirstRun));
      expect(
          appDataMap['isDarkModeEnabled'], equals(appData.isDarkModeEnabled));
    });
    test('.toMap() create map from AppData with values', () {
      final appData = AppData(
        isFirstRun: false,
        isDarkModeEnabled: true,
      );

      final appDataMap = appData.toMap();

      expect(appDataMap['isFirstRun'], equals(appData.isFirstRun));
      expect(
          appDataMap['isDarkModeEnabled'], equals(appData.isDarkModeEnabled));
    });
  });
}
