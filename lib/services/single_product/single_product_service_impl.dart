import 'dart:convert';

import 'package:logger/logger.dart';

import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/services/graphql/i_graphql_repository.dart';

import 'product_query.dart' as query;
import '../products/products_query.dart' as productsquery;

abstract class SingleProductService {
  Future<Product> getProduct({SingleProductResponse product});
  Future<SingleProductResponse> getProductSku({Map<String, dynamic> variables});
  Future<List<Product>> getProducts({List<String> products});
}

class SingleProductServiceImpl implements SingleProductService {
  final GraphQlRepository _graphQlRepository = registry<GraphQlRepository>();

  @override
  Future<SingleProductResponse> getProductSku(
      {Map<String, dynamic> variables}) async {
    final response = await _graphQlRepository.makeQuery(query.productQuery,
        variables: variables);
    if (response.hasException) {
      registry<Logger>().d(response.exception);
      throw Exception(response.exception);
    }
    return SingleProductResponse.fromMap(
        response.data.data['customAttributeFilter']['items'].first);
  }

  @override
  Future<Product> getProduct({SingleProductResponse product}) async {
    try {
      final skuList = <String>[];

      skuList.add(product.sku);

      final productResponse = await getProducts(products: skuList);

      final prodList = <Product>[];

      for (var product in productResponse.first.childProducts) {
        Product pp;
        pp = productResponse.firstWhere(
          (responseProduct) =>
              responseProduct.sku.toLowerCase() == product.sku.toLowerCase(),
        );
        prodList.add(product.copyWithProduct(pp));
      }

      final productReturn = Product();

      var graphQlProduct = productReturn.fillFields(productResponse.first);
      graphQlProduct = graphQlProduct.copyWith(childProducts: prodList);

      return graphQlProduct;
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProducts({List<String> products}) async {
    final response = await _graphQlRepository
        .makeQuery(productsquery.productsQuery(products));
    if (response.hasException) {
      registry<Logger>().d(response.exception);
      throw Exception(response.exception);
    }
    return ProductResponse.fromJson(response.data.data).products;
  }
}

class SingleProductResponse {
  final String name;
  final String sku;

  SingleProductResponse({this.name, this.sku});

  factory SingleProductResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SingleProductResponse(
      name: (map['drupal_product_name'] ?? map['defaultName']) as String,
      sku: map['sku'],
    );
  }

  factory SingleProductResponse.fromJson(String source) =>
      SingleProductResponse.fromMap(json.decode(source));
}
