import 'package:my_lawn/data/user_data.dart';

extension UserExtension on User {
  String get fullName {
    var fullName = '';

    if (firstName != null && firstName.isNotEmpty) {
      fullName += firstName;
    }

    if (lastName != null && lastName.isNotEmpty) {
      fullName += ' ' + lastName;
    }

    if (fullName.isEmpty) {
      fullName = 'Tap to enter';
    }

    return fullName;
  }
}
