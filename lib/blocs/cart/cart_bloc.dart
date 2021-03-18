import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/cart/cart_api_exceptions.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';

import 'package:my_lawn/extensions/collection_extension.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

part 'cart_event.dart';

part 'cart_state.dart';

const genericErrorMessage = 'Error! Something went wrong. Please try again';
const creatingCartMessage = 'Preparing Cart...';

const loadingCartInfoMessage = 'Getting Order Summary...';

const addingToCartMessage = 'Adding to the Cart';
const removingFromCartMessage = 'Removing from the Cart';

const addToCartSuccessMessage = 'Added to the Cart';
const removeFromCartSuccessMessage = 'Removed from the Cart';

const addToCartErrorMessage = 'Unable to add Product to the Cart. Try again';
const removeFromCartErrorMessage =
    'Unable to remove Product to the Cart. Try again';

enum CartType {
  seasonal,
  annual,
  addOn,
}

extension CartTypeExtension on CartType {
  /// Returns a human readable string representation of the enum value.
  String get string {
    switch (this) {
      case CartType.seasonal:
        return 'seasonal';
      case CartType.annual:
        return 'annual';
      case CartType.addOn:
        return 'addOn';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }
}

class CartBloc extends Bloc<CartEvent, CartState> {
  String _cartId;
  SubscriptionType _selectedSubscriptionType;
  CartType _cartType;
  final CartService _service;

  CartBloc(this._service)
      : assert(_service != null, 'Cart Service is required to use CartBloc'),
        super(CartState.initial());

  String get cartId => _cartId;
  CartType get cartType => _cartType;

  @visibleForTesting
  set selectedSubscriptionType(SubscriptionType subscriptionType) {
    _selectedSubscriptionType = subscriptionType;
  }

  // Actions
  void createCart(String customerId, String recommendationId,
      [SubscriptionType selectedSubscriptionType]) {
    _selectedSubscriptionType = selectedSubscriptionType;

    if (selectedSubscriptionType == SubscriptionType.seasonal) {
      add(CreateCartEvent(
        customerId: customerId,
        recommendationId: recommendationId,
        cartType: CartType.seasonal,
      ));
      _cartType= CartType.seasonal;
    } else if (selectedSubscriptionType == SubscriptionType.annual) {
      add(CreateCartEvent(
        customerId: customerId,
        recommendationId: recommendationId,
        cartType: CartType.annual,
      ));
      _cartType= CartType.annual;
    } else {
      add(CreateCartEvent(
        customerId: customerId,
        recommendationId: recommendationId,
        cartType: CartType.addOn,
      ));
      _cartType= CartType.addOn;
    }
  }

  void getCartTotals(
    String cartId,
    SubscriptionType selectedSubscriptionType,
  ) {
    add(GetCartTotalsEvent(
      cartId: cartId,
      selectedSubscriptionType: selectedSubscriptionType,
    ));
  }

  @override
  Stream<Transition<CartEvent, CartState>> transformEvents(
      Stream<CartEvent> events, transitionFn) {
    return events.distinct((event1, event2) {
      if ((event1 is AddToCartEvent && event2 is AddToCartEvent) ||
          (event1 is RemoveFromCartEvent && event2 is RemoveFromCartEvent)) {
        return event1 == event2;
      } else {
        return false;
      }
    }).flatMap(transitionFn);
  }

  void addToCart(Product product, String cartId) {
    add(AddToCartEvent(
      product: product,
      cartId: cartId,
    ));
  }

  void removeFromCart(Product product, String cartId) {
    add(RemoveFromCartEvent(
      product: product,
      cartId: cartId,
    ));
  }

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CreateCartEvent) {
      yield* _mapCreateCartEventToState(event);
    } else if (event is GetCartTotalsEvent) {
      yield* _mapGetCartTotalsEventToState(event);
    } else if (event is AddToCartEvent) {
      yield* _mapAddToCartEventToState(event);
    } else if (event is RemoveFromCartEvent) {
      yield* _mapRemoveFromCartEventToState(event);
    }
  }

  Stream<CartState> _mapCreateCartEventToState(CreateCartEvent event) async* {
    try {
      yield CartState.creatingCart(creatingCartMessage);
      final cartId = await _service.createCart(
        event.customerId,
        event.recommendationId,
        event.cartType,
      );
      // Saving "cartId" in-memory instance to be used for other requests.
      _cartId = cartId;
      yield CartState.cartCreated();
    } on CreateCartException catch (e) {
      yield CartState.error(e.message);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield CartState.error(genericErrorMessage);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<CartState> _mapGetCartTotalsEventToState(
      GetCartTotalsEvent event) async* {
    try {
      yield CartState.loadingCartInfo(
        state.addOnCartItems,
        loadingCartInfoMessage,
      );

      final cartTotalsFromAPI = await _service.getCartTotals(event.cartId);

      final addOnItemIds = state.addOnCartItems
          .map((addOnCartItem) => addOnCartItem.id)
          .toList();

      final cartTotals = _prepareCartTotalsForOrderSummary(cartTotalsFromAPI,
          event.selectedSubscriptionType, event.cartId, addOnItemIds);

      yield CartState.cartInfoReceived(
        state.addOnCartItems,
        cartTotals,
      );
    } on GetCartTotalsException catch (e) {
      yield CartState.cartInfoError(state.addOnCartItems, e.message);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield CartState.cartInfoError(
          state.addOnCartItems, 'Unable to get Order Summary');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<CartState> _mapAddToCartEventToState(AddToCartEvent event) async* {
    try {
      // Showing add to cart message to user
      yield CartState.addingToCart(
        state.cartTotals,
        state.addOnCartItems,
        addingToCartMessage,
      );

      // Preparing cart items to be added
      final productsToBeAdded = event.product.childProducts;
      final cartItems = _prepareCartItems(productsToBeAdded, event.cartId);

      // Adding products to cart api call
      final itemsAdded = await Future.wait(
          cartItems.map((cartItem) => _service.addToCart(cartItem)));

      // Updating cartItems list to be reflected in UI
      // Adding items which we're just added to the cart.
      final addOnCartItems = [...state.addOnCartItems, ...itemsAdded];
      final addOnItemIds =
          addOnCartItems.map((addOnCartItems) => addOnCartItems.id).toList();

      // Getting updated cartTotals value after the product was added to the cart
      final cartTotals = await _getCartTotalsFromAPI(
        event.cartId,
        addOnItemIds,
      );

      yield CartState.addToCartSuccess(
        cartTotals,
        addOnCartItems,
        addToCartSuccessMessage,
      );
    } on AddToCartException catch (e) {
      add(AddToCartFailureEvent());
      yield CartState.addToCartError(
        state.cartTotals,
        state.addOnCartItems,
        e.message,
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      add(AddToCartFailureEvent());
      yield CartState.addToCartError(
        state.cartTotals,
        state.addOnCartItems,
        addToCartErrorMessage,
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<CartState> _mapRemoveFromCartEventToState(
      RemoveFromCartEvent event) async* {
    try {
      // Showing Removing from cart message to user
      yield CartState.removingFromCart(
        state.cartTotals,
        state.addOnCartItems,
        removingFromCartMessage,
      );

      // Preparing list of Cart Items to be removed
      final productSkusToBeRemoved =
          event.product.childProducts.map((product) => product.sku).toList();
      final cartItemIdsToBeRemoved = <int>[];
      state.addOnCartItems.forEach((cartItem) {
        if (productSkusToBeRemoved.contains(cartItem.sku)) {
          cartItemIdsToBeRemoved.add(cartItem.id);
        }
      });

      // Removing products from Cart api call
      final _ = await Future.wait(cartItemIdsToBeRemoved
          .map(
              (cartItemId) => _service.removeFromCart(event.cartId, cartItemId))
          .toList());

      // Updating cartItems list to be reflected in UI.
      // Filtering out items which we're just removed from cart.
      final addOnCartItems = state.addOnCartItems
          .where((cartItem) => !cartItemIdsToBeRemoved.contains(cartItem.id))
          .toList();

      final addOnItemIds =
          addOnCartItems.map((addOnCartItem) => addOnCartItem.id).toList();

      // Getting updated cartTotals value after the product was removed from cart
      final cartTotals = await _getCartTotalsFromAPI(
        event.cartId,
        addOnItemIds,
      );

      yield CartState.removeFromCartSuccess(
        cartTotals,
        addOnCartItems,
        removeFromCartSuccessMessage,
      );
    } on RemoveFromCartException catch (e) {
      add(RemoveFromCartFailureEvent());
      yield CartState.removeFromCartError(
        state.cartTotals,
        state.addOnCartItems,
        e.message,
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      add(RemoveFromCartFailureEvent());
      yield CartState.removeFromCartError(
        state.cartTotals,
        state.addOnCartItems,
        removeFromCartErrorMessage,
      );
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  // We're grouping products by "sku" so all products with similar sku
  // can be added via one "Add To Cart" api call.
  List<CartItemData> _prepareCartItems(
      Iterable<Product> productsToBeAdded, String cartId) {
    final productsGroupedBySku = productsToBeAdded.groupBy(
      (product) => product.sku,
    );

    final cartItems = <CartItemData>[];
    productsGroupedBySku.forEach((sku, products) {
      final qty = products.fold(
        0,
        (previousValue, product) => previousValue + product.quantity,
      );
      final cartItem = CartItemData(
        sku: sku,
        cartId: cartId,
        qty: qty,
      );
      cartItems.add(cartItem);
    });

    return cartItems;
  }

  CartTotals _prepareCartTotalsForOrderSummary(
    CartTotals cartTotals,
    SubscriptionType selectedSubscriptionType,
    String cartId,
    List<int> addOnItemIds,
  ) {
    // Cart Items apart from recommendation products ones
    final otherCartItems = cartTotals.cartItems
        .where((cartItem) => addOnItemIds.contains(cartItem.id))
        .toList();

    if (selectedSubscriptionType == null) {
      return cartTotals.copyWith(
        cartItems: [
          ...otherCartItems,
        ],
      );
    }

    final recommendationCartItemsRowTotal =
        cartTotals.cartItems.fold<double>(0.0, (previous, current) {
      if (!addOnItemIds.contains(current.id)) {
        return previous + current.rowTotal;
      }
      return previous;
    });

    final recommendationCartItemsQuantityTotal =
        cartTotals.cartItems.fold<int>(0, (previous, current) {
      if (!addOnItemIds.contains(current.id)) {
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

  Future<CartTotals> _getCartTotalsFromAPI(
      String cartId, List<int> addOnItemIds) async {
    try {
      final cartTotalsFromAPI = await _service.getCartTotals(cartId);
      final cartTotals = _prepareCartTotalsForOrderSummary(
        cartTotalsFromAPI,
        _selectedSubscriptionType,
        cartId,
        addOnItemIds,
      );

      return cartTotals;
    } catch (e) {
      rethrow;
    }
  }
}
