import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/plot_data.dart';
import 'package:my_lawn/data/water_model_data.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';
import 'package:my_lawn/services/water/water_exception.dart';
import 'package:pedantic/pedantic.dart';

part 'water_event.dart';
part 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  WaterBloc(this._service)
      : assert(
            _service != null, 'Weather Service is required to use WeatherBloc'),
        super(WaterState.initial());
  final WaterModelService _service;

  @override
  Stream<WaterState> mapEventToState(
    WaterEvent event,
  ) async* {
    if (event is GetWaterDataEvent) {
      try {
        yield WaterState.loading();

        final weatherData = await getWaterData(
          event.customerId,
          event.zipCode,
        );

        yield WaterState.weatherDataLoaded(weatherData);
      } on WaterException catch (exception) {
        yield WaterState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield WaterState.error('Couldn\'t get plot information');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
    if (event is RefreshWaterDataEvent) {
      try {
        yield WaterState.refreshing(state.waterData);

        final weatherData = await getWaterData(
          event.customerId,
          event.zipCode,
        );

        yield WaterState.weatherDataLoaded(weatherData);
      } on WaterException catch (exception) {
        yield WaterState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield WaterState.error('Couldn\'t get plot information');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }

    if (event is UpdateNozzleTypeEvent) {
      try {
        yield WaterState.loading();

        await _service
            .updatePlot(event.plot.copyWith(nozzleType: event.nozzleType.name));

        add(GetWaterDataEvent(event.plot.customerId, '${event.plot.zipCode}'));
      } on WaterException catch (exception) {
        yield WaterState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield WaterState.error('Couldn\'t get plot information');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
    if (event is UpdateWaterGoalEvent) {
      try {
        yield WaterState.loading();

        await _service
            .updatePlot(event.plot.copyWith(goal: event.selectedGoal));

        add(GetWaterDataEvent(event.plot.customerId, '${event.plot.zipCode}'));
      } on WaterException catch (exception) {
        yield WaterState.error(exception.errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield WaterState.error('Couldn\'t get plot information');
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
  }

  Future<WaterModel> getWaterData(String customerId, String zipCode) async {
    if (customerId == null) {
      //User is a guest
      final waterBalance = await _service.getWaterDataGuest(zipCode);
      final nozzleTypes = await _service.getNozzleTypes();
      final selectedNozzle = nozzleTypes.firstWhere(
        (element) => element.name == 'Sprinklers',
        orElse: () => null,
      );
      final goal = 1.0;

      return WaterModel(
        null,
        waterBalance,
        goal,
        DateTime.now(),
        nozzleTypes,
        selectedNozzle,
      );
    } else {
      var plot = await _service.getPlot(customerId);

      if (plot == null) {
        await _service.createPlot(customerId, int.tryParse(zipCode));
        plot = await _service.getPlot(customerId);
      }

      final nozzleTypes = await _service.getNozzleTypes();
      final selectedNozzle =
          nozzleTypes.firstWhere((element) => element.name == plot.nozzleType);

      final waterBalance =
          await _service.getWaterBalanceData(customerId, plot.id);

      return WaterModel(
        plot,
        waterBalance,
        plot.goal,
        DateTime.now(),
        nozzleTypes,
        selectedNozzle,
      );
    }
  }
}
