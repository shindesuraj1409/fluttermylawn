import 'dart:convert';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/quiz/grass_type_data.dart';
import 'package:my_lawn/services/geo/geo_service_exceptions.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/scotts_api_client.dart';

class GeoServiceImpl implements GeoService {
  final ScottsApiClient _apiClient;

  GeoServiceImpl() : _apiClient = registry<ScottsApiClient>();

  @override
  Future<String> getLawnZone(String zipCodePrefix) async {
    try {
      final queryParameters = {'zip_prefix': '$zipCodePrefix'};

      final response = await _apiClient.get(
        '/geo/v1/geo/getZone',
        queryParameters: queryParameters,
      );
      final lawnZoneResponse =
          LawnZoneResponse.fromJson(json.decode(response.body));
      if (lawnZoneResponse.statusCode == 400) {
        throw InvalidZipException('Please enter a valid Zip Code');
      }

      return lawnZoneResponse.lawnZone;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GrassType>> getGrassTypes(String zipCodePrefix) async {
    try {
      final queryParameters = {'zip_prefix': '$zipCodePrefix'};

      final response = await _apiClient.get(
        '/geo/v1/geo/getGrassTypes',
        queryParameters: queryParameters,
      );
      final grassTypeResponse =
          GrassTypeResponse.fromJson(json.decode(response.body));
      if (grassTypeResponse.statusCode == 400) {
        throw InvalidZipException(
            'Error! Unable to get Grass types for the Zip Code entered');
      }

      return grassTypeResponse.grassTypes;
    } catch (e) {
      rethrow;
    }
  }
}

class LawnZoneResponse {
  final int statusCode;
  final String message;
  final String lawnZone;

  LawnZoneResponse.fromJson(Map<String, dynamic> map)
      : statusCode = map['statusCode'] as int,
        message = map['message'] as String,
        lawnZone = map['zone'] as String;
}

class GrassTypeResponse {
  final int statusCode;
  final String message;
  final List<GrassType> grassTypes;

  GrassTypeResponse.fromJson(Map<String, dynamic> map)
      : statusCode = map['statusCode'] as int,
        message = map['message'],
        grassTypes = List<GrassType>.from(
          map['grasstypes']?.map(
            (grassType) => GrassType.fromJson(grassType),
          ),
        );
}
