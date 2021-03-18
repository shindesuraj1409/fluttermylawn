import 'package:data/data.dart';

class ConnectivityData extends Data {
  final bool isValid;
  final bool isMobile;
  final bool isWifi;
  final bool hasInternet;

  ConnectivityData({
    ConnectivityData connectivityData,
    bool isValid,
    bool isMobile,
    bool isWifi,
    bool hasInternet,
  })  : isValid = isValid ?? connectivityData?.isValid ?? false,
        isMobile = isMobile ?? connectivityData?.isMobile ?? false,
        isWifi = isWifi ?? connectivityData?.isWifi ?? false,
        hasInternet = hasInternet ?? connectivityData?.hasInternet ?? false;

  @override
  List<Object> get props => [isMobile, isWifi, hasInternet];
}

