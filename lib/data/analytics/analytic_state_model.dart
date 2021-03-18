import 'package:data/data.dart';

class AnalyticStateModel extends Data{
  final String state;
  final Map<String,String> data;
  final String name;

  AnalyticStateModel({
    this.name,
    this.state,
    this.data
  });

  AnalyticStateModel.fromJson(Map<String,dynamic> json)
      : name = json['name'] as String,
        state = json['state'] as String,
        data = json['data'] as Map<String,String>;

  Map<String,String> get getData => data;

  @override
  List<Object> get props => [
    name,
    state,
    data,
  ];
}