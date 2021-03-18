import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';

abstract class ProductsService {
  Future<List<Product>> getProducts({List<String> skuList});

  Future<Product> copyWithGraphQL({Product product});

  /// Filters products by categories for PLP screens
  Future<List<Product>> getProductsByCategories(
      {Map<String, dynamic> variables});

  Future<List<Product>> filterProducts(List<ProductFilterBlockData> filters);

  Future<List<Product>> searchProducts(String searchString);
}
