import 'package:my_lawn/services/order/order_request_bodies.dart';

abstract class OrderService {
  Future<String> createOrder(CreateOrderRequest orderRequest);

  Future<String> createAddonOrder(CreateOrderRequest orderRequest);
}
