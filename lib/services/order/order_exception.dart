class ShippingAddressException implements Exception {
  final String message;
  ShippingAddressException(this.message);
}

class BillingAddressException implements Exception {
  final String message;
  BillingAddressException(this.message);
}

class OrderException implements Exception {
  final String message;
  OrderException(this.message);
}

class RecurlyException implements Exception {
  final String message;
  RecurlyException(this.message);
}
