import 'package:my_lawn/data/recommendation_data.dart';

abstract class PlanService {
  Future<Plan> copyWithGraphQL({
    Plan plan,
    List<String> products,
  });
}
