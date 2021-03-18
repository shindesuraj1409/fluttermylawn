import 'package:my_lawn/data/quiz/grass_type_data.dart';

abstract class GeoService {
  // Get "Lawn Zone" from "Zip Code" prefix
  Future<String> getLawnZone(String zipCodePrefix);

  // Get List of "Grass types" from "Zip Code" prefix
  Future<List<GrassType>> getGrassTypes(String zipCodePrefix);
}
