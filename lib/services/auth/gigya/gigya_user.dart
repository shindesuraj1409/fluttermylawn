import 'package:data/data.dart';

class GigyaUser extends Data {
  final String uid;
  final String uidSignature;
  final String uidTimestamp;
  final String sessionToken;
  final String sessionSecret;
  final String regToken;

  GigyaUser(
      {this.uid,
      this.uidSignature,
      this.uidTimestamp,
      this.sessionToken,
      this.sessionSecret,
      this.regToken});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'uidSignature': uidSignature,
      'uidTimestamp': uidTimestamp,
      'sessionToken': sessionToken,
      'sessionSecret': sessionSecret,
      'regToken': regToken
    };
  }

  GigyaUser.fromJson(Map<String, dynamic> map)
      : uid = map['uid'],
        uidSignature = map['uidSignature'],
        uidTimestamp = map['uidTimestamp'],
        sessionToken = map['sessionToken'],
        sessionSecret = map['sessionSecret'],
        regToken = map['regToken'];

  GigyaUser copyWithUser(GigyaUser user) {
    return GigyaUser(
      uid: user.uid ?? uid,
      uidSignature: user.uidSignature ?? uidSignature,
      uidTimestamp: user.uidTimestamp ?? uidTimestamp,
      sessionSecret: user.sessionSecret ?? sessionSecret,
      sessionToken: user.sessionToken ?? sessionToken,
      regToken: user.regToken ?? regToken,
    );
  }

  @override
  List<Object> get props =>
      [uid, uidSignature, uidTimestamp, sessionToken, sessionSecret, regToken];
}
