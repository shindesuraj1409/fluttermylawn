import 'package:data/data.dart';
import 'package:my_lawn/data/tips/filter_option_data.dart';

class FilterBlockData extends Data {
  final String id;
  final String title;
  final List<FilterOption> filter_option_list;

  FilterBlockData({this.id, this.title, this.filter_option_list});

  factory FilterBlockData.fromJson(Map<String, dynamic> json, assets) {
    final id = json['sys']['id'] as String;
    final title = json['fields']['name'] as String;
    final filter_option_list = (json['fields']['categories'] as List)
        .map((json) => FilterOption.fromJson(json, assets))
        .toList();

    return FilterBlockData(
        id: id, title: title, filter_option_list: filter_option_list);
  }

  @override
  List<Object> get props => [id];
}
