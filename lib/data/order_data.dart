import 'dart:convert';
import 'package:data/data.dart';

enum OrderShipmentStatus {
  shipped,
  partiallyShipped,
  delivered,
  invoiced,
  initialized,
  preInvoiced,
  pending,
  blocked,
  processing,
  skipped,
  cancel,
  failed,
  auditFailed,
  unknown
}

OrderShipmentStatus getStatusfromMap(String status) {
  switch (status) {
    case 'shipped':
      return OrderShipmentStatus.shipped;
      break;
    case 'partially shipped':
      return OrderShipmentStatus.partiallyShipped;
      break;
    case 'delivered':
      return OrderShipmentStatus.delivered;
      break;
    case 'invoiced':
      return OrderShipmentStatus.invoiced;
      break;
    case 'initialized':
      return OrderShipmentStatus.initialized;
      break;
    case 'pre-invoiced':
      return OrderShipmentStatus.preInvoiced;
      break;
    case 'pending':
      return OrderShipmentStatus.pending;
      break;
    case 'blocked':
      return OrderShipmentStatus.blocked;
      break;
    case 'processing':
      return OrderShipmentStatus.processing;
      break;
    case 'skipped':
      return OrderShipmentStatus.skipped;
      break;
    case 'cancel':
      return OrderShipmentStatus.cancel;
      break;
    case 'failed':
      return OrderShipmentStatus.failed;
      break;
    case 'audit failed':
      return OrderShipmentStatus.auditFailed;
      break;
    default:
      return OrderShipmentStatus.unknown;
  }
}

extension OrderDataExtension on OrderData {
  bool get isShipped =>
      orderStatus == OrderShipmentStatus.shipped ||
      orderStatus == OrderShipmentStatus.partiallyShipped;
  bool get isDelivered => orderStatus == OrderShipmentStatus.delivered;
  bool get isUpcoming =>
      orderStatus == OrderShipmentStatus.invoiced ||
      orderStatus == OrderShipmentStatus.initialized ||
      orderStatus == OrderShipmentStatus.preInvoiced ||
      orderStatus == OrderShipmentStatus.pending ||
      orderStatus == OrderShipmentStatus.blocked ||
      orderStatus == OrderShipmentStatus.processing;
  bool get isSkipped => orderStatus == OrderShipmentStatus.skipped;

  bool get isCanceled =>
      orderStatus == OrderShipmentStatus.cancel ||
      orderStatus == OrderShipmentStatus.failed ||
      orderStatus == OrderShipmentStatus.auditFailed;

  bool get canBeSkipped =>
      orderStatus == OrderShipmentStatus.initialized ||
      orderStatus == OrderShipmentStatus.pending ||
      orderStatus == OrderShipmentStatus.invoiced ||
          orderStatus == OrderShipmentStatus.preInvoiced ||
      orderStatus == OrderShipmentStatus.processing ||
      orderStatus == OrderShipmentStatus.blocked;

  bool get isProcessing => orderStatus == OrderShipmentStatus.processing;
}

class OrderData extends Data {
  final String orderId;
  final String parentOrderId;
  final String externalId;
  final String previousOrderId;
  final String orderType;
  final String subType;
  final String recurlyPlanCode;
  final String customerId;
  final String recurlyId;
  final String shippingStartDate;
  final String shippingEndDate;
  final String shippingCondition;
  final OrderShipmentStatus orderStatus;
  final String cancellationDate;
  final String recommendationId;
  final String shippingMethod;
  final List<OrderShipmentsData> shipments;

  OrderData({
    this.orderId,
    this.parentOrderId,
    this.externalId,
    this.previousOrderId,
    this.orderType,
    this.subType,
    this.recurlyPlanCode,
    this.customerId,
    this.recurlyId,
    this.shippingStartDate,
    this.shippingEndDate,
    this.shippingCondition,
    this.orderStatus,
    this.cancellationDate,
    this.recommendationId,
    this.shippingMethod,
    this.shipments,
  });

  @override
  List<Object> get props => [
        orderId,
        parentOrderId,
        externalId,
        previousOrderId,
        orderType,
        subType,
        recurlyPlanCode,
        customerId,
        recurlyId,
        shippingStartDate,
        shippingEndDate,
        shippingCondition,
        orderStatus,
        cancellationDate,
        recommendationId,
        shippingMethod,
        shipments
      ];

  OrderData copyWith({
    String orderId,
    String parentOrderId,
    String externalId,
    String previousOrderId,
    String orderType,
    String subType,
    String recurlyPlanCode,
    String customerId,
    String recurlyId,
    String shippingStartDate,
    String shippingEndDate,
    String shippingCondition,
    OrderShipmentStatus orderStatus,
    String cancellationDate,
    String recommendationId,
    String shippingMethod,
    List<OrderShipmentsData> shipments,
  }) {
    return OrderData(
      orderId: orderId ?? this.orderId,
      parentOrderId: parentOrderId ?? this.parentOrderId,
      externalId: externalId ?? this.externalId,
      previousOrderId: previousOrderId ?? this.previousOrderId,
      orderType: orderType ?? this.orderType,
      subType: subType ?? this.subType,
      recurlyPlanCode: recurlyPlanCode ?? this.recurlyPlanCode,
      customerId: customerId ?? this.customerId,
      recurlyId: recurlyId ?? this.recurlyId,
      shippingStartDate: shippingStartDate ?? this.shippingStartDate,
      shippingEndDate: shippingEndDate ?? this.shippingEndDate,
      shippingCondition: shippingCondition ?? this.shippingCondition,
      orderStatus: orderStatus ?? this.orderStatus,
      cancellationDate: cancellationDate ?? this.cancellationDate,
      recommendationId: recommendationId ?? this.recommendationId,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      shipments: shipments ?? this.shipments,
    );
  }

  factory OrderData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderData(
      orderId: map['orderId'],
      parentOrderId: map['parentOrderId'],
      externalId: map['externalId'],
      previousOrderId: map['previousOrderId'],
      orderType: map['orderType'],
      subType: map['subType'],
      recurlyPlanCode: map['recurlyPlanCode'],
      customerId: map['customerId'],
      recurlyId: map['recurlyId'],
      shippingStartDate: map['shippingStartDate'],
      shippingEndDate: map['shippingEndDate'],
      shippingCondition: map['shippingCondition'],
      orderStatus: getStatusfromMap(map['orderStatus']),
      cancellationDate: map['cancellationDate'],
      recommendationId: map['recommendationId'],
      shippingMethod: map['shippingMethod'],
      shipments: List<OrderShipmentsData>.from(
          map['shipments']?.map((x) => OrderShipmentsData.fromMap(x))),
    );
  }

  factory OrderData.fromJson(String source) =>
      OrderData.fromMap(json.decode(source));
}

class OrderShipmentsData extends Data {
  final int generatedShipmentId;
  final String trackingNumber;
  final String shippingId;
  final List<OrderShipmentItemData> shipmentItems;
  OrderShipmentsData({
    this.generatedShipmentId,
    this.trackingNumber,
    this.shippingId,
    this.shipmentItems,
  });

  @override
  List<Object> get props => [
        generatedShipmentId,
        trackingNumber,
        shippingId,
        shipmentItems,
      ];

  OrderShipmentsData copyWith({
    int generatedShipmentId,
    String trackingNumber,
    String shippingId,
    List<OrderShipmentItemData> shipmentItems,
  }) {
    return OrderShipmentsData(
      generatedShipmentId: generatedShipmentId ?? this.generatedShipmentId,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingId: shippingId ?? this.shippingId,
      shipmentItems: shipmentItems ?? this.shipmentItems,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'generatedShipmentId': generatedShipmentId,
      'trackingNumber': trackingNumber,
      'shippingId': shippingId,
      'shipmentItems': shipmentItems?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory OrderShipmentsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderShipmentsData(
      generatedShipmentId: map['generatedShipmentId'],
      trackingNumber: map['trackingNumber'],
      shippingId: map['shippingId'],
      shipmentItems: List<OrderShipmentItemData>.from(
          map['shipmentItems']?.map((x) => OrderShipmentItemData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderShipmentsData.fromJson(String source) =>
      OrderShipmentsData.fromMap(json.decode(source));
}

class OrderShipmentItemData extends Data {
  final int generatedShipmentItemId;
  final String sku;
  final int qty;
  OrderShipmentItemData({
    this.generatedShipmentItemId,
    this.sku,
    this.qty,
  });

  @override
  List<Object> get props => [generatedShipmentItemId, sku, qty];

  OrderShipmentItemData copyWith({
    int generatedShipmentItemId,
    String sku,
    int qty,
  }) {
    return OrderShipmentItemData(
      generatedShipmentItemId:
          generatedShipmentItemId ?? this.generatedShipmentItemId,
      sku: sku ?? this.sku,
      qty: qty ?? this.qty,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'generatedShipmentItemId': generatedShipmentItemId,
      'sku': sku,
      'qty': qty,
    };
  }

  factory OrderShipmentItemData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderShipmentItemData(
      generatedShipmentItemId: map['generatedShipmentItemId'],
      sku: map['sku'],
      qty: map['qty'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderShipmentItemData.fromJson(String source) =>
      OrderShipmentItemData.fromMap(json.decode(source));
}
