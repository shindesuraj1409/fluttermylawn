import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/data/plot_data.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';

class MockWaterService extends Mock implements WaterModelService {}

void main() {
  group('WaterBloc', () {
    WaterModelService weatherService;
    final customerId = 'customerId';
    final zipCode = '12313';

    setUp(() {
      weatherService = MockWaterService();
      when(weatherService.getPlot(customerId))
          .thenAnswer((realInvocation) async => PlotData());
    });

    test('throws AssertionError when WaterBloc is null', () {
      expect(() => WaterBloc(null), throwsAssertionError);
    });

    test('initial state is WaterStatus.initial()', () {
      final bloc = WaterBloc(weatherService);
      expect(bloc.state, WaterState.initial());
      bloc.close();
    });

    blocTest<WaterBloc, WaterState>(
        'emits [WaterStatus, WaterStatus.weatherDataLoaded()]',
        build: () => WaterBloc(weatherService),
        act: (bloc) => bloc.add(GetWaterDataEvent(customerId, zipCode)),
        verify: (_) {
          verify(weatherService.getPlot(customerId)).called(1);
        });
  });
}
