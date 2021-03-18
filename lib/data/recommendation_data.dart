import 'package:data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/extensions/double_extension.dart';
import 'package:pedantic/pedantic.dart';

class Recommendation extends Data {
  final String recommendationId;
  final Plan plan;
  final LawnData lawnData;
  final DateTime completedAt;

  Recommendation({
    this.completedAt,
    this.recommendationId,
    this.plan,
    this.lawnData,
  });

  Recommendation.fromJson(Map<String, dynamic> map)
      : recommendationId = map['recommendationId'] as String,
        plan = Plan.fromJson(map['plan']),
        completedAt = DateTime.tryParse(map['completedAt'] as String),
        lawnData = map['answerValues'] != null
            ? LawnData.fromQuizAnswers(map['answerValues'])
            : null;

  Recommendation copyWith({
    String recommendationId,
    Plan plan,
    LawnData lawnData,
  }) {
    return Recommendation(
      recommendationId: recommendationId ?? this.recommendationId,
      plan: plan ?? this.plan,
      lawnData: lawnData ?? this.lawnData,
    );
  }

  @override
  List<Object> get props => [recommendationId, plan, completedAt, lawnData];
}

class Plan extends Equatable {
  final List<Product> products;
  final List<Product> addOnProducts;

  // This field doesn't comes from api and is calculated client side
  // using [getUpdatedPlanWithPricesCalculated] method
  final Prices prices;

  Plan({
    this.products,
    this.addOnProducts,
    this.prices,
  });

  Plan.fromJson(Map<String, dynamic> map)
      : products = List<Product>.from(
          map['products']?.map(
                (product) => Product.fromJson(product),
              ) ??
              [],
        ),
        addOnProducts = List<Product>.from(
          map['addOnProducts']?.map(
                (product) => Product.fromJson(product),
              ) ??
              [],
        ),
        prices = null;

  Plan copyWith({
    List<Product> products,
    List<Product> addOnProducts,
    Prices prices,
  }) {
    return Plan(
      products: products ?? this.products,
      addOnProducts: addOnProducts ?? this.addOnProducts,
      prices: prices ?? this.prices,
    );
  }

  factory Plan.fromActivities({List<ActivityData> activities}) {
    final productList = <Product>[];

    if (activities != null) {
      for (var activity in activities) {
        var p = activity.childProducts.first;

        p = p.copyWith(
          parentSku: activity.productId,
          applicationWindow: activity.applicationWindow,
          childProducts: activity.childProducts,
          activityId: activity.activityId,
          applied: activity.applied,
          skipped: activity.skipped,
        );

        productList.add(p);
      }
    }

    return Plan(products: productList);
  }

  Plan getUpdatedPlanWithPricesCalculated() {
    final products = _updateProductPrices(this.products);
    final addOnProducts = _updateProductPrices(this.addOnProducts);

    final annualPlanPrice =
        products.fold(0.0, (prev, current) => prev + current.bundlePrice);

    final double annualDiscountedPrice = annualPlanPrice * 0.9;

    final plan = copyWith(
        products: products,
        addOnProducts: addOnProducts,
        prices: Prices(
          annualPrice: annualPlanPrice,
          annualDiscountedPrice: annualDiscountedPrice.toPrecision(2),
          seasonalPrice: products.isNotEmpty ? products.first.bundlePrice : 0.0,
        ));

    return plan;
  }

  List<Product> _updateProductPrices(List<Product> products) {
    return products
        .map((product) {
          var bundlePrice = 0.0;
          product.childProducts.forEach(
            (childProduct) {
              _logExceptionIfProductPriceIsNull(childProduct);

              bundlePrice +=
                  (childProduct.price ?? 0.0) * (childProduct.quantity ?? 1);
            },
          );
          final updatedProduct =
              product.copyWith(bundlePrice: bundlePrice.toPrecision(2));
          return updatedProduct;
        })
        .where((product) => product.bundlePrice > 0)
        .toList();
  }

  void _logExceptionIfProductPriceIsNull(Product product) async {
    if (product.price == null) {
      unawaited(FirebaseCrashlytics.instance.recordError(
        Exception('Product ${product.sku} has null price'),
        null,
        reason: 'Receiving product with null price',
      ));
    }
  }

  @override
  List<Object> get props => [products, addOnProducts];
}

/// A data class used to represent [Plan] prices like
/// - annualPrice
/// - annualDiscountPrice
/// - seasonalPrice
class Prices extends Equatable {
  final double annualPrice;
  final double annualDiscountedPrice;
  final double seasonalPrice;

  Prices({
    this.annualPrice,
    this.annualDiscountedPrice,
    this.seasonalPrice,
  });

  @override
  List<Object> get props => [annualPrice, annualDiscountedPrice, seasonalPrice];
}
