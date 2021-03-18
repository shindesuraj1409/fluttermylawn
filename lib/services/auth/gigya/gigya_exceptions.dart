import 'package:my_lawn/services/api_error_exceptions.dart';

const int ERROR_PENDING_REGISTRATION = 206001;
const int ERROR_LOGIN_IDENTIFIER_EXISTS = 403043;

class PendingRegistrationException extends GigyaErrorException {
  final String reason;
  final String regToken;
  final String email;
  @override
  final int errorCode;

  PendingRegistrationException(
    this.reason,
    this.regToken,
    this.email,
    this.errorCode,
  ) : super(errorCode);
}

class LinkAccountsException extends GigyaErrorException {
  final String reason;
  @override
  final int errorCode;
  final String email;

  LinkAccountsException(
    this.reason,
    this.errorCode,
    this.email,
  ) : super(errorCode);
}
