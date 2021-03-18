import 'dart:math';

extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)')
        .hasMatch(this);
  }

  String get youtubeLink {
    if (this == null) return null;
    final exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    final matches = exp.allMatches(this);
    return matches.isNotEmpty
        ? substring(matches.first.start, matches.first.end)
        : null;
  }

  int get smallestCoverageArea {
    if (this == null) return null;
    final coverages = split(' ').expand((element) {
      final sanitized = element.replaceAll(',', '');
      return [int.tryParse(sanitized)];
    }).toList();
    coverages.removeWhere((element) => element == null);
    return coverages.isEmpty ? null : coverages.reduce(min);
  }

  String get sanitizeTextForEmail {
    if (this == null) return null;
    return replaceAll('&', 'and');
  }

  bool matchesSKU(String other) => toLowerCase() == other.toLowerCase();
}
