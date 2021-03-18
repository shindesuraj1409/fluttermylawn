import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/plot_data.dart';
import 'package:my_lawn/data/water_balance_data.dart';
import 'package:my_lawn/data/water_model_data.dart';
import 'package:my_lawn/services/water/water_exception.dart';
import 'package:my_lawn/services/water/water_model_request_bodies.dart';

import '../scotts_api_client.dart';
import 'i_water_model_service.dart';

class WaterModelServiceImpl implements WaterModelService {
  final ScottsApiClient _apiClient;
  final String _basePath;

  final defaultQueryParameters = {
    'dateFrom':
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: -6))),
    'dateTo': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  };

  WaterModelServiceImpl()
      : _apiClient = registry<ScottsApiClient>(),
        _basePath = '/water/v1/water';

  @override
  Future<PlotData> getPlot(String customerId) async {
    try {
      final response = await _apiClient.get('$_basePath/$customerId/plots');
      if (response.statusCode == 200) {
        final List decodedList = json.decode(response.body);
        final results = <PlotData>[];
        if (decodedList.isEmpty) return null;
        decodedList.forEach((element) {
          results.add(PlotData.fromMap(element));
        });
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return results.first;
      }
      throw WaterException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WaterBalance> getWaterBalanceData(
      String customerId, String plotId) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/$customerId/balance/$plotId',
        queryParameters: defaultQueryParameters,
      );

      if (response.statusCode == 200) {
        return WaterBalance.fromMap(jsonDecode(response.body));
      }
      throw WaterException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createPlot(String customerId, int zipCode) async {
    try {
      final request = CreatePlotRequest(
        name: 'My Lawn',
        zipCode: zipCode,
        city: 'Columbus',
        state: 'OH',
        address1: '123 Main St',
        address2: 'Apt 1',
        slope: 0,
        soilType: 'Loam',
        plantType: 'Grass',
        nozzleType: 'Drip',
        goal: 1,
      );
      final response = await _apiClient.post(
        '$_basePath/$customerId/plot',
        body: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body)['id'];
      }
      throw WaterException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NozzleType>> getNozzleTypes() async {
    try {
      final response = await _apiClient.get('$_basePath/nozzleTypes');

      if (response.statusCode == 200) {
        final List decodedList = json.decode(response.body);
        final results = <NozzleType>[];
        if (decodedList.isEmpty) return results;
        decodedList.forEach((element) {
          results.add(NozzleType.fromMap(element));
        });
        return results;
      }
      throw WaterException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePlot(PlotData plot) async {
    try {
      final response = await _apiClient.put(
        '$_basePath/${plot.customerId}/plot/${plot.id}',
        body: plot.toMap(),
      );
      if (response.statusCode != 200) {
        throw WaterException(errorMessage: response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WaterBalance> getWaterDataGuest(String zipCode) async {
    try {
      final response = await _apiClient.get(
        'water/v1/waterGuest/$zipCode',
        queryParameters: defaultQueryParameters,
      );

      if (response.statusCode == 200) {
        return WaterBalance.fromMap(jsonDecode(response.body),
            withDefaults: true);
      }
      throw WaterException(errorMessage: response.body);
    } catch (e) {
      rethrow;
    }
  }
}
