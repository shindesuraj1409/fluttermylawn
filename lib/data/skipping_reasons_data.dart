import 'package:data/data.dart';

class SkippingReasons extends Data {
  final int id;
  final String reason;

  SkippingReasons({
    this.id,
    this.reason,
  });

  factory SkippingReasons.fromJson(Map<String, dynamic> json) {
    return SkippingReasons(
        id: json['fields']['id'], reason: json['fields']['reason']);
  }

  @override
  List<Object> get props => [id, reason];
}
