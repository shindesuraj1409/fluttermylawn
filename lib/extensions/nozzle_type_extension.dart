import 'package:my_lawn/data/water_model_data.dart';

extension NozzleTypeExtensions on NozzleType {
  String get description {
    switch (name) {
      case 'Sprinklers':
        return 'Propelled in a circular motion by arm that repeatedly strikes the out going stream, spraying the water over a large area.';
      case 'Rotors':
        return 'Gear-driven, single rotating stream of water applied at a slow rate in full or partial circle patterns.';
      case 'Drip':
        return 'Low-flowing watering system to keep plant roots moist using pinpoint delivery to minimize runoff.';
      case 'Sprays':
        return 'Pop-up nozzles designed to dispense a continuous mist of water in full, half or quarter circle patterns over a small area.';
      default:
        return 'Delivers a flow of water to the immediate area to deeply soak the root zone of plants.';
    }
  }

  String get nozzleRateString {
    switch (name) {
      case 'Sprinklers':
      case 'Rotors':
        return '92 ';
        break;
      case 'Drip':
        return '305 ';
        break;
      case 'Sprays':
        return '38 ';
        break;
      case 'Bubbler':
        return '60 ';
        break;
      default:
        return '';
    }
  }

  List<String> get activityHowMuchFields {
    return [
      '1/8" | ${.125 ~/ rate} mins',
      '1/4" | ${.25 ~/ rate} mins',
      '1/2" | ${.5 ~/ rate} mins',
      '1" | ${1 ~/ rate} mins',
      '1 1/2" | ${1.5 ~/ rate} mins',
      '2" | ${2 ~/ rate} mins',
    ];
  }

  String howMuchFieldString(int selectedValue) {
    final durationMap = {
      .125 ~/ rate: '1/8" | ${.125 ~/ rate} mins',
      .25 ~/ rate: '1/4" | ${.25 ~/ rate} mins',
      .5 ~/ rate: '1/2" | ${.5 ~/ rate} mins',
      1 ~/ rate: '1" | ${1 ~/ rate} mins',
      1.5 ~/ rate: '1 1/2" | ${1.5 ~/ rate} mins',
      2 ~/ rate: '2" | ${2 ~/ rate} mins',
    };

    return durationMap[selectedValue];
  }

  int howMuchFieldDuration(String selectedValue) {
    final durationMap = {
      '1/8" | ${.125 ~/ rate} mins': .125 ~/ rate,
      '1/4" | ${.25 ~/ rate} mins': .25 ~/ rate,
      '1/2" | ${.5 ~/ rate} mins': .5 ~/ rate,
      '1" | ${1 ~/ rate} mins': 1 ~/ rate,
      '1 1/2" | ${1.5 ~/ rate} mins': 1.5 ~/ rate,
      '2" | ${2 ~/ rate} mins': 2 ~/ rate,
    };

    return durationMap[selectedValue];
  }
}
