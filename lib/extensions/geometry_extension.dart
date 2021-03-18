import 'dart:math';

extension GeometryDoubleExtension on double {
  /// Returns radians, converted from degrees.
  double toRadians() => this / 180 * pi;

  /// Returns degrees, converted from radians.
  double toDegrees() => this * 180 / pi;

  /// Wraps the given value into the inclusive-exclusive interval
  /// between min and max, and returns the wrapped value.
  double wrap(double min, double max) =>
      (this >= min && this < max) ? this : ((this - min).mod(max - min) + min);

  /// Returns the non-negative remainder of operand / modulus.
  double mod(double modulus) => ((this % modulus) + modulus) % modulus;
}
