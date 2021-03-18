import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/cart/widgets/order_summary_widgets.dart';
import 'package:my_lawn/screens/checkout/checkout_screen.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/state.dart';
import 'package:my_lawn/widgets/addons_carousel.dart';
import 'package:my_lawn/widgets/checkout_button.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({
    Key key,
    this.addons,
    this.subscriptionData,
    @required ValueNotifier<double> widgetHeight,
    @required this.addToCart,
  }) : super(key: key);
  final List<Product> addons;
  final SubscriptionData subscriptionData;
  final Function addToCart;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  CartBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<CartBloc>();
    registry<AdobeRepository>().trackAppState(YourCartScreenAdobeState());
    _retryRequest();
  }

  void _retryGetCartTotals() {
    _bloc.getCartTotals(_bloc.cartId, widget.subscriptionData.subscriptionType);
  }

  void _retryRequest() {
    _bloc.createCart(
      registry<AuthenticationBloc>().state.user.customerId,
      registry<AuthenticationBloc>().state.user.recommendationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      cubit: _bloc,
      listener: (context, state) {
        switch (state.status) {
          case CartStatus.cartCreated:
            _bloc.getCartTotals(
              _bloc.cartId,
              widget.subscriptionData.subscriptionType,
            );
            break;
          case CartStatus.addToCartSuccess:
          case CartStatus.removeFromCartSuccess:
            showSnackbar(
                context: context,
                text: state.loadingMessage,
                duration: Duration(seconds: 2));
            break;
          case CartStatus.addToCartError:
          case CartStatus.removeFromCartError:
            showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2));
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        final addOnCartItems = state.addOnCartItems;
        final cartItemSkus =
            addOnCartItems.map((cartItem) => cartItem.sku).toList();
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.colorScheme.primary,
          body: CustomScrollView(
            slivers: [
              Builder(
                builder: (BuildContext context) {
                  switch (state.status) {
                    case CartStatus.initial:
                    case CartStatus.creatingCart:
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: LoadingContainer(
                          state.loadingMessage,
                          onPrimaryBackground: true,
                        ),
                      );
                    case CartStatus.error:
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: ErrorMessage(
                          errorMessage: state.errorMessage,
                          retryRequest: _retryRequest,
                          onPrimaryBackground: true,
                        ),
                      );
                    default:
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, top: 6, bottom: 24),
                              child: Text(
                                'You will be charged at the time of the first shipment',
                                textAlign: TextAlign.start,
                                style: theme.textTheme.bodyText2.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            AddonsCarousel(
                              bloc: _bloc,
                              cartItemSkus: cartItemSkus,
                              addOnProducts: widget.addons,
                            ),
                            _isCartReady(state)
                                ? Container(
                                    color: theme.colorScheme.background,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 24,
                                    ),
                                    child: OrderSummaryCard(
                                      state: state,
                                      retryRequest: _retryGetCartTotals,
                                      checkout: _proceedToCheckout,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      );
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CheckoutButton(
              state: state,
              checkout: _proceedToCheckout,
              disabled: !areAddOnItemsInCart(state),
            ),
          ),
        );
      },
    );
  }

  void _proceedToCheckout() async {
    final lawnData = await registry<AuthenticationBloc>().state.lawnData;
    final zipCode = lawnData?.lawnAddress?.zip ?? '';

    final arguments = CheckoutScreenArguments(
      customerId: registry<AuthenticationBloc>().state.user.customerId,
      recommendationId:
          registry<AuthenticationBloc>().state.user.recommendationId,
      cartId: _bloc.cartId,
      cartType: _bloc.cartType,
      subscriptionId: widget.subscriptionData.id,
      existingShippingAddress: widget.subscriptionData.shippingAddress,
      addOnSkus: _bloc.state.addOnCartItems
          .map((addOnCartItem) => addOnCartItem.sku)
          .toList(),
      zipCode: zipCode,
    );

    unawaited(registry<Navigation>().push(
      '/checkout',
      arguments: arguments,
    ));
  }

  bool _isCartReady(CartState state) {
    return areAddOnItemsInCart(state) &&
        (state.status == CartStatus.cartCreated ||
            state.status == CartStatus.loadingCartInfo ||
            state.status == CartStatus.cartInfoReceived ||
            state.status == CartStatus.cartInfoError ||
            state.status == CartStatus.addingToCart ||
            state.status == CartStatus.removingFromCart ||
            state.status == CartStatus.addToCartSuccess ||
            state.status == CartStatus.addToCartError ||
            state.status == CartStatus.removeFromCartSuccess ||
            state.status == CartStatus.removeFromCartError);
  }

  bool areAddOnItemsInCart(CartState state) =>
      state.addOnCartItems != null && state.addOnCartItems.isNotEmpty;
}
