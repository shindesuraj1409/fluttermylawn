import 'dart:convert';

import 'package:data/data.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/screens/checkout/widgets/payment_subscreen_widget.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';

enum SubscriptionType {
  annual,
  seasonal,
}

extension SubscriptionTypeExtension on SubscriptionType {
  String get string {
    switch (this) {
      case SubscriptionType.annual:
        return 'Annual Lawn Subscription Plan';
      case SubscriptionType.seasonal:
        return 'Seasonal Lawn Subscription Plan';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  String get planName {
    switch (this) {
      case SubscriptionType.annual:
        return 'annual';
      case SubscriptionType.seasonal:
        return 'seasonal';
      default:
        throw UnimplementedError('Missing planName for $this');
    }
  }

  bool get isAnnual => this == SubscriptionType.annual;

  bool get isSeasonal => this == SubscriptionType.seasonal;
}

extension PaymentTypeExtension on PaymentType {
  String get iconPath {
    switch (this) {
      case PaymentType.payPal:
        return 'assets/icons/paypal.png';
        break;
      case PaymentType.applePay:
        return 'assets/icons/apple_pay.png';
        break;
      case PaymentType.googlePay:
        return 'assets/icons/google_pay.png';
        break;
      case PaymentType.visa:
        return 'assets/icons/payment_visa.png';
        break;
      case PaymentType.mastercard:
        return 'assets/icons/payment_mastercard.png';
        break;
      default:
        return 'assets/icons/payment.png';
    }
  }
}

class SubscriptionShipment extends Data {
  final int id;
  final String parentOrderId;
  final String orderId;
  final String planCode;
  final String price;
  final String paid;
  final String pricingDate;
  final String recurlySubscription;
  final String recurlyInvoice;
  final String recurlyLineItem;
  final String gatewayReference;
  final String refundGatewayReference;
  final String refundAmount;
  final String startDate;
  final String status;
  final String tax;
  final String subTotal;
  final String discounts;
  final String createdAt;
  final String updatedAt;
  final String canceledAt;
  final String chargedAt;
  final String billingAt;
  final String deliveredAt;
  final List<ShipmentProduct> products;
  final String invoiceAt;

  SubscriptionShipment({
    this.id,
    this.parentOrderId,
    this.orderId,
    this.planCode,
    this.price,
    this.paid,
    this.pricingDate,
    this.recurlySubscription,
    this.recurlyInvoice,
    this.recurlyLineItem,
    this.gatewayReference,
    this.refundGatewayReference,
    this.refundAmount,
    this.startDate,
    this.status,
    this.tax,
    this.subTotal,
    this.discounts,
    this.createdAt,
    this.updatedAt,
    this.canceledAt,
    this.chargedAt,
    this.billingAt,
    this.deliveredAt,
    this.products,
    this.invoiceAt,
  });

  SubscriptionShipment copyWith({
    int id,
    String parentOrderId,
    String orderId,
    String planCode,
    String price,
    String paid,
    String pricingDate,
    String recurlySubscription,
    String recurlyInvoice,
    String recurlyLineItem,
    String gatewayReference,
    String refundGatewayReference,
    String refundAmount,
    String startDate,
    String status,
    String tax,
    String subTotal,
    String discounts,
    String createdAt,
    String updatedAt,
    String canceledAt,
    String chargedAt,
    String billingAt,
    String deliveredAt,
    List<ShipmentProduct> products,
    String invoiceAt,
  }) {
    return SubscriptionShipment(
      id: id ?? this.id,
      parentOrderId: parentOrderId ?? this.parentOrderId,
      orderId: orderId ?? this.orderId,
      planCode: planCode ?? this.planCode,
      price: price ?? this.price,
      paid: paid ?? this.paid,
      pricingDate: pricingDate ?? this.pricingDate,
      recurlySubscription: recurlySubscription ?? this.recurlySubscription,
      recurlyInvoice: recurlyInvoice ?? this.recurlyInvoice,
      recurlyLineItem: recurlyLineItem ?? this.recurlyLineItem,
      gatewayReference: gatewayReference ?? this.gatewayReference,
      refundGatewayReference:
          refundGatewayReference ?? this.refundGatewayReference,
      refundAmount: refundAmount ?? this.refundAmount,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      tax: tax ?? this.tax,
      subTotal: subTotal ?? this.subTotal,
      discounts: discounts ?? this.discounts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      chargedAt: chargedAt ?? this.chargedAt,
      billingAt: billingAt ?? this.billingAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      products: products ?? this.products,
      invoiceAt: invoiceAt ?? this.invoiceAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentOrderId': parentOrderId,
      'orderId': orderId,
      'planCode': planCode,
      'price': price,
      'paid': paid,
      'pricingDate': pricingDate,
      'recurlySubscription': recurlySubscription,
      'recurlyInvoice': recurlyInvoice,
      'recurlyLineItem': recurlyLineItem,
      'gatewayReference': gatewayReference,
      'refundGatewayReference': refundGatewayReference,
      'refundAmount': refundAmount,
      'startDate': startDate,
      'status': status,
      'tax': tax,
      'subTotal': subTotal,
      'discounts': discounts,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'canceledAt': canceledAt,
      'chargedAt': chargedAt,
      'billingAt': billingAt,
      'deliveredAt': deliveredAt,
      'products': products?.map((x) => x?.toMap())?.toList(),
      'invoiceAt': invoiceAt,
    };
  }

  factory SubscriptionShipment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SubscriptionShipment(
      id: map['id'],
      parentOrderId: map['parentOrderId'],
      orderId: map['orderId'],
      planCode: map['planCode'],
      price: map['price'],
      paid: map['paid'],
      pricingDate: map['pricingDate'],
      recurlySubscription: map['recurlySubscription'],
      recurlyInvoice: map['recurlyInvoice'],
      recurlyLineItem: map['recurlyLineItem'],
      gatewayReference: map['gatewayReference'],
      refundGatewayReference: map['refundGatewayReference'],
      refundAmount: map['refundAmount'],
      startDate: map['startDate'],
      status: map['status'],
      tax: map['tax'],
      subTotal: map['subTotal'],
      discounts: map['discounts'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      canceledAt: map['canceledAt'],
      chargedAt: map['chargedAt'],
      billingAt: map['billingAt'],
      deliveredAt: map['deliveredAt'],
      products: List<ShipmentProduct>.from(
          map['products']?.map((x) => ShipmentProduct.fromMap(x))),
      invoiceAt: map['invoiceAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionShipment.fromJson(String source) =>
      SubscriptionShipment.fromMap(json.decode(source));

  @override
  List<Object> get props => [
        id,
        parentOrderId,
        orderId,
        planCode,
        price,
        paid,
        pricingDate,
        recurlySubscription,
        recurlyInvoice,
        recurlyLineItem,
        gatewayReference,
        refundGatewayReference,
        refundAmount,
        startDate,
        status,
        tax,
        subTotal,
        discounts,
        createdAt,
        updatedAt,
        canceledAt,
        products,
        chargedAt,
        billingAt,
        deliveredAt,
        invoiceAt
      ];
}

class ShipmentProduct extends Data {
  final int id;
  final String productId;
  final String productName;
  final String sku;
  final int qty;
  final String price;
  final String createdAt;
  final String updatedAt;
  final DateTime shippingStartDate;
  final DateTime shippingEndDate;
  final String season;
  final int coverage;
  final String description;
  final String shortDescription;
  final String thumbnailLabel;
  final String thumbnailImage;

  ShipmentProduct({
    this.id,
    this.productId,
    this.productName,
    this.sku,
    this.qty,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.shippingStartDate,
    this.shippingEndDate,
    this.season,
    this.coverage,
    this.description,
    this.shortDescription,
    this.thumbnailLabel,
    this.thumbnailImage,
  });

  @override
  List<Object> get props => [
        id,
        productId,
        productName,
        sku,
        qty,
        price,
        createdAt,
        updatedAt,
        shippingStartDate,
        shippingEndDate,
        season,
        coverage,
        description,
        shortDescription,
        thumbnailLabel,
        thumbnailImage,
      ];

  ShipmentProduct copyWith({
    int id,
    String productId,
    String productName,
    String sku,
    int qty,
    String price,
    String createdAt,
    String updatedAt,
    DateTime shippingStartDate,
    DateTime shippingEndDate,
    String season,
    int coverage,
    String description,
    String shortDescription,
    String thumbnailLabel,
    String thumbnailImage,
  }) {
    return ShipmentProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shippingStartDate: shippingStartDate ?? this.shippingStartDate,
      shippingEndDate: shippingEndDate ?? this.shippingEndDate,
      season: season ?? this.season,
      coverage: coverage ?? this.coverage,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      thumbnailLabel: thumbnailLabel ?? this.thumbnailLabel,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'sku': sku,
      'qty': qty,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'shippingStartDate': shippingStartDate,
      'shippingEndDate': shippingEndDate,
      'season': season,
      'coverage': coverage,
      'description': description,
      'shortDescription': shortDescription,
      'thumbnailLabel': thumbnailLabel,
      'thumbnailImage': thumbnailImage,
    };
  }

  factory ShipmentProduct.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ShipmentProduct(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      sku: map['sku'],
      qty: map['qty'],
      price: map['price'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      shippingStartDate: DateTime.tryParse(map['shippingStartDate']),
      shippingEndDate: DateTime.tryParse(map['shippingEndDate']),
      season: map['season'],
      coverage: map['coverage'],
      description: map['description'],
      shortDescription: map['shortDescription'],
      thumbnailLabel: map['thumbnailLabel'],
      thumbnailImage: map['thumbnailImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipmentProduct.fromJson(String source) =>
      ShipmentProduct.fromMap(json.decode(source));
}

class SubscriptionData extends Data {
  final SubscriptionType subscriptionType;
  final List<SubscriptionShipment> shipments;
  final AddressData shippingAddress;
  final AddressData billingAddress;
  final String startedAt;
  final String renewalAt;
  final String canceledAt;
  final SubscriptionStatus subscriptionStatus;
  final String orderId;
  final String recommendationId;
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String amountPaid;
  final String refundAmount;
  final String ccLastFour;
  final PaymentType ccType;
  final int changes;

  SubscriptionData({
    this.id,
    this.subscriptionType,
    this.shipments = const [],
    this.shippingAddress,
    this.billingAddress,
    this.startedAt,
    this.renewalAt,
    this.canceledAt,
    this.subscriptionStatus,
    this.orderId,
    this.recommendationId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.amountPaid,
    this.refundAmount,
    this.ccLastFour,
    this.ccType,
    this.changes = 0,
  });

  SubscriptionData copyWith({
    int id,
    SubscriptionType subscriptionType,
    List<SubscriptionShipment> shipments,
    AddressData shippingAddress,
    AddressData billingAddress,
    DateTime startedAt,
    DateTime renewalAt,
    DateTime canceledAt,
    DateTime expiredAt,
    SubscriptionStatus subscriptionStatus,
    String orderId,
    String recommendationId,
    String firstName,
    String lastName,
    String email,
    String phone,
    double amountPaid,
    double refundAmount,
    DateTime purchasedAt,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime renewsAt,
    String ccLastFour,
    String ccType,
    int changes,
  }) =>
      SubscriptionData(
        id: id ?? this.id,
        subscriptionType: subscriptionType ?? this.subscriptionType,
        shipments: shipments ?? this.shipments,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        billingAddress: billingAddress ?? this.billingAddress,
        startedAt: startedAt ?? this.startedAt,
        renewalAt: renewalAt ?? this.renewalAt,
        canceledAt: canceledAt ?? this.canceledAt,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        orderId: orderId ?? this.orderId,
        recommendationId: recommendationId ?? this.recommendationId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        amountPaid: amountPaid ?? this.amountPaid,
        refundAmount: refundAmount ?? this.refundAmount,
        ccLastFour: ccLastFour ?? this.ccLastFour,
        ccType: ccType ?? this.ccType,
        changes: changes ?? this.changes,
      );

  @override
  List<Object> get props => [
        id,
        subscriptionType,
        shipments,
        shippingAddress,
        billingAddress,
        startedAt,
        renewalAt,
        canceledAt,
        subscriptionStatus,
        orderId,
        recommendationId,
        firstName,
        lastName,
        email,
        phone,
        amountPaid,
        refundAmount,
        ccLastFour,
        ccType,
        changes,
      ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subscriptionType': json.encode(subscriptionType.toString()),
      'shipments': shipments?.map((x) => x?.toMap())?.toList(),
      'shippingAddress': shippingAddress?.toMap(),
      'billingAddress': billingAddress?.toMap(),
      'startedAt': startedAt,
      'renewalAt': renewalAt,
      'canceledAt': canceledAt,
      'subscriptionStatus': json.encode(subscriptionStatus.toString()),
      'orderId': orderId,
      'recommendationId': recommendationId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'amountPaid': amountPaid.toString(),
      'refundAmount': refundAmount.toString(),
      'ccType': ccType.toString(),
      'ccLastFour': ccLastFour.toString(),
      'changes': changes,
    };
  }

  factory SubscriptionData.fromMap(Map<String, dynamic> map, [changes = 0]) {
    if (map == null) return null;

    return SubscriptionData(
      id: map['id'] ?? 0,
      changes: changes,
      subscriptionType: map['type'] == 'annual'
          ? SubscriptionType.annual
          : SubscriptionType.seasonal,
      shipments: List<SubscriptionShipment>.from(
          map['intervals']?.map((x) => SubscriptionShipment.fromMap(x))),
      shippingAddress: AddressData.fromMap(map['shippingAddress']),
      billingAddress: AddressData.fromMap(map['billingAddress']),
      startedAt: map['purchasedAt'],
      renewalAt: map['renewsAt'],
      canceledAt: map['canceledAt'],
      subscriptionStatus:
          (map['status'] == 'pending' || map['status'] == 'processing')
              ? SubscriptionStatus.pending
              : (map['status'] == 'canceled' ||
                      map['status'] == 'completed' ||
                      map['status'] == 'closed')
                  ? SubscriptionStatus.canceled
                  : SubscriptionStatus.active,
      orderId: map['orderId'],
      recommendationId: map['recommendationId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      amountPaid: map['paid'],
      refundAmount: map['refundAmount'],
      ccLastFour: map['ccLastFour'],
      ccType: map['ccType'] == 'Visa'
          ? PaymentType.visa
          : map['ccType'] == 'MasterCard'
              ? PaymentType.mastercard
              : map['ccType'] == 'paypal'
                  ? PaymentType.payPal
                  : map['ccType'] == 'applePay'
                      ? PaymentType.applePay
                      : map['ccType'] == 'googlePay'
                          ? PaymentType.googlePay
                          : PaymentType.none,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionData.fromJson(String source) {
    final decoded = json.decode(source);
    if (decoded.isEmpty) {
      throw FindSubscriptionByCustomerIdException(
          errorMessage: 'Subscriptions are empty');
    }
    return SubscriptionData.fromMap(decoded);
  }
}
