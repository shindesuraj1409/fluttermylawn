import 'package:fraction/fraction.dart';

extension DoubleExtensions on double {
  String get asFractionInchesString {
    final precision = 8;
    final inches = toInt();
    final numerator = ((this - inches) * precision).round();
    final fraction = Fraction.fromDouble(numerator / precision);

    return inches == 0 ? '$fraction"' : '$inches $fraction"';
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(2));
}
