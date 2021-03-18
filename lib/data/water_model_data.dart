import 'package:data/data.dart';
import 'package:my_lawn/data/plot_data.dart';
import 'package:my_lawn/data/water_balance_data.dart';

class WaterModel extends Data {
  final PlotData plot;
  final WaterBalance waterBalance;
  final List<NozzleType> nozzleTypes;
  final NozzleType selectedNozzleType;
  final double waterGoal;
  final DateTime dateTime;

  WaterModel(
    this.plot,
    this.waterBalance,
    this.waterGoal,
    this.dateTime,
    this.nozzleTypes,
    this.selectedNozzleType,
  );

  @override
  List<Object> get props => [plot, waterBalance, waterGoal, dateTime];
}

class NozzleType extends Data {
  final String name;
  final double rate;
  final String imageUrl;

  NozzleType(this.name, this.rate, this.imageUrl);

  factory NozzleType.fromMap(Map<String, dynamic> map) {
    return NozzleType(
      map['name'],
      map['rate'] + 0.0,
      map['imageUrl'],
    );
  }

  @override
  List<Object> get props => [name, rate, imageUrl];
}
