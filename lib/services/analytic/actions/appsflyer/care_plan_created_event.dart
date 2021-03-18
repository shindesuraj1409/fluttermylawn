import 'package:my_lawn/services/analytic/actions/appsflyer/appsflyer_event.dart';

class CarePlanCreatedEvent extends AppsFlyerEvent {
  @override
  String get eventName => 'Create Lawn Care Plan';
}