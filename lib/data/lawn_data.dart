import 'package:data/data.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';

enum Spreader {
  none,
  handheld,
  wheeled,
}

enum LawnGrassThickness {
  none,
  some,
  patchy,
  thin,
  thick,
}

enum LawnGrassColor {
  brown,
  lightBrown,
  greenAndBrown,
  mostlyGreen,
  veryGreen,
}

enum LawnWeeds {
  many,
  several,
  some,
  few,
  none,
}

class LawnData extends Data {
  static const unknownGrassType = 'UNK';

  final String grassType;
  final String inputType;
  final String grassTypeImageUrl;
  final String grassTypeName;
  final AddressData lawnAddress;
  final String lawnName;
  final int lawnSqFt;
  final Spreader spreader;
  final LawnGrassThickness thickness;
  final LawnGrassColor color;
  final LawnWeeds weeds;

  LawnData({
    this.grassType,
    this.inputType,
    this.grassTypeImageUrl,
    this.grassTypeName,
    this.lawnAddress,
    this.lawnName = 'My Lawn',
    this.lawnSqFt,
    this.spreader,
    this.thickness,
    this.color,
    this.weeds,
  });

  Map<String, dynamic> toJson() {
    return {
      'grassType': grassType,
      'inputType': inputType,
      'grassTypeImageUrl': grassTypeImageUrl,
      'grassTypeName': grassTypeName,
      'lawnAddress': lawnAddress?.toJsonCustom(),
      'lawnName': lawnName,
      'lawnSqFt': lawnSqFt,
      'spreader': spreader?.index,
      'thickness': thickness?.index,
      'color': color?.index,
      'weeds': weeds?.index,
    };
  }

  LawnData.fromJson(Map<String, dynamic> map)
      : grassType = map['grassType'],
        inputType = map['inputType'],
        grassTypeImageUrl = map['grassTypeImageUrl'],
        grassTypeName = map['grassTypeName'],
        lawnAddress = map['lawnAddress'] != null
            ? AddressData.fromJsonCustom(map['lawnAddress'])
            : null,
        lawnName = map['lawnName'],
        lawnSqFt = map['lawnSqFt'],
        spreader =
            map['spreader'] != null ? Spreader.values[map['spreader']] : null,
        thickness = map['thickness'] != null
            ? LawnGrassThickness.values[map['thickness']]
            : null,
        color =
            map['color'] != null ? LawnGrassColor.values[map['color']] : null,
        weeds = map['weeds'] != null ? LawnWeeds.values[map['weeds']] : null;

  LawnData.fromQuizAnswers(Map<String, dynamic> map)
      : grassType = map['grassType'],
        inputType = null,
        grassTypeImageUrl = null,
        grassTypeName = null,
        lawnAddress =
            map['zipCode'] != null ? AddressData(zip: map['zipCode']) : null,
        lawnName = null,
        lawnSqFt = map['lawnArea'] ?? '',
        spreader = map['lawnSpreader'] == null
            ? Spreader.none
            : Spreader.values.firstWhere(
                (value) => value.pascalCaseString == map['lawnSpreader']),
        thickness = map['lawnThickness'] == null
            ? LawnGrassThickness.patchy
            : LawnGrassThickness.values.firstWhere(
                (value) => value.pascalCaseString == map['lawnThickness']),
        color = map['lawnColor'] == null
            ? LawnGrassColor.greenAndBrown
            : LawnGrassColor.values.firstWhere(
                (value) => value.pascalCaseString == map['lawnColor']),
        weeds = map['lawnWeeds'] == null
            ? LawnWeeds.some
            : LawnWeeds.values.firstWhere(
                (value) => value.pascalCaseString == map['lawnWeeds']);

  LawnData copyWith({
    String grassType,
    String grassTypeImageUrl,
    String grassTypeName,
    AddressData lawnAddress,
    String lawnName,
    int lawnSqFt,
    Spreader spreader,
    LawnGrassThickness thickness,
    LawnGrassColor color,
    LawnWeeds weeds,
    String zipCode,
    String inputType,
    bool hasSubscription,
  }) =>
      LawnData(
        grassType: grassType ?? this.grassType,
        inputType: inputType ?? this.inputType,
        grassTypeImageUrl: grassTypeImageUrl ?? this.grassTypeImageUrl,
        grassTypeName: grassTypeName ?? this.grassTypeName,
        lawnAddress: lawnAddress ?? this.lawnAddress,
        lawnName: lawnName ?? this.lawnName,
        lawnSqFt: lawnSqFt ?? this.lawnSqFt,
        spreader: spreader ?? this.spreader,
        thickness: thickness ?? this.thickness,
        color: color ?? this.color,
        weeds: weeds ?? this.weeds,
      );

  LawnData copyWithLawnData(LawnData lawnData) => LawnData(
        grassType: lawnData.grassType ?? grassType,
        inputType: lawnData.inputType ?? inputType,
        grassTypeImageUrl: lawnData.grassTypeImageUrl ?? grassTypeImageUrl,
        grassTypeName: lawnData.grassTypeName ?? grassTypeName,
        lawnAddress: lawnData.lawnAddress ?? lawnAddress,
        lawnName: lawnData.lawnName ?? lawnName,
        lawnSqFt: lawnData.lawnSqFt ?? lawnSqFt,
        spreader: lawnData.spreader ?? spreader,
        thickness: lawnData.thickness ?? thickness,
        color: lawnData.color ?? color,
        weeds: lawnData.weeds ?? weeds,
      );

  @override
  List<Object> get props => [
        grassType,
        lawnAddress,
        lawnName,
        lawnSqFt,
        spreader,
        thickness,
        color,
        weeds,
        inputType,
      ];

  @override
  String toString() {
    return 'LawnData(grassType: $grassType, inputType: $inputType, grassTypeImageUrl: $grassTypeImageUrl, grassTypeName: $grassTypeName, lawnAddress: $lawnAddress, lawnName: $lawnName, lawnSqFt: $lawnSqFt, spreader: $spreader, thickness: $thickness, color: $color, weeds: $weeds)';
  }
}
