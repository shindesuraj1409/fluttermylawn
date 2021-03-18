import 'package:data/data.dart';
import 'package:my_lawn/services/auth/gigya/gigya_user.dart';

class User extends Data {
  final String customerId;
  final String email;
  final String firstName;
  final String lastName;
  final bool isEmailVerified;
  final String recommendationId;
  final bool isNewsletterSubscribed;
  final GigyaUser gigyaUser;

  User({
    this.customerId,
    this.email,
    this.firstName,
    this.lastName,
    this.isEmailVerified,
    this.recommendationId,
    this.isNewsletterSubscribed,
    this.gigyaUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isEmailVerified': isEmailVerified,
      'recommendationId': recommendationId,
      'isNewsletterSubscribed': isNewsletterSubscribed,
      'gigyaUser': gigyaUser == null ? null : gigyaUser.toJson(),
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isNewsletterSubscribed': isNewsletterSubscribed,
    };
  }

  User.fromJson(Map<String, dynamic> map)
      : customerId = map['customerId'],
        email = map['email'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        isEmailVerified = map['isEmailVerified'],
        recommendationId = map['recommendationId'],
        isNewsletterSubscribed = map['isNewsletterSubscribed'],
        gigyaUser = map['gigyaUser'] == null
            ? null
            : GigyaUser.fromJson(map['gigyaUser']);

  User copyWith(
      {String customerId,
      String email,
      String firstName,
      String lastName,
      bool isEmailVerified,
      String recommendationId,
      bool isNewsletterSubscribed,
      GigyaUser gigyaUser}) {
    return User(
      customerId: customerId ?? this.customerId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      recommendationId: recommendationId ?? this.recommendationId,
      isNewsletterSubscribed:
          isNewsletterSubscribed ?? this.isNewsletterSubscribed,
      gigyaUser: gigyaUser == null
          ? this.gigyaUser
          : this.gigyaUser == null
              ? gigyaUser
              : this.gigyaUser.copyWithUser(gigyaUser),
    );
  }

  User copyWithUser(User user) {
    return User(
      customerId: user.customerId ?? customerId,
      email: user.email ?? email,
      firstName: user.firstName ?? firstName,
      lastName: user.lastName ?? lastName,
      isEmailVerified: user.isEmailVerified ?? isEmailVerified,
      recommendationId: user.recommendationId ?? recommendationId,
      isNewsletterSubscribed:
          user.isNewsletterSubscribed ?? isNewsletterSubscribed,
      gigyaUser: user.gigyaUser == null
          ? gigyaUser
          : gigyaUser == null
              ? user.gigyaUser
              : gigyaUser.copyWithUser(user.gigyaUser),
    );
  }

  static User guest() => User(customerId: '-1');

  @override
  List<Object> get props => [
        customerId,
        email,
        firstName,
        lastName,
        isEmailVerified,
        recommendationId,
        isNewsletterSubscribed,
        gigyaUser
      ];
}
