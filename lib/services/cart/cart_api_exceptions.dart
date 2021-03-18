class CreateCartException implements Exception {
  final String message;
  CreateCartException(this.message);
}

class AddToCartException implements Exception {
  final String message;
  final String sku;
  AddToCartException({this.message, this.sku});
}

class RemoveFromCartException implements Exception {
  final String message;
  final int itemId;
  RemoveFromCartException({this.message, this.itemId});
}

class InvalidCouponCodeException implements Exception {
  final String message;
  final String couponCode;
  InvalidCouponCodeException({this.message, this.couponCode});
}

class GetCartTotalsException implements Exception {
  final String message;
  GetCartTotalsException(this.message);
}

class GetCartInfoException implements Exception {
  final String message;
  GetCartInfoException(this.message);
}
