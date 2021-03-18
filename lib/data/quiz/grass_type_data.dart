import 'package:data/data.dart';

class GrassType extends Data {
  final String name;
  final String type;
  final String imageUrl;

  GrassType({this.name, this.type, this.imageUrl});

  GrassType.fromJson(Map<String, dynamic> map)
      : name = map['name'] as String,
        type = map['grassType'] as String,
        imageUrl = map['imageUrl'] as String;

  @override
  List<Object> get props => [name];
}
