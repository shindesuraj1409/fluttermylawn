part of 'water_bloc.dart';

enum WaterStatus { initial, loading, error, loaded, refreshing }

class WaterState extends Equatable {
  const WaterState._(
      {this.waterData,
      this.errorMessage = '',
      this.status = WaterStatus.initial});

  final WaterModel waterData;
  final String errorMessage;
  final WaterStatus status;

  const WaterState.initial() : this._();

  const WaterState.loading() : this._(status: WaterStatus.loading);

  const WaterState.refreshing(WaterModel weatherData)
      : this._(waterData: weatherData, status: WaterStatus.refreshing);

  const WaterState.error(String errorMessage)
      : this._(errorMessage: errorMessage, status: WaterStatus.error);

  const WaterState.weatherDataLoaded(WaterModel weatherData)
      : this._(waterData: weatherData, status: WaterStatus.loaded);

  @override
  List<Object> get props => [waterData, errorMessage, status];
}
