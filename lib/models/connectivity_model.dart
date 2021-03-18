import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:bus/bus.dart';
import 'package:my_lawn/data/connectivity_data.dart';

class ConnectivityModel with Bus {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged
        .takeWhile(
          (_) => isInitialized,
        )
        .listen(
          _updateConnectivityData,
          onError: (error) => log.warning(error),
        );
  }

  @override
  List<Channel> get channels => [Channel(ConnectivityData)];

  Future<void> _updateConnectivityData(
      ConnectivityResult connectivityResult) async {
    var connectivityData = ConnectivityData(
      isValid: true,
      isMobile: connectivityResult == ConnectivityResult.mobile,
      isWifi: connectivityResult == ConnectivityResult.wifi,
      hasInternet: false,
    );

    if (connectivityData.isMobile || connectivityData.isWifi) {
      try {
        await http.head('http://www.scotts.com');
        connectivityData = ConnectivityData(
          connectivityData: connectivityData,
          hasInternet: true,
        );
      } on http.ClientException {
        // Do nothing.
      }
    }

    log.fine('_updateConnectivityData: $connectivityData');
    publish(data: connectivityData);
  }

  Future<void> requestUpdate() async {
    log.fine('requestUpdate()');
    try {
      await _updateConnectivityData(await _connectivity.checkConnectivity());
    } catch (e) {
      log.warning(e);
    }
  }
}
