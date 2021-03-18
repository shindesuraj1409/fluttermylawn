import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:localytics_plugin/events/value_event.dart';
import 'package:localytics_plugin/localytics_plugin.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class LocalyticsService {
  final LocalyticsPlugin _localyticsPlugin = LocalyticsPlugin();

  Future<void> tagEvent(LocalyticsEvent event) {
    return _localyticsPlugin.tagEvent(event);
  }

  Future<void> setCustomerId(String customerId) {
    return _localyticsPlugin.setCustomerId(customerId);
  }

  Future<void> setUserAttribute(String name, String value) {
    return _localyticsPlugin.setValue(ValueEvent(
      attributeName: name,
      value: value ?? '',
    ));
  }

  Future<void> updateUserProfile() async {
    final user = await registry<SessionManager>().getUser();

    if (user != null) {
      await setCustomerId(user.customerId);
      await setUserAttribute(
        'User Type',
        (user.customerId != null ? UserType.LoggedIn : UserType.Guest)
            .toString(),
      );
      await setUserAttribute('User Id', user.customerId);
      await setUserAttribute('Email verified', user.isEmailVerified.toString());
    }

    final answers = registry<QuizModel>().answers;

    if (answers != null) {
      await setUserAttribute('ZoneName', answers[QuestionType.lawnZone]);
      await setUserAttribute('ZipCode', answers[QuestionType.zipCode]);
      await setUserAttribute(
          'Lawn condition: grass color', answers[QuestionType.lawnColor]);
      await setUserAttribute(
          'Lawn condition: Weeds', answers[QuestionType.lawnWeeds]);
      await setUserAttribute(
          'Lawn condition: Thickness', answers[QuestionType.lawnThickness]);
      await setUserAttribute(
          'Spreader type', answers[QuestionType.lawnSpreader]);
      await setUserAttribute('Grass type', answers[QuestionType.grassType]);
      await setUserAttribute('Lawn size', answers[QuestionType.lawnArea]);
    }
  }
}
