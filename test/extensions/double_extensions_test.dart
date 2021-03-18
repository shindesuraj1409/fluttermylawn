import 'package:my_lawn/extensions/double_extension.dart';
import 'package:test/test.dart';

void main() {
  test('convert decimal inch to fraction greater than 1', () {
    final decimal = 1.455;
    expect(decimal.asFractionInchesString, '1 1/2"');
  });

  test('convert decimal inch to fraction less than 1', () {
    final decimal = .375;
    expect(decimal.asFractionInchesString, '3/8"');
  });
}
