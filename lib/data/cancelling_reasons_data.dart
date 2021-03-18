import 'package:data/data.dart';

class CancellingReasons extends Data {
  final int id;
  final String reason;

  CancellingReasons({
    this.id,
    this.reason,
  });

  factory CancellingReasons.fromJson(Map<String, dynamic> json) {
    return CancellingReasons(
        id: json['fields']['id'], reason: json['fields']['reason']);
  }

  @override
  List<Object> get props => [id, reason];
}
