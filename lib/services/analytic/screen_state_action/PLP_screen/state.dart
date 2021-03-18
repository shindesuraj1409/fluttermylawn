import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class PLPScreenAdobeState extends AdobeAnalyticState {
  final String filters;

  PLPScreenAdobeState({
    this.filters,
  }) : super(
          type: 'PLPScreenAdobeState',
          state: 'all categories',
        );

  @override
  Map<String, String> getData() {
    return {
      's.filters': filters,
      's.type': 'product category',
    };
  }
}

class ProductCategoryScreenAdobeState extends AdobeAnalyticState {
  final ProductCategory category;

  ProductCategoryScreenAdobeState({
    this.category,
  }) : super(
          type: 'ProductCategoryScreenAdobeState',
          state: '${category.title.toLowerCase()}',
        );

  @override
  Map<String, String> getData() {
    return {
      's.filters': category.type,
      's.type': 'product category',
    };
  }
}
