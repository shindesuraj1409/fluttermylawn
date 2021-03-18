import 'package:data/data.dart';
import 'package:my_lawn/extensions/double_extension.dart';

class WaterBalance extends Data {
  final double inches;
  final double minutes;
  final List<double> precipitation;
  final List<double> water;
  final double totalRain;
  final double totalWater;

  WaterBalance({
    this.inches,
    this.minutes,
    this.precipitation,
    this.water,
    this.totalRain,
    this.totalWater,
  });

  @override
  List<Object> get props => [inches, minutes, precipitation, water];

  factory WaterBalance.fromMap(Map<String, dynamic> map,
      {bool withDefaults = false}) {
    if (map == null) return null;

    final precipitationList = List<double>.from(map['precipitations']
        ?.map((x) => ((x['precipAmount'] ?? 0) + 0.0.toPrecision(2))));
    final waterList = List<double>.from(
        map['water']?.map((x) => ((x['waterQty'] ?? 0) + 0.0.toPrecision(2))));
    final double totalRain =
        precipitationList.fold(0, (prev, current) => prev + current) + .0;
    final double totalWater =
        waterList.fold(0, (prev, current) => prev + current) + .0;

    if (withDefaults) {
      final defaultGoal = 1.0;
      final defaultNozzleRate = 0.0108;
      final remainingInches = (defaultGoal - totalRain).toPrecision(2);

      return WaterBalance(
        inches: remainingInches,
        minutes: remainingInches / defaultNozzleRate,
        precipitation: precipitationList,
        water: waterList,
        totalRain: totalRain.toPrecision(2),
        totalWater: totalWater.toPrecision(2),
      );
    }

    final double inches = (map['inches'] ?? 0.0) + .0;

    return WaterBalance(
      inches: inches.toPrecision(2),
      minutes: (map['minutes'] ?? 0) + .0,
      precipitation: precipitationList,
      water: waterList,
      totalRain: totalRain.toPrecision(2),
      totalWater: totalWater.toPrecision(2),
    );
  }
}
