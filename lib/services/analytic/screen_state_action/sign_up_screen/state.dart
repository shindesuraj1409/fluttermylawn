import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class SignUpScreenAdobeState extends AdobeAnalyticState {

  SignUpScreenAdobeState() : super(type: 'SignUpScreenAdobeState', state: 'signup');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'onboard'
    };
  }
}

class CompleteScreenAdobeState extends AdobeAnalyticState {

  CompleteScreenAdobeState() : super(type: 'CompleteScreenAdobeState', state: 'complete');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'onboard'
    };
  }
}

class ForgotPasswordScreenAdobeState extends AdobeAnalyticState {

  ForgotPasswordScreenAdobeState() : super(type: 'ForgotPasswordScreenAdobeState', state: 'forgotpassword');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'onboard'
    };
  }
}

class CreateNewPasswordScreenAdobeState extends AdobeAnalyticState {

  CreateNewPasswordScreenAdobeState() : super(type: 'CreateNewPasswordScreenAdobeState', state: 'createnewpassword');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'onboard'
    };
  }
}

class NewsLetterSignUpScreenAdobeState extends AdobeAnalyticState {

  NewsLetterSignUpScreenAdobeState() : super(type: 'NewsLetterSignUpScreenAdobeState', state: 'newsletter sign up');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'account'
    };
  }
}
