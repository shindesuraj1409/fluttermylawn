import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/cart/widgets/addon_products_section_widgets.dart';
import 'package:my_lawn/screens/cart/widgets/order_summary_widgets.dart';
import 'package:my_lawn/widgets/checkout_button.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/screens/cart/widgets/subscription_products_section_widgets.dart';
import 'package:my_lawn/screens/checkout/checkout_screen.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/state.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class CartScreenArguments extends Equatable {
  final String customerId;
  final String recommendationId;
  final Plan plan;
  final SubscriptionType selectedSubscriptionType;
  final bool isModification;
  final bool isAddon;
  CartScreenArguments({
    @required this.customerId,
    @required this.recommendationId,
    @required this.plan,
    @required this.selectedSubscriptionType,
    this.isModification = false,
    this.isAddon = false,
  });

  @override
  List<Object> get props => [
        recommendationId,
        plan,
        selectedSubscriptionType,
        isModification,
        isAddon,
      ];
}

class CartScreen extends StatefulWidget {
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with RouteMixin<CartScreen, CartScreenArguments> {
  Plan _plan;
  SubscriptionType _selectedSubscriptionType;
  String _recommendationId;
  String _customerId;

  CartBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<CartBloc>();

    registry<AdobeRepository>().trackAppState(YourCartScreenAdobeState());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedSubscriptionType == null ||
        _selectedSubscriptionType != routeArguments.selectedSubscriptionType) {
      _plan = routeArguments.plan;
      _selectedSubscriptionType = routeArguments.selectedSubscriptionType;
      _recommendationId = routeArguments.recommendationId;
      _customerId = routeArguments.customerId;

      _bloc.createCart(
        _customerId,
        _recommendationId,
        _selectedSubscriptionType,
      );
    }
  }

  void _retryRequest() {
    _bloc.createCart(
      _customerId,
      _recommendationId,
      _selectedSubscriptionType,
    );
  }

  void _retryGetCartTotals() {
    _bloc.getCartTotals(_bloc.cartId, _selectedSubscriptionType);
  }

  void _proceedToCheckout() async {
    final lawnData = await registry<AuthenticationBloc>().state.lawnData;
    final zipCode = lawnData?.lawnAddress?.zip ?? '';

    final arguments = CheckoutScreenArguments(
      customerId: _customerId,
      cartType: _bloc.cartType,
      recommendationId: _recommendationId,
      cartId: _bloc.cartId,
      selectedSubscriptionType: _selectedSubscriptionType,
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      cubit: _bloc,
      listener: (context, state) {
        switch (state.status) {
          case CartStatus.cartCreated:
            _bloc.getCartTotals(
              _bloc.cartId,
              _selectedSubscriptionType,
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
        return BasicScaffoldWithSliverAppBar(
          titleString: 'Your Cart',
          slivers: [
            Builder(
              builder: (BuildContext context) {
                switch (state.status) {
                  case CartStatus.initial:
                  case CartStatus.creatingCart:
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: LoadingContainer(state.loadingMessage),
                    );
                  case CartStatus.error:
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: ErrorMessage(
                        errorMessage: state.errorMessage,
                        retryRequest: _retryRequest,
                      ),
                    );
                  default:
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SubscriptionProductBundle(
                            plan: _plan,
                            selectedSubscriptionType: _selectedSubscriptionType,
                          ),
                          _plan.addOnProducts != null &&
                                  _plan.addOnProducts.isNotEmpty
                              ? AddonsSection(
                                  cartBloc: _bloc,
                                  addOnCartItems: state.addOnCartItems,
                                  addOnProducts: _plan.addOnProducts,
                                  selectedSubscriptionType:
                                      _selectedSubscriptionType,
                                )
                              : SizedBox(),
                          _isCartReady(state)
                              ? OrderSummaryCard(
                                  state: state,
                                  retryRequest: _retryGetCartTotals,
                                  checkout: _proceedToCheckout,
                                )
                              : SizedBox()
                        ],
                      ),
                    );
                }
              },
            ),
          ],
          bottom: CheckoutButton(
            state: state,
            checkout: _proceedToCheckout,
          ),
        );
      },
    );
  }

  bool _isCartReady(CartState state) {
    return state.status == CartStatus.cartCreated ||
        state.status == CartStatus.loadingCartInfo ||
        state.status == CartStatus.cartInfoReceived ||
        state.status == CartStatus.cartInfoError ||
        state.status == CartStatus.addingToCart ||
        state.status == CartStatus.removingFromCart ||
        state.status == CartStatus.addToCartSuccess ||
        state.status == CartStatus.addToCartError ||
        state.status == CartStatus.removeFromCartSuccess ||
        state.status == CartStatus.removeFromCartError;
  }
}
