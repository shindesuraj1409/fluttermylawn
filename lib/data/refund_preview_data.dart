import 'dart:convert';

import 'package:data/data.dart';

class RefundData extends Data {
  final bool canBeCanceled;
  final double estimatedRefund;
  final List<Product> products;
  RefundData({
    this.canBeCanceled,
    this.estimatedRefund,
    this.products,
  });

  RefundData copyWith({
    bool canBeCanceled,
    double estimatedRefund,
    List<Product> products,
  }) {
    return RefundData(
      canBeCanceled: canBeCanceled ?? this.canBeCanceled,
      estimatedRefund: estimatedRefund ?? this.estimatedRefund,
      products: products ?? this.products,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'canBeCanceled': canBeCanceled,
      'estimatedRefund': estimatedRefund,
      'products': products?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory RefundData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RefundData(
      canBeCanceled: map['canBeCanceled'],
      estimatedRefund: map['estimatedRefund'] / 1.0,
      products:
          List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RefundData.fromJson(String source) =>
      RefundData.fromMap(json.decode(source));

  @override
  List<Object> get props => [canBeCanceled, estimatedRefund, products];
}

class Product extends Data {
  final int generatedProductId;
  final String productId;
  final String sku;
  final String productName;
  final int qty;
  final double price;
  final String createdAt;
  final String updatedAt;
  final String shippingStartDate;
  final String shippingEndDate;
  final String applicationWindowStartDate;
  final String applicationWindowEndDate;
  final double taxAmount;
  final double parentPrice;
  final String productType;
  Product({
    this.generatedProductId,
    this.productId,
    this.sku,
    this.productName,
    this.qty,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.shippingStartDate,
    this.shippingEndDate,
    this.applicationWindowStartDate,
    this.applicationWindowEndDate,
    this.taxAmount,
    this.parentPrice,
    this.productType,
  });

  Product copyWith({
    int generatedProductId,
    String productId,
    String sku,
    String productName,
    int qty,
    double price,
    String createdAt,
    String updatedAt,
    String shippingStartDate,
    String shippingEndDate,
    String applicationWindowStartDate,
    String applicationWindowEndDate,
    double taxAmount,
    double parentPrice,
    String productType,
  }) {
    return Product(
      generatedProductId: generatedProductId ?? this.generatedProductId,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shippingStartDate: shippingStartDate ?? this.shippingStartDate,
      shippingEndDate: shippingEndDate ?? this.shippingEndDate,
      applicationWindowStartDate:
          applicationWindowStartDate ?? this.applicationWindowStartDate,
      applicationWindowEndDate:
          applicationWindowEndDate ?? this.applicationWindowEndDate,
      taxAmount: taxAmount ?? this.taxAmount,
      parentPrice: parentPrice ?? this.parentPrice,
      productType: productType ?? this.productType,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'generatedProductId': generatedProductId,
      'productId': productId,
      'sku': sku,
      'productName': productName,
      'qty': qty,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'shippingStartDate': shippingStartDate,
      'shippingEndDate': shippingEndDate,
      'applicationWindowStartDate': applicationWindowStartDate,
      'applicationWindowEndDate': applicationWindowEndDate,
      'taxAmount': taxAmount,
      'parentPrice': parentPrice,
      'productType': productType,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      generatedProductId: map['generatedProductId'],
      productId: map['productId'],
      sku: map['sku'],
      productName: map['productName'],
      qty: map['qty'],
      price: map['price'] is String
          ? double.parse(map['price'])
          : (map['price'] as num)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      shippingStartDate: map['shippingStartDate'],
      shippingEndDate: map['shippingEndDate'],
      applicationWindowStartDate: map['applicationWindowStartDate'],
      applicationWindowEndDate: map['applicationWindowEndDate'],
      taxAmount: (map['taxAmount'] as num)?.toDouble() ?? 0.0,
      parentPrice: map['parentPrice'] is String
          ? double.parse(map['parentPrice'])
          : (map['parentPrice'] as num)?.toDouble() ?? 0.0,
      productType: map['productType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  List<Object> get props => [
        generatedProductId,
        productId,
        sku,
        productName,
        qty,
        price,
        createdAt,
        updatedAt,
        shippingStartDate,
        shippingEndDate,
        applicationWindowStartDate,
        applicationWindowEndDate,
        taxAmount,
        parentPrice,
        productType
      ];
}
