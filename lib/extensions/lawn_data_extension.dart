import 'package:my_lawn/data/lawn_data.dart';

extension LawnGrassThicknessExtension on LawnGrassThickness {
  /// Returns a human readable string representation of the enum value.
  String get string {
    switch (this) {
      case LawnGrassThickness.none:
        return 'No Grass';
      case LawnGrassThickness.some:
        return 'Some Grass';
      case LawnGrassThickness.patchy:
        return 'Patchy Grass';
      case LawnGrassThickness.thin:
        return 'Thin Grass';
      case LawnGrassThickness.thick:
        return 'Thick & Lush';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  // Returns in pascal case format to be used for sending data in api calls
  String get pascalCaseString {
    switch (this) {
      case LawnGrassThickness.none:
        return 'NoGrass';
      case LawnGrassThickness.some:
        return 'SomeGrass';
      case LawnGrassThickness.patchy:
        return 'PatchyGrass';
      case LawnGrassThickness.thin:
        return 'ThinGrass';
      case LawnGrassThickness.thick:
        return 'ThickAndLush';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}

extension LawnGrassColorExtension on LawnGrassColor {
  /// Returns a human readable string representation of the enum value.
  String get string {
    switch (this) {
      case LawnGrassColor.brown:
        return 'Brown';
      case LawnGrassColor.lightBrown:
        return 'Light Brown';
      case LawnGrassColor.greenAndBrown:
        return 'Green & Brown';
      case LawnGrassColor.mostlyGreen:
        return 'Mostly Green';
      case LawnGrassColor.veryGreen:
        return 'Very Green';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  // Returns in pascal case format to be used for sending data in api calls
  String get pascalCaseString {
    switch (this) {
      case LawnGrassColor.brown:
        return 'Brown';
      case LawnGrassColor.lightBrown:
        return 'LightBrown';
      case LawnGrassColor.greenAndBrown:
        return 'GreenAndBrown';
      case LawnGrassColor.mostlyGreen:
        return 'MostlyGreen';
      case LawnGrassColor.veryGreen:
        return 'VeryGreen';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}

extension LawnWeedsExtension on LawnWeeds {
  /// Returns a human readable string representation of the enum value.
  String get string {
    switch (this) {
      case LawnWeeds.many:
        return 'Many Weeds';
      case LawnWeeds.several:
        return 'Several Weeds';
      case LawnWeeds.some:
        return 'Some Weeds';
      case LawnWeeds.few:
        return 'Few Weeds';
      case LawnWeeds.none:
        return 'No Weeds';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  /// Returns in pascal case format to be used for sending data in api calls
  String get pascalCaseString {
    switch (this) {
      case LawnWeeds.many:
        return 'ManyWeeds';
      case LawnWeeds.several:
        return 'SeveralWeeds';
      case LawnWeeds.some:
        return 'SomeWeeds';
      case LawnWeeds.few:
        return 'FewWeeds';
      case LawnWeeds.none:
        return 'NoWeeds';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}

extension SpreaderExtension on Spreader {
  /// Returns a human readable string representation of the enum value.
  String get string {
    switch (this) {
      case Spreader.none:
        return 'None';
      case Spreader.handheld:
        return 'Handheld Spreader';
      case Spreader.wheeled:
        return 'Wheeled Spreader';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  /// Returns in pascal case format to be used for sending data in api calls
  String get pascalCaseString {
    switch (this) {
      case Spreader.none:
        return 'NoSpreader';
      case Spreader.handheld:
        return 'HandHeldSpreader';
      case Spreader.wheeled:
        return 'WheeledSpreader';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  /// Returns a human readable short string representation of the enum value.
  String get shortString {
    switch (this) {
      case Spreader.none:
        return 'None';
      case Spreader.handheld:
        return 'Handheld';
      case Spreader.wheeled:
        return 'Wheeled';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}

extension GrassTypeNameExtension on LawnData {
  String get grassTypeNameString {
    return (grassTypeName != null && grassTypeName.isNotEmpty)
        ? grassTypeName
        : 'Unknown Grass Type';
  }
}
