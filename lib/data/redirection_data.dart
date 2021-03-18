import 'package:data/data.dart';
import 'package:meta/meta.dart';

class RedirectionData extends Data {
  final String root;
  final String route;

  RedirectionData({@required this.root, @required this.route});

  RedirectionData.root(this.root) : route = null;

  RedirectionData.route(this.route) : root = null;

  RedirectionData.empty()
      : root = null,
        route = null;

  @override
  List<Object> get props => [root, route];
}
