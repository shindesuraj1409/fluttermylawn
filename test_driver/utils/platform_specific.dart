class PlatformSpecific {
  factory PlatformSpecific({isAndroid = false, isIOS = false}) =>
      PlatformSpecific._internal(isAndroid, isIOS);
  PlatformSpecific._internal(this.isAndroid, this.isIOS);

  final bool isAndroid;
  final bool isIOS;
}

/// object of [PlatformTest]
final platformSpecificObj = PlatformSpecific(isIOS: true);
