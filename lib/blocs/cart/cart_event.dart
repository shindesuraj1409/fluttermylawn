part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CreateCartEvent extends CartEvent {
  final String customerId;
  final String recommendationId;
  final CartType cartType;
  CreateCartEvent({
    @required this.customerId,
    @required this.recommendationId,
    @required this.cartType,
  });

  @override
  List<Object> get props => [
        customerId,
        recommendationId,
        cartType,
      ];
}

class GetCartTotalsEvent extends CartEvent {
  final String cartId;
  final SubscriptionType selectedSubscriptionType;
  GetCartTotalsEvent({
    @required this.cartId,
    @required this.selectedSubscriptionType,
  });

  @override
  List<Object> get props => [cartId, selectedSubscriptionType];
}

class AddToCartEvent extends CartEvent {
  final Product product;
  final String cartId;
  AddToCartEvent({
    this.product,
    this.cartId,
  });

  @override
  List<Object> get props => [product, cartId];
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;
  final String cartId;
  RemoveFromCartEvent({
    this.product,
    this.cartId,
  });

  @override
  List<Object> get props => [product, cartId];
}

/// This events are fired in case of "Add to Cart" or "Remove from Cart" api fails
/// So, that user can retry "Adding same Product" to the Cart or
/// "Removing same Product" from Cart in those case.
///
/// This needs to be done because when it comes "AddToCartEvent" and
/// "RemoveFromCartEvent" we don't allow sending events with same [Product]
// back to back in order to prevent users from spamming
// the "Add To Cart" or "Remove" buttons when those api calls are in progress
///
/// Preventing duplicate [AddToCartEvent] and [RemoveFromCartEvent] events is done
/// by checking for distinct events in [CartBloc] using [CartBloc.transformEvents] methods
class AddToCartFailureEvent extends CartEvent {}

class RemoveFromCartFailureEvent extends CartEvent {}
