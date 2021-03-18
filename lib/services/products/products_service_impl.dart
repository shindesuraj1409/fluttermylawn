import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/services/graphql/i_graphql_repository.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:pedantic/pedantic.dart';
import 'package:my_lawn/services/products/products_query.dart' as productsquery;
import 'products_query_by_category.dart' as querycategory;
import 'products_query_for_search.dart' as querysearch;

enum productservicesimpl {
  error,
}

class ProductsServiceImpl implements ProductsService {
  final GraphQlRepository _graphQlRepository = registry<GraphQlRepository>();

  @override
  Future<List<Product>> getProducts({List<String> skuList}) async {
    final response = await _graphQlRepository
        .makeQuery(productsquery.productsQuery(skuList));
    if (response.hasException) {
      registry<Logger>().d(response.exception);
    }
    return ProductResponse.fromJson(response.data.data).products;
  }

  @override
  Future<Product> copyWithGraphQL({Product product}) async {
    final skuList = <String>[];

    if (product.childProducts.isNotEmpty) {
      product.childProducts.forEach((element) {
        skuList.add(element.sku);
      });
    } else {
      skuList.add(product.sku);
    }

    final productResponse = await getProducts(skuList: skuList);

    var prodList = <Product>[];

    if (product.childProducts.isNotEmpty) {
      prodList = productResponse
          .map((e) => product.childProducts
              .firstWhere(
                  (element) => element.sku.toLowerCase() == e.sku.toLowerCase())
              .copyWithProduct(e))
          .toList();

      final errorProducts = product.childProducts
          .where((childProduct) =>
              !productResponse.map((e) => e.sku).contains(childProduct.sku))
          .toList();
      if (errorProducts.isNotEmpty) {
        final error =
            "The following products weren't fetched from graphQL and wont be displayed in the PDP: ${errorProducts.map((e) => e.sku).join(',').toString()}";
        unawaited(FirebaseCrashlytics.instance
            .recordError(error, StackTrace.current));
        registry<Logger>().e(error);
      }
    } else {
      prodList.addAll(productResponse);
    }

    var graphQlProduct = product.fillFields(productResponse.first);

    graphQlProduct = graphQlProduct.copyWith(childProducts: prodList);

    return graphQlProduct;
  }

  @override
  Future<List<Product>> getProductsByCategories(
      {Map<String, dynamic> variables}) async {
    final response = await _graphQlRepository.makeQuery(
        querycategory.productsQueryByCategories,
        variables: variables);
    if (response.hasException) {
      registry<Logger>().d(response.exception);
    }
    return ProductFromCategoryResponse.fromJson(response.data).products;
  }

  @override
  Future<List<Product>> filterProducts(
      List<ProductFilterBlockData> filters) async {
    final buffer = StringBuffer();

    buffer.write('''query
                        {
                        customAttributeFilter(
                          attributes: [ ''');

    for (var filter in filters) {
      buffer.write('{ attribute_code: "${filter.id}", options: [');
      for (var option in filter.filterOptionList) {
        buffer.write('{attribute_option_code: "${option.id}",} ');
      }
      buffer.write(']}');
    }
    buffer.write(''']) 
    {
    items {
      drupal_product_name
      defaultName: name
      drupalproductid
      sku
      mylawn_categories
      mylawn_lawn_condition
      problems_filter
      goals_filter
      image {
        url
      }
    }
  }
  }''');

    final response = await _graphQlRepository.makeQuery(
      buffer.toString(),
    );
    if (response.hasException) {
      registry<Logger>().d(response.exception);
    }
    return ProductFromCategoryResponse.fromJson(response.data).products;
  }

  @override
  Future<List<Product>> searchProducts(String searchString) async {
    final response = await _graphQlRepository.makeQuery(
        querysearch.getProductsQueryForSearch,
        variables: {'searchString': searchString});
    if (response.hasException) {
      registry<Logger>().d(response.exception);
    }
    return ProductResponse.fromJson(response.data).products;
  }
}
