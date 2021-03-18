import 'package:data/data.dart';

class RemoteConfigData extends Data {
  final bool isKillSwitchActive;
  final String killSwitchMessage;

  final bool isForceUpdateActive;
  final String forceUpdateVersion;
  final String forceUpdateMessage;

  RemoteConfigData({
    this.isKillSwitchActive,
    this.killSwitchMessage,
    this.isForceUpdateActive,
    this.forceUpdateVersion,
    this.forceUpdateMessage,
  });

  @override
  List<Object> get props => [
        isKillSwitchActive,
        killSwitchMessage,
        isForceUpdateActive,
        forceUpdateVersion,
        forceUpdateMessage,
      ];
}
