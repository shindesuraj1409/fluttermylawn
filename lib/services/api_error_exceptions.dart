ApiException getRESTException(int errorCode) {
  switch (errorCode) {
    case 400:
      return BadRequestException();
      break;
    case 401:
      return UnauthorizedException();
      break;
    case 403:
      return ForbiddenException();
      break;
    case 404:
      return NotFoundException();
      break;
    case 405:
      return MethodNotAllowedException();
      break;
    case 500:
      return ServerErrorException();
      break;

    default:
      return Exception();
  }
}

abstract class ApiException implements Exception {
  final String _message;
  final String _errorCode;
  ApiException([this._message, this._errorCode]);

  String get message => '$_message Error Code:$_errorCode';
}

class BadRequestException extends ApiException {
  BadRequestException({int errorCode = 400})
      : super('We’re sorry! An error has occurred. Please try again later.',
            errorCode.toString());
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({int errorCode = 401})
      : super('We’re sorry! An error has occurred. Please try again later.',
            errorCode.toString());
}

class ForbiddenException extends ApiException {
  ForbiddenException({int errorCode = 403})
      : super('We’re sorry! An error has occurred. Please try again later.',
            errorCode.toString());
}

class NotFoundException extends ApiException {
  NotFoundException({int errorCode = 404})
      : super('We’re sorry! An error has occurred. Please try again later.',
            errorCode.toString());
}

class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException({int errorCode = 405})
      : super('We’re sorry! An error has occurred. Please try again later.',
            errorCode.toString());
}

class ServerErrorException extends ApiException {
  ServerErrorException({int errorCode = 500})
      : super(
            'We’re sorry! We seem to be having some technical difficulties at the moment. Please try again late',
            errorCode.toString());
}

class GigyaErrorException extends ApiException {
  final int _gigyaErrorCode;
  final String errorMessage;
  GigyaErrorException(
    this._gigyaErrorCode, {
    this.errorMessage = 'Something went wrong. Please try again!',
  });

  String gigyaMessage() {
    switch (_gigyaErrorCode) {
      case 206001:
        return 'Email subscription preference required. Almost there! Please complete the required information on the page to continue.';
        break;
      case 403042:
        return 'Please verify your credentials and try again.';
        break;
      case 403043:
        return 'Looks like this email is associated with a different provider. Please login using that provider to link both the providers.';
        break;
      case 403120:
        return 'Too many failed login attempts. Your account has been disabled. Please contact customer support +1 (866) 882 0846';
        break;
      case 401030:
        return 'Incorrect password';
        break;
      case 403047:
        return 'If your email exists in our system, we will send you a link to reset your password.';
        break;
      case 200009:
        return 'Accounts linked!';
        break;
      default:
        return 'Something went wrong. Please try again!';
    }
  }

  @override
  String get message => gigyaMessage() ?? errorMessage;

  int get errorCode => _gigyaErrorCode;
}
