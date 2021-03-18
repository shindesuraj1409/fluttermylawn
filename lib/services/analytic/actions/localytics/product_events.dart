import 'package:localytics_plugin/events/localytics_event.dart';

class ProductAppliedEvent extends LocalyticsEvent {
  ProductAppliedEvent({
    this.productCategory,
    this.productName,
    this.activityFrom,
    this.productId,
    this.dueDate,
  }) : super(
          eventName: 'Product Applied',
          extraAttributes: {
            'Product Category': productCategory,
            'Product name': productName,
            'Activity From': activityFrom,
            'Product ID': productId,
            'Due Date': dueDate,
          },
        );

  final String productCategory;
  final String productName;
  final String activityFrom;
  final String productId;
  final String dueDate;
}

class ProductSkippedEvent extends LocalyticsEvent {
  ProductSkippedEvent({
    this.productCategory,
    this.productName,
    this.activityFrom,
    this.reasonSkipped,
  }) : super(
          eventName: 'Product Skipped',
          extraAttributes: {
            'Product Category': productCategory,
            'Product name': productName,
            'Activity From': activityFrom,
            'Reason Skipped': reasonSkipped,
          },
        );

  final String productCategory;
  final String productName;
  final String activityFrom;
  final String reasonSkipped;
}

class AddProductEvent extends LocalyticsEvent {
  AddProductEvent(this.type, this.productName)
      : super(
          eventName: 'Add a product',
          extraAttributes: {
            'Type': type,
            'Product name': productName,
          },
        );

  final String type;
  final String productName;
}
