import 'package:my_lawn/data/app_data.dart';
import 'package:my_lawn/data/back_button_state.dart';
import 'package:my_lawn/data/build_data.dart';
import 'package:my_lawn/data/redirection_data.dart';
import 'package:package_info/package_info.dart';
import 'package:bus/bus.dart';

class AppModel with Bus {
  final String title = 'Scotts';

  AppModel() {
    _initBuildData();

    publish(data: BackButtonState.Enabled);
    publish(data: RedirectionData.empty());
  }

  void _initBuildData() async {
    final packageInfo = await PackageInfo.fromPlatform();

    publish(
      data: BuildData(
        name: packageInfo.appName,
        package: packageInfo.packageName,
        version: packageInfo.version,
        build: packageInfo.buildNumber,
      ),
    );
  }

  @override
  List<Channel> get channels => [
        Channel(BuildData),
        Channel(AppData),
        Channel(BackButtonState),
        Channel(RedirectionData),
      ];
}
