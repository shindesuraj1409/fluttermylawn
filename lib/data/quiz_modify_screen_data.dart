import 'package:data/data.dart';

class QuizModifyScreenData extends Data {
  final int quantity;

  QuizModifyScreenData(this.quantity);

  @override
  List<Object> get props => [quantity];
}
