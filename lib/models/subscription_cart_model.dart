import 'package:my_lawn/data/subscription_data.dart';

class SubscriptionCartData {
  final SubscriptionType subscriptionType;
  final String price;
  final String discountedPrice;
  final List<String> subscriptionImages;

  SubscriptionCartData(
    this.subscriptionType,
    this.price,
    this.discountedPrice,
    this.subscriptionImages,
  );
}
