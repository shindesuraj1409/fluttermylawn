import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_bloc.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class OrderSummarySubscreen extends StatefulWidget {
  final Function(
    bool didAcceptTerms,
    String total,
  ) onTermsAccepted;
  final List<String> addOnSkus;
  final SubscriptionType selectedSubscriptionType;
  final String cartId;

  OrderSummarySubscreen({
    this.onTermsAccepted,
    this.addOnSkus,
    this.selectedSubscriptionType,
    this.cartId,
  });

  @override
  _OrderSummarySubscreenState createState() => _OrderSummarySubscreenState();
}

class _OrderSummarySubscreenState extends State<OrderSummarySubscreen> {
  OrderSummaryBloc _bloc;
  ThemeData _theme;
  List<String> _addOnSkus;
  SubscriptionType _selectedSubscriptionType;
  String _cartId;
  String _total;

  var _didCheckConfirmation = false;

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    _addOnSkus = widget.addOnSkus;
    _selectedSubscriptionType = widget.selectedSubscriptionType;
    _cartId = widget.cartId;

    super.didChangeDependencies();
    _bloc = registry<OrderSummaryBloc>();
    _bloc.getOrderSummary(
      _cartId,
      _selectedSubscriptionType,
      _addOnSkus,
    );
  }

  void _retryRequest() {
    _bloc.getOrderSummary(
      _cartId,
      _selectedSubscriptionType,
      _addOnSkus,
    );
  }

  Widget _buildLineItem({String title, double amount, bool isBold = false}) {
    final style = (amount < 0
            ? _theme.textTheme.subtitle2.copyWith(color: _theme.primaryColor)
            : _theme.textTheme.subtitle2)
        .copyWith(fontWeight: isBold ? FontWeight.w600 : FontWeight.w400);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Text(title, style: style)),
          Text(
            amount == 0
                ? 'FREE'
                : amount < 0
                    ? '-\$${amount.abs().toStringAsFixed(2)}'
                    : '\$${amount.toStringAsFixed(2)}',
            style: style,
            key: Key(
                title.removeNonCharsMakeLowerCaseMethod(identifier: '_value')),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalDivider() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Divider(color: _theme.disabledColor.withAlpha(0x80)),
      );

  Widget _buildConfirmationCheckbox() {
    const annualText =
        'By checking this box you confirm that your subscription will '
        'automatically renew on an annual basis and you will continue '
        'to receive new shipments as outlined in your Scotts Program '
        'Lawn Plan unless you tell us to stop and your credit card on '
        'file will be automatically charged for your entire plan as '
        'outlined in your account on the date of renewal. You will be '
        'notified by email at the address provided between 30-60 days '
        'days prior to each charge. You may cancel your subscription '
        'at any time through our website program.scotts.com. To avoid '
        'the next charge you must cancel your subscription by the date '
        'indicated in the notice.';

    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 32,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            visualDensity: VisualDensity.compact,
            value: _didCheckConfirmation,
            onChanged: (value) {
              setState(
                () => _didCheckConfirmation = value,
              );
              widget.onTermsAccepted?.call(
                value,
                _total,
              );
            },
            key: Key('order_summary_checkbox'),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(annualText),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderSummaryBloc, OrderSummaryState>(
      cubit: _bloc,
      builder: (context, state) {
        return Builder(
          builder: (BuildContext context) {
            if (state is OrderSummaryFailure) {
              return Center(
                child: ErrorMessage(
                  errorMessage: state.errorMessage,
                  retryRequest: _retryRequest,
                ),
              );
            } else if (state is OrderSummarySuccessState) {
              _total = state.cartTotals.grand_total.toString();
              widget.onTermsAccepted?.call(
                _didCheckConfirmation,
                _total,
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: state.cartTotals.discountAmount < 0
                          ? (state.cartTotals.cartItems.length + 1) * 32.0
                          : state.cartTotals.cartItems.length * 32.0,
                      padding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
                      child: CartSubscriptionListItems(
                        key: Key('Subscription'),
                        cartTotals: state.cartTotals,
                      ),
                    ),
                    _buildHorizontalDivider(),
                    _buildLineItem(
                      title: 'Subtotal',
                      amount: state.cartTotals.subtotalWithDiscount,
                      isBold: true,
                    ),
                    _buildLineItem(
                      title: 'Shipping',
                      amount: 0,
                      isBold: true,
                    ),
                    _buildLineItem(
                      title: 'Tax',
                      amount: state.cartTotals.taxAmount,
                      isBold: true,
                    ),
                    _buildHorizontalDivider(),
                    _buildLineItem(
                      title: 'Total',
                      amount: state.cartTotals.base_grand_total,
                      isBold: true,
                    ),
                    _buildConfirmationCheckbox(),
                  ],
                ),
              );
            } else {
              return Container(
                width: double.infinity,
                color: Styleguide.nearBackground(Theme.of(context)),
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: LoadingContainer('Loading Summary'),
              );
            }
          },
        );
      },
      listener: (context, state) {},
    );
  }
}

class CartSubscriptionListItems extends StatelessWidget {
  final CartTotals cartTotals;
  CartSubscriptionListItems({
    this.cartTotals,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartTotals.discountAmount < 0
          ? cartTotals.cartItems.length + 1
          : cartTotals.cartItems.length,
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
      ),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        if (cartTotals.discountAmount < 0 &&
            index == cartTotals.cartItems.length) {
          return _CartItem(
            key: Key('annual promo code'),
            productName: 'Promo Code: Annual Discount',
            quantity: 0,
            price: '-\$${cartTotals.discountAmount.abs().toStringAsFixed(2)}',
          );
        }
        final cartItem = cartTotals.cartItems[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _CartItem(
            key: Key(cartItem.id.toString()),
            productName: cartItem.name,
            quantity: cartItem.qty,
            price: '\$${cartItem.rowTotal.toStringAsFixed(2)}',
          ),
        );
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  final String productName;
  final int quantity;
  final String price;

  final bagColor = Styleguide.color_green_4.withOpacity(0.1);

  _CartItem({
    this.productName,
    this.quantity,
    this.price,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            productName,
            style: theme.textTheme.subtitle2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$price',
          style: theme.textTheme.subtitle2,
          key: Key(productName.removeNonCharsMakeLowerCaseMethod(
              identifier: '_value')),
        ),
      ],
    );
  }
}
