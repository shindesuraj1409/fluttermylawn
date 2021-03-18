import 'package:meta/meta.dart';

abstract class AdobeAnalyticAction {
  final dynamic type;
  final String action;

  final List<String> params;
  final Map<String, String> data;

  AdobeAnalyticAction({
    @required this.type,
    @required this.action,
    this.params,
    this.data,
  });

  Map<String, String> getData();
}
