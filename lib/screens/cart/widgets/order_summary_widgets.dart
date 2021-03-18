import 'package:flutter/material.dart';

import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';

class OrderSummaryCard extends StatelessWidget {
  final CartState state;
  final Function retryRequest;
  final Function checkout;

  OrderSummaryCard({
    this.state,
    this.retryRequest,
    this.checkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headline6.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.43,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Builder(
        builder: (BuildContext context) {
          switch (state.status) {
            case CartStatus.loadingCartInfo:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: LoadingContainer(state.loadingMessage),
                  ),
                ],
              );
            case CartStatus.cartInfoReceived:
            case CartStatus.addingToCart:
            case CartStatus.removingFromCart:
            case CartStatus.addToCartSuccess:
            case CartStatus.addToCartError:
            case CartStatus.removeFromCartSuccess:
            case CartStatus.removeFromCartError:
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CartItemList(
                      cartItems: state.cartTotals.cartItems,
                      discountAmount: state.cartTotals.discountAmount,
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 8),
                    _TotalRow(
                      label: 'Subtotal',
                      price: '\$${state.cartTotals.subtotalWithDiscount}',
                      textStyle: textStyle,
                    ),
                    SizedBox(height: 8),
                    _TotalRow(
                      label: 'Shipping',
                      price: state.cartTotals.shippingAmount == 0
                          ? 'FREE'
                          : '\$${state.cartTotals.shippingAmount}',
                      textStyle: textStyle,
                    ),
                  ],
                ),
              );
            case CartStatus.cartInfoError:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: ErrorMessage(
                      errorMessage: state.errorMessage,
                      retryRequest: retryRequest,
                    ),
                  ),
                ],
              );
            default:
              throw UnimplementedError(
                  'Incorrect state reached in Order Summary Card : ${state}');
          }
        },
      ),
    );
  }
}

class _CartItemList extends StatefulWidget {
  final List<CartItemData> cartItems;
  final double discountAmount;
  _CartItemList({
    this.cartItems,
    this.discountAmount,
  });

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<_CartItemList> {
  bool _showList = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headline6.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.43,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Summary', style: textStyle),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showList = !_showList;
                });
              },
              child: Row(
                children: [
                  Text(
                    _showList ? 'VIEW LESS' : 'VIEW ALL',
                    style: theme.textTheme.bodyText1.copyWith(
                      height: 1.67,
                      color: Styleguide.color_green_6,
                      fontWeight: FontWeight.bold,
                    ),
                    key: Key(_showList ? 'view_less' : 'view_all'),
                  ),
                  SizedBox(width: 8),
                  Image.asset(_showList
                      ? 'assets/icons/up.png'
                      : 'assets/icons/down.png'),
                ],
              ),
            ),
          ],
        ),
        if (_showList)
          ListView.builder(
            itemCount: widget.discountAmount < 0
                ? widget.cartItems.length + 1
                : widget.cartItems.length,
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (widget.discountAmount < 0 &&
                  index == widget.cartItems.length) {
                return _CartItem(
                  key: Key('annual promo code'),
                  productName: 'Promo Code: Annual Discount',
                  quantity: 0,
                  price: '-\$${widget.discountAmount.abs().toStringAsFixed(2)}',
                );
              }
              final cartItem = widget.cartItems[index];
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
          ),
      ],
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
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String price;
  final TextStyle textStyle;

  _TotalRow({
    Key key,
    this.label,
    this.price,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Text(
          price,
          style: textStyle,
        ),
      ],
    );
  }
}
