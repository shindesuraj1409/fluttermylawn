import 'package:data/data.dart';

class BuildData extends Data {
  final String name;
  final String package;
  final String version;
  final String build;

  BuildData({
    BuildData buildData,
    String name,
    String package,
    String version,
    String build,
  })  : name = name ?? buildData?.name ?? '-',
        package = package ?? buildData?.package ?? '-',
        version = version ?? buildData?.version ?? '-',
        build = build ?? buildData?.build ?? '-';

  @override
  List<Object> get props => [name, package, version, build];
}

