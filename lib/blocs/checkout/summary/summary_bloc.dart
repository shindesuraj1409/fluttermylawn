import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:my_lawn/blocs/checkout/summary/summary_event.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_state.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/cart/cart_api_exceptions.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:pedantic/pedantic.dart';

const genericErrorMessage = 'Something went wrong. Please try again';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  final CartService _cartService;
  OrderSummaryBloc(this._cartService)
      : assert(
            _cartService != null, 'Cart Service is required to use CartBloc'),
        super(OrderSummaryInitialState());

  // actions
  void getOrderSummary(
    String cartId,
    SubscriptionType selectedSubscriptionType,
    List<String> addOnSkus,
  ) {
    add(OrderSummaryEvent(
      cartId,
      selectedSubscriptionType,
      addOnSkus,
    ));
  }

  @override
  Stream<OrderSummaryState> mapEventToState(OrderSummaryEvent event) async* {
    if (event is OrderSummaryEvent) {
      yield (OrderSummaryLoadingState());

      try {
        final cartTotals = await _cartService.getCartTotals(event.cartId);

        yield (OrderSummarySuccessState(
          cartTotals: _prepareCartTotalsForOrderSummary(
            event.cartId,
            cartTotals,
            event.selectedSubscriptionType,
            event.addOnSkus,
          ),
        ));
      } on GetCartTotalsException catch (e) {
        yield (OrderSummaryFailure(errorMessage: e.message));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      } catch (e) {
        yield (OrderSummaryFailure(errorMessage: genericErrorMessage));
        unawaited(
            FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      }
    }
  }

  CartTotals _prepareCartTotalsForOrderSummary(
    String cartId,
    CartTotals cartTotals,
    SubscriptionType selectedSubscriptionType,
    List<String> addOnSkus,
  ) {
    // When user is adding "add-on" to existing subscription,
    // "selectedSubscriptionType"  will be null.
    // We should simply return "cartTotals" we receive from api
    // and no transformation is needed to be applied
    // unlike required during "annual/seasonal" purchase flow
    // to show "add-on" and "recommendation" items separately.
    if (selectedSubscriptionType == null) {
      return cartTotals;
    }

    // Cart Items apart from recommendation products ones
    final otherCartItems = cartTotals.cartItems
        .where((cartItem) => addOnSkus.contains(cartItem.sku))
        .toList();

    final recommendationCartItemsRowTotal =
        cartTotals.cartItems.fold<double>(0.0, (previous, current) {
      if (!addOnSkus.contains(current.sku)) {
        return previous + current.rowTotal;
      }
      return previous;
    });

    final recommendationCartItemsQuantityTotal =
        cartTotals.cartItems.fold<int>(0, (previous, current) {
      if (!addOnSkus.contains(current.sku)) {
        return previous + current.qty;
      }
      return previous;
    });

    // Create one Cart Item for entire recommendation products
    final recommendationCartItem = CartItemData(
      id: -1,
      cartId: cartId,
      name: selectedSubscriptionType == SubscriptionType.annual
          ? 'Annual Subscription'
          : 'Seasonal Subscription',
      rowTotal: recommendationCartItemsRowTotal,
      qty: recommendationCartItemsQuantityTotal,
    );

    final updatedCartTotals = cartTotals.copyWith(
      cartItems: [
        recommendationCartItem,
        ...otherCartItems,
      ],
    );

    return updatedCartTotals;
  }
}
