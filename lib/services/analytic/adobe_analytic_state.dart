import 'package:meta/meta.dart';

abstract class AdobeAnalyticState {
  final dynamic type;
  final String state;

  final List<String> params;
  final Map<String, String> data;

  AdobeAnalyticState({
    @required this.type,
    @required this.state,
    this.params,
    this.data,
  });

  Map<String, String> getData();
}
