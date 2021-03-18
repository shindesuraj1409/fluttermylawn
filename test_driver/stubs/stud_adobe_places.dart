import 'package:my_lawn/repositories/analytic/adobe_places_repository.dart';

import '../stub/stub.dart';

class StubAdobePlacesRepository  implements AdobePlacesRepository{
  @override
  Future<String> checkLastKnownLocation() async{
    addNewEntry('checkLastKnownLocation');
    return '';
  }

  @override
  void checkPermissionWithReaction({Function onGranted, Function onDenied, Function onDeniedForever, Function onDefault}) {
    addNewEntry('checkPermissionWithReaction');
  }

  @override
  void startMonitoringLocation() {
    addNewEntry('startMonitoringLocation');
  }

  @override
  void stopMonitoringLocation() {
    addNewEntry('stopMonitoringLocation');
  }
}
