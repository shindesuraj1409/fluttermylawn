import 'package:my_lawn/extensions/string_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtensions', () {
    group('email', () {
      test('is valid email', () {
        expect('test@scotts.com'.isValidEmail, true);
      });

      test('is not valid email', () {
        expect('test.scotts.com'.isValidEmail, false);
      });
    });

    group('coverage', () {
      test('find smallest int with multiple values', () {
        final coverageString =
            'New Lawn: 2,265 sq. ft. / Overseeding: 8,000 sq. ft.';
        expect(coverageString.smallestCoverageArea, 2265);
      });

      test('find smallest int with single value', () {
        final coverageString = 'Overseeding: 8,000 sq. ft.';
        expect(coverageString.smallestCoverageArea, 8000);
      });

      test('return null if empty', () {
        final coverageString = 'Random';
        expect(coverageString.smallestCoverageArea, null);
      });
    });
  });
}
