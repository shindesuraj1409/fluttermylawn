import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class CheckoutButton extends StatelessWidget {
  final CartState state;
  final Function checkout;
  final bool disabled;

  const CheckoutButton({
    @required this.state,
    @required this.checkout,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
            blurRadius: 5.0,
            spreadRadius: -1.0,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
          BoxShadow(
            color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
            blurRadius: 18.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              1.0,
            ),
          ),
          BoxShadow(
            color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              6.0,
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: RaisedButton(
                child: Text(
                  state.status == CartStatus.addingToCart
                      ? 'ADDING TO CART'
                      : state.status == CartStatus.removingFromCart
                          ? 'REMOVING FROM CART...'
                          : 'CHECKOUT',
                ),
                onPressed: disabled ||
                        (state.status == CartStatus.addingToCart ||
                            state.status == CartStatus.removingFromCart ||
                            state.status == CartStatus.creatingCart ||
                            state.status == CartStatus.error)
                    ? null
                    : checkout,
              ),
            ),
            if (state.status == CartStatus.addingToCart ||
                state.status == CartStatus.removingFromCart)
              Positioned(
                top: 16,
                right: 12,
                child: ProgressSpinner(
                  size: 20,
                ),
              )
          ],
        ),
      ),
    );
  }
}
