import 'dart:ui';

import 'package:my_lawn/config/colors_config.dart';

enum ProductCategory {
  insectAndDiseaseControl,
  weedControl,
  lawnFood,
  grassSeeds,
  growGrassQuicker,
  increaseThickness,
  feedGrass,
  promoteRootDevelopment,
  strengthenAgainstHeat,
  increaseWaterAbsorption,
  recoupfromSummer,
  bareSpots,
  thinLawn,
  crabgrass,
  moss,
  dandelion,
  grubs,
  drought,
}

extension ProductCategoryExtension on ProductCategory {
  String get title {
    switch (this) {
      case ProductCategory.insectAndDiseaseControl:
        return 'Insect & Disease Control';
        break;
      case ProductCategory.weedControl:
        return 'Weed Control';
        break;
      case ProductCategory.lawnFood:
        return 'Lawn Food';
        break;
      case ProductCategory.grassSeeds:
        return 'Grass Seeds';
        break;
      case ProductCategory.growGrassQuicker:
        return 'Grow Grass Quicker';
        break;
      case ProductCategory.increaseThickness:
        return 'Increase Thickness';
        break;
      case ProductCategory.feedGrass:
        return 'Feed Grass';
        break;
      case ProductCategory.promoteRootDevelopment:
        return 'Promote Root Development';
        break;
      case ProductCategory.strengthenAgainstHeat:
        return 'Strengthen Against Heat';
        break;
      case ProductCategory.increaseWaterAbsorption:
        return 'Increase Water Absorption';
        break;
      case ProductCategory.recoupfromSummer:
        return 'Recoup from Summer';
        break;
      case ProductCategory.bareSpots:
        return 'Bare Spots';
        break;
      case ProductCategory.thinLawn:
        return 'Thin Lawn';
        break;
      case ProductCategory.crabgrass:
        return 'Crabgrass';
        break;
      case ProductCategory.moss:
        return 'Moss';
        break;
      case ProductCategory.dandelion:
        return 'Dandelion';
        break;
      case ProductCategory.grubs:
        return 'Grubs';
        break;
      case ProductCategory.drought:
        return 'Drought';
        break;
      default:
        throw UnimplementedError('not implemented');
    }
  }

  String get icon {
    switch (this) {
      case ProductCategory.insectAndDiseaseControl:
        return 'assets/icons/plp_insect_disease_control.png';
        break;
      case ProductCategory.weedControl:
        return 'assets/icons/plp_weed_control.png';
        break;
      case ProductCategory.lawnFood:
        return 'assets/icons/plp_lawn_food.png';
        break;
      case ProductCategory.grassSeeds:
        return 'assets/icons/plp_grass_seeds.png';
        break;
      case ProductCategory.growGrassQuicker:
        return 'assets/icons/plp_grow_grass_quicker.png';
        break;
      case ProductCategory.increaseThickness:
        return 'assets/icons/plp_increase_thickness.png';
        break;
      case ProductCategory.feedGrass:
        return 'assets/icons/plp_feed_grass.png';
        break;
      case ProductCategory.promoteRootDevelopment:
        return 'assets/icons/plp_promote_root_development.png';
        break;
      case ProductCategory.strengthenAgainstHeat:
        return 'assets/icons/plp_strengthen_against_heat.png';
        break;
      case ProductCategory.increaseWaterAbsorption:
        return 'assets/icons/plp_increase_water_absorption.png';
        break;
      case ProductCategory.recoupfromSummer:
        return 'assets/icons/plp_recoup_from_summer.png';
        break;
      case ProductCategory.bareSpots:
        return 'assets/icons/plp_bare_spots.png';
        break;
      case ProductCategory.thinLawn:
        return 'assets/icons/plp_thin_lawn.png';
        break;
      case ProductCategory.crabgrass:
        return 'assets/icons/plp_crab_grass.png';
        break;
      case ProductCategory.moss:
        return 'assets/icons/plp_moss.png';
        break;
      case ProductCategory.dandelion:
        return 'assets/icons/plp_dandelion.png';
        break;
      case ProductCategory.grubs:
        return 'assets/icons/plp_grubs.png';
        break;
      case ProductCategory.drought:
        return 'assets/icons/plp_drought.png';
        break;
      default:
        throw UnimplementedError('not implemented');
    }
  }

  String get appbarIcon {
    switch (this) {
      case ProductCategory.insectAndDiseaseControl:
        return 'assets/icons/plp_insect_disease_control_appbar.png';
        break;
      case ProductCategory.weedControl:
        return 'assets/icons/plp_weed_control_appbar.png';
        break;
      case ProductCategory.lawnFood:
        return 'assets/icons/plp_lawn_food_appbar.png';
        break;
      case ProductCategory.grassSeeds:
        return 'assets/icons/plp_grass_seeds_appbar.png';
        break;
      case ProductCategory.growGrassQuicker:
        return 'assets/icons/plp_grow_grass_quicker.png';
        break;
      case ProductCategory.increaseThickness:
        return 'assets/icons/plp_increase_thickness.png';
        break;
      case ProductCategory.feedGrass:
        return 'assets/icons/plp_feed_grass.png';
        break;
      case ProductCategory.promoteRootDevelopment:
        return 'assets/icons/plp_promote_root_development.png';
        break;
      case ProductCategory.strengthenAgainstHeat:
        return 'assets/icons/plp_strengthen_against_heat.png';
        break;
      case ProductCategory.increaseWaterAbsorption:
        return 'assets/icons/plp_increase_water_absorption.png';
        break;
      case ProductCategory.recoupfromSummer:
        return 'assets/icons/plp_recoup_from_summer.png';
        break;
      case ProductCategory.bareSpots:
        return 'assets/icons/plp_bare_spots.png';
        break;
      case ProductCategory.thinLawn:
        return 'assets/icons/plp_thin_lawn.png';
        break;
      case ProductCategory.crabgrass:
        return 'assets/icons/plp_crab_grass.png';
        break;
      case ProductCategory.moss:
        return 'assets/icons/plp_moss.png';
        break;
      case ProductCategory.dandelion:
        return 'assets/icons/plp_dandelion.png';
        break;
      case ProductCategory.grubs:
        return 'assets/icons/plp_grubs.png';
        break;
      case ProductCategory.drought:
        return 'assets/icons/plp_drought.png';
        break;
      default:
        throw UnimplementedError('not implemented');
    }
  }

  Color get color {
    switch (this) {
      case ProductCategory.insectAndDiseaseControl:
        return Color.alphaBlend(Styleguide.color_accents_red.withOpacity(0.08),
            Styleguide.color_gray_0);

        break;
      case ProductCategory.weedControl:
        return Color.alphaBlend(
            Styleguide.color_accents_yellow_1_8.withOpacity(0.08),
            Styleguide.color_gray_0);
        break;
      case ProductCategory.lawnFood:
        return Color.alphaBlend(Styleguide.color_green_3.withOpacity(0.08),
            Styleguide.color_gray_0);
        break;
      case ProductCategory.grassSeeds:
        return Color.alphaBlend(Styleguide.color_light_navy_8.withOpacity(0.08),
            Styleguide.color_gray_0);
        break;
      default:
        return Color.alphaBlend(Styleguide.color_green_3.withOpacity(0.08),
            Styleguide.color_gray_0);
    }
  }

  String get type {
    switch (this) {
      case ProductCategory.insectAndDiseaseControl:
        return 'mylawn_categories';
        break;
      case ProductCategory.weedControl:
        return 'mylawn_categories';
        break;
      case ProductCategory.lawnFood:
        return 'mylawn_categories';
        break;
      case ProductCategory.grassSeeds:
        return 'mylawn_categories';
        break;
      case ProductCategory.growGrassQuicker:
        return 'goals_filter';
        break;
      case ProductCategory.increaseThickness:
        return 'goals_filter';
        break;
      case ProductCategory.feedGrass:
        return 'goals_filter';
        break;
      case ProductCategory.promoteRootDevelopment:
        return 'goals_filter';
        break;
      case ProductCategory.strengthenAgainstHeat:
        return 'goals_filter';
        break;
      case ProductCategory.increaseWaterAbsorption:
        return 'goals_filter';
        break;
      case ProductCategory.recoupfromSummer:
        return 'goals_filter';
        break;
      case ProductCategory.bareSpots:
        return 'problems_filter';
        break;
      case ProductCategory.thinLawn:
        return 'problems_filter';
        break;
      case ProductCategory.crabgrass:
        return 'problems_filter';
        break;
      case ProductCategory.moss:
        return 'problems_filter';
        break;
      case ProductCategory.dandelion:
        return 'problems_filter';
        break;
      case ProductCategory.grubs:
        return 'problems_filter';
        break;
      case ProductCategory.drought:
        return 'problems_filter';
        break;
      default:
        throw UnimplementedError('not implemented');
    }
  }
}
