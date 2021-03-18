extension IntExtension on int {
  String get ordinal {
    String suffix;
    switch (this) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
        break;
    }
    return suffix;
  }
}
