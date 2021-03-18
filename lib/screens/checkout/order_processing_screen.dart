import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/checkout/order/order_bloc.dart';
import 'package:my_lawn/blocs/checkout/order/order_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/checkout/order_confirmation_screen.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:navigation/navigation.dart';

class OrderProcessingArguments extends Equatable {
  final String recommendationId;
  final String customerId;
  final String cartId;
  final int subscriptionId;
  final List<String> addOnSkus;
  final SubscriptionType selectedSubscriptionType;
  final CartType cartType;
  final String phone;
  final String recurlyToken;

  OrderProcessingArguments({
    this.cartType,
    this.recommendationId,
    this.customerId,
    this.cartId,
    this.addOnSkus,
    this.selectedSubscriptionType,
    this.phone,
    this.recurlyToken,
    this.subscriptionId,
  });

  @override
  List<Object> get props => [
        recommendationId,
        customerId,
        cartId,
        addOnSkus,
        selectedSubscriptionType,
        phone,
        recurlyToken,
        subscriptionId,
      ];
}

class OrderProcessingScreen extends StatefulWidget {
  @override
  _OrderProcessingScreenState createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen>
    with RouteMixin<OrderProcessingScreen, OrderProcessingArguments> {
  OrderProcessingArguments _arguments;
  OrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<OrderBloc>();

    registry<AdobeRepository>().trackAppState(
      OrderProcessingScreenAdobeState(),
    );
  }

  void placeOrder() {
    _bloc.createOrder(
      _arguments.recommendationId,
      _arguments.customerId,
      _arguments.cartId,
      _arguments.cartType,
      _arguments.addOnSkus,
      _arguments.selectedSubscriptionType,
      _arguments.phone,
      _arguments.recurlyToken,
      _arguments.subscriptionId,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_arguments == null || _arguments != routeArguments) {
      _arguments = routeArguments;
      placeOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<OrderBloc, OrderState>(
      cubit: _bloc,
      builder: (context, state) {
        return BasicScaffold(
          allowBackNavigation: false,
          backgroundColor: theme.primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ProgressSpinner(
                      size: 128,
                      strokeWidth: 16,
                      color: Styleguide.color_gray_0.withAlpha(0x40),
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Styleguide.color_gray_0,
                      child: Image.asset(
                        'assets/icons/order_processing.png',
                        height: 100,
                        key: Key('order_processing_image'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'HANG TIGHT',
                  style: theme.textTheme.bodyText2.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: Text(
                  'Processing Your Order',
                  style: theme.textTheme.headline1.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is OrderSuccessState) {
          final arguments = OrderConfirmationArguments(
            orderId: state.orderId,
            customerId: _arguments.customerId,
          );
          registry<Navigation>().setRoot(
            '/checkout/confirmation',
            arguments: arguments,
          );
        } else if (state is OrderFailureState) {
          registry<Navigation>().pop<String>(state.errorMessage);
        }
      },
    );
  }
}
