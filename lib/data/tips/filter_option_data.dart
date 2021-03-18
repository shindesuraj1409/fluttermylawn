import 'package:data/data.dart';

class FilterOption extends Data {
  final String filter_id;
  final String filter_name;

  FilterOption({
    this.filter_id,
    this.filter_name,
  });

  factory FilterOption.fromJson(
      Map<String, dynamic> json, List<dynamic> assets) {
    final filter_id = json['sys']['id'] as String;
    final filter_name = assets.firstWhere(
            (element) => element['sys']['id'] == json['sys']['id'])['fields']
        ['name'] as String;

    return FilterOption(filter_id: filter_id, filter_name: filter_name);
  }

  @override
  List<Object> get props => [filter_id];
}
