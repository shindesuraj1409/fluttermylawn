part of 'water_bloc.dart';

abstract class WaterEvent extends Equatable {
  const WaterEvent();
}

class GetWaterDataEvent extends WaterEvent {
  final String customerId;
  final String zipCode;

  GetWaterDataEvent(this.customerId, this.zipCode);

  @override
  List<Object> get props => [customerId, zipCode];
}

class RefreshWaterDataEvent extends WaterEvent {
  final String customerId;
  final String zipCode;

  RefreshWaterDataEvent(this.customerId, this.zipCode);

  @override
  List<Object> get props => [customerId, zipCode];
}

class UpdateNozzleTypeEvent extends WaterEvent {
  final PlotData plot;
  final NozzleType nozzleType;

  UpdateNozzleTypeEvent(this.plot, this.nozzleType);

  @override
  List<Object> get props => [plot, nozzleType];
}

class UpdateWaterGoalEvent extends WaterEvent {
  final PlotData plot;
  final double selectedGoal;

  UpdateWaterGoalEvent(this.plot, this.selectedGoal);

  @override
  List<Object> get props => [plot, selectedGoal];
}
