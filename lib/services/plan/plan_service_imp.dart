import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/plan/i_plan_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';

class PlanServiceImpl implements PlanService {
  final ProductsService _productsService = registry<ProductsService>();

  @override
  Future<Plan> copyWithGraphQL({
    Plan plan,
    List<String> products,
  }) async {
    final productResponse =
        await _productsService.getProducts(skuList: products);

    Plan pl;
    final parentProdList = <Product>[];
    for (var parentProduct in plan.products) {
      final prodList = <Product>[];
      for (var product in parentProduct.childProducts) {
        Product pp;
        pp = productResponse.firstWhere(
          (responseProduct) =>
              responseProduct.sku.toLowerCase() == product.sku.toLowerCase(),
        );
        prodList.add(product.copyWithProduct(pp));
      }
      parentProdList.add(parentProduct.copyWith(childProducts: prodList));
    }
    pl = plan.copyWith(products: parentProdList);

    return pl;
  }
}
