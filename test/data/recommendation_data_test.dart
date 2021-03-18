import 'package:flutter_test/flutter_test.dart';
import 'package:my_lawn/data/recommendation_data.dart';

import '../resources/recommendation_data.dart';

void main() {
  group('Recommendation Data', () {
    Plan plan1, plan2;

    setUp(() {
      plan1 = Recommendation.fromJson(validRecommendationData).plan;
      plan2 = Recommendation.fromJson(additionalRecommendationData).plan;
    });

    test('Individual Product bundle prices', () {
      // Plan 1
      final updatedPlan1 = plan1.getUpdatedPlanWithPricesCalculated();
      updatedPlan1.products.forEach((product) {
        expect(product.bundlePrice, 122.96);
      });

      // Plan 2
      final updatedPlan2 = plan2.getUpdatedPlanWithPricesCalculated();
      updatedPlan2.products.forEach((product) {
        expect(product.bundlePrice, 17.49);
      });
    });

    test('Annual Plan prices', () {
      // Plan 1
      final updatedPlan1 = plan1.getUpdatedPlanWithPricesCalculated();
      expect(updatedPlan1.prices.annualPrice, 491.84);
      expect(updatedPlan1.prices.annualDiscountedPrice, 442.66);

      // Plan2
      final updatedPlan2 = plan2.getUpdatedPlanWithPricesCalculated();
      expect(updatedPlan2.prices.annualPrice, 69.96);
      expect(updatedPlan2.prices.annualDiscountedPrice, 62.96);
    });

    test('Seasonal Plan prices', () {
      // Plan 1
      final updatedPlan1 = plan1.getUpdatedPlanWithPricesCalculated();
      expect(updatedPlan1.prices.seasonalPrice, 122.96);

      // Plan 2
      final updatedPlan2 = plan2.getUpdatedPlanWithPricesCalculated();
      expect(updatedPlan2.prices.seasonalPrice, 17.49);
    });
  });
}
