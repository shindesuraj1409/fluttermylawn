enum ActivityType {
  waterLawn,
  mowLawn,
  aerateLawn,
  dethatchLawn,
  overseedLawn,
  mulchBeds,
  cleanDeckPatio,
  winterizeSprinklerSystem,
  tuneUpMower,
  createYourOwn,
  userAddedProduct,
  recommended,
  fake
}

extension ActivityTypeExtention on ActivityType {
  String get title => _activityTitles[this];

  String get icon => _activityIcons[this];

  bool get isDisplayable => _activityDisplayable[this];
}

const _activityIcons = <ActivityType, String>{
  ActivityType.waterLawn: 'assets/icons/water_lawn.png',
  ActivityType.aerateLawn: 'assets/icons/aerate_lawn.png',
  ActivityType.cleanDeckPatio: 'assets/icons/clean_deck_patio.png',
  ActivityType.createYourOwn: 'assets/icons/create_your_own.png',
  ActivityType.dethatchLawn: 'assets/icons/dethatch_lawn.png',
  ActivityType.mowLawn: 'assets/icons/mow_lawn.png',
  ActivityType.mulchBeds: 'assets/icons/mulch_beds.png',
  ActivityType.overseedLawn: 'assets/icons/overseed_lawn.png',
  ActivityType.tuneUpMower: 'assets/icons/tune_up_mower.png',
  ActivityType.winterizeSprinklerSystem:
      'assets/icons/winternize_sprinkler_system.png',
};

const _activityTitles = {
  ActivityType.waterLawn: 'Water Lawn',
  ActivityType.mowLawn: 'Mow Lawn',
  ActivityType.aerateLawn: 'Aerate Lawn',
  ActivityType.dethatchLawn: 'Dethatch Lawn',
  ActivityType.overseedLawn: 'Overseed Lawn',
  ActivityType.mulchBeds: 'Mulch Beds',
  ActivityType.cleanDeckPatio: 'Clean Deck / Patio',
  ActivityType.winterizeSprinklerSystem: 'Winterize Sprinkler System',
  ActivityType.tuneUpMower: 'Tune up Mower',
  ActivityType.createYourOwn: 'Create Your Own',
};

const _activityDisplayable = {
  ActivityType.waterLawn: true,
  ActivityType.mowLawn: true,
  ActivityType.aerateLawn: true,
  ActivityType.dethatchLawn: true,
  ActivityType.overseedLawn: true,
  ActivityType.mulchBeds: true,
  ActivityType.cleanDeckPatio: true,
  ActivityType.winterizeSprinklerSystem: true,
  ActivityType.tuneUpMower: true,
  ActivityType.createYourOwn: true,
  ActivityType.userAddedProduct: false,
  ActivityType.recommended: false,
  ActivityType.fake: false,
};
