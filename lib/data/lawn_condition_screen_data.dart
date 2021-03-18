import 'package:data/data.dart';

import 'lawn_data.dart';

class LawnConditionScreenData extends Data {
  final LawnData lawnData;
  final bool canPop;

  LawnConditionScreenData({this.lawnData, this.canPop = true});

  @override
  List<Object> get props => [lawnData, canPop];
}
