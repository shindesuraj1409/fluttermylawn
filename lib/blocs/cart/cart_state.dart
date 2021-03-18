part of 'cart_bloc.dart';

enum CartStatus {
  initial,
  creatingCart,
  cartCreated,
  loadingCartInfo,
  cartInfoReceived,
  cartInfoError,
  addingToCart,
  addToCartSuccess,
  addToCartError,
  removingFromCart,
  removeFromCartSuccess,
  removeFromCartError,
  error,
}

class CartState extends Equatable {
  final CartStatus status;
  final String errorMessage;
  final String loadingMessage;
  final CartTotals cartTotals;
  final List<CartItemData> addOnCartItems;

  const CartState._({
    CartStatus status,
    String errorMessage,
    String loadingMessage,
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
  })  : status = status,
        errorMessage = errorMessage,
        loadingMessage = loadingMessage,
        cartTotals = cartTotals,
        addOnCartItems = addOnCartItems;

  CartState.initial()
      : this._(
          status: CartStatus.initial,
          errorMessage: null,
          loadingMessage: null,
          cartTotals: null,
          addOnCartItems: [],
        );

  CartState.creatingCart(String loadingMessage)
      : this._(
          status: CartStatus.creatingCart,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: null,
          addOnCartItems: [],
        );

  CartState.cartCreated()
      : this._(
          status: CartStatus.cartCreated,
          errorMessage: null,
          loadingMessage: null,
          cartTotals: null,
          addOnCartItems: [],
        );

  CartState.loadingCartInfo(
    List<CartItemData> addOnCartItems,
    String loadingMessage,
  ) : this._(
          status: CartStatus.loadingCartInfo,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: null,
          addOnCartItems: addOnCartItems,
        );

  CartState.cartInfoReceived(
    List<CartItemData> addOnCartItems,
    CartTotals cartTotals,
  ) : this._(
          status: CartStatus.cartInfoReceived,
          errorMessage: null,
          loadingMessage: null,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.cartInfoError(
    List<CartItemData> addOnCartItems,
    String errorMessage,
  ) : this._(
          status: CartStatus.cartInfoError,
          errorMessage: errorMessage,
          loadingMessage: null,
          cartTotals: null,
          addOnCartItems: addOnCartItems,
        );

  CartState.addingToCart(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String loadingMessage,
  ) : this._(
          status: CartStatus.addingToCart,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.addToCartSuccess(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String loadingMessage,
  ) : this._(
          status: CartStatus.addToCartSuccess,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.addToCartError(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String errorMessage,
  ) : this._(
          status: CartStatus.addToCartError,
          errorMessage: errorMessage,
          loadingMessage: null,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.removingFromCart(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String loadingMessage,
  ) : this._(
          status: CartStatus.removingFromCart,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.removeFromCartSuccess(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String loadingMessage,
  ) : this._(
          status: CartStatus.removeFromCartSuccess,
          errorMessage: null,
          loadingMessage: loadingMessage,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.removeFromCartError(
    CartTotals cartTotals,
    List<CartItemData> addOnCartItems,
    String errorMessage,
  ) : this._(
          status: CartStatus.removeFromCartError,
          errorMessage: errorMessage,
          loadingMessage: null,
          cartTotals: cartTotals,
          addOnCartItems: addOnCartItems,
        );

  CartState.error(String errorMessage)
      : this._(
          status: CartStatus.error,
          errorMessage: errorMessage,
          loadingMessage: null,
          cartTotals: null,
          addOnCartItems: [],
        );

  @override
  List<Object> get props => [
        status,
        errorMessage,
        loadingMessage,
        cartTotals,
        addOnCartItems,
      ];
}
