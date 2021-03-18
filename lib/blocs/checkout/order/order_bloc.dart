import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/blocs/checkout/order/order_event.dart';
import 'package:my_lawn/blocs/checkout/order/order_state.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/order/i_order_service.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/order/order_request_bodies.dart';
import 'package:pedantic/pedantic.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';

const genericErrorMessage = 'Something went wrong. Please try again';

class OrderBloc extends Bloc<CreateOrderEvent, OrderState> {
  final OrderService _orderService;

  OrderBloc(this._orderService)
      : assert(_orderService != null,
            'Order Service is required to use OrderBloc'),
        super(OrderInitialState());

  // actions
  void createOrder(
    String recommendationId,
    String customerId,
    String cartId,
    CartType cartType,
    List<String> addOnSkus,
    SubscriptionType selectedSubscriptionType,
    String phone,
    String recurlyToken,
    int subscriptionId,
  ) {
    add(CreateOrderEvent(
      recommendationId,
      customerId,
      cartId,
      cartType,
      addOnSkus,
      selectedSubscriptionType,
      phone,
      recurlyToken,
      subscriptionId,
    ));
  }

  @override
  Stream<OrderState> mapEventToState(CreateOrderEvent event) async* {
    if (event is CreateOrderEvent) {
      yield (CreatingOrderState());

      try {
        final orderRequest = CreateOrderRequest(
          subType: event.selectedSubscriptionType,
          customerId: event.customerId,
          recommendationId: event.recommendationId,
          cartId: event.cartId,
          phone: event.phone,
          recurlyToken: event.recurlyToken,
          addOnSkus: event.addOnSkus,
          subscriptionId: event.subscriptionId,
        );

        var _orderId;

        if (event.cartType == CartType.addOn) {
          _orderId = await _orderService.createAddonOrder(orderRequest);
        } else {
          _orderId = await _orderService.createOrder(orderRequest);
        }

        yield (OrderSuccessState(_orderId));
      } on OrderException catch (e) {
        yield (OrderFailureState(errorMessage: e.message));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield (OrderFailureState(errorMessage: genericErrorMessage));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
  }
}
