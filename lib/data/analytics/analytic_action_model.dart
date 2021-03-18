
//TODO:Eugene check what fields are needed here
class AnalyticActionModel {
  final String name;
  final String action;
  final String context_value;
  final List<String> context_data;
  final String behavior;
  final String reaction;

  Map<String,String> data;

  AnalyticActionModel({
    this.name,
    this.action,
    this.context_data,
    this.context_value,
    this.behavior,
    this.reaction,
    this.data
  });

  AnalyticActionModel.fromJson(Map<String,dynamic> json)
    : name = json['name'] as String,
      action = json['action'] as String,
      context_data = json['context_data'] as List<String>,
      context_value = json['context_value'] as String,
      behavior = json['behavior'] as String,
      reaction = json['reaction'] as String;

  set setData(Map<String,String> map) => data = map;

  Map<String,String> get getData => data;

  List<Object> get props => [
    name,
    action,
    context_data,
    context_value,
    behavior,
    reaction,
  ];
}
