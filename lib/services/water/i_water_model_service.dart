import 'package:my_lawn/data/plot_data.dart';
import 'package:my_lawn/data/water_balance_data.dart';
import 'package:my_lawn/data/water_model_data.dart';

abstract class WaterModelService {
  Future<PlotData> getPlot(String customerId);
  Future<void> updatePlot(PlotData plot);
  Future<String> createPlot(String customerId, int zipCode);
  Future<WaterBalance> getWaterBalanceData(String customerId, String plotId);
  Future<WaterBalance> getWaterDataGuest(String zipCode);
  Future<List<NozzleType>> getNozzleTypes();
}
