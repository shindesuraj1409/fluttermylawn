import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/subscription/widgets/product_bags_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/action.dart';
import 'package:my_lawn/widgets/product_image.dart';

class AddonsCarousel extends StatelessWidget {
  final List<Product> addOnProducts;
  final List<String> cartItemSkus;
  final CartBloc bloc;

  AddonsCarousel({
    this.addOnProducts,
    this.cartItemSkus,
    this.bloc,
  });

  void sendAdobeAnalytic(Product product) {
    registry<AdobeRepository>().trackAppActions(
      AddToCartAdobeAnalyticAction(
        product: registry<AdobeRepository>().buildSingleProductString(
          product,
          parentSku: true,
          sku: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: addOnProducts.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final addOnProduct = addOnProducts[index];
          final addedToCart =
              cartItemSkus.contains(addOnProduct.childProducts.first.sku);
          return SizedBox(
            width: 240,
            child: Card(
              key: Key('addons_card_$index'),
              margin: EdgeInsets.only(right: 16, bottom: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProductImage(
                          productImageUrl:
                              addOnProduct.childProducts.first.imageUrl,
                          width: 104,
                          height: 104,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            height: 40,
                            child: OutlineButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(addedToCart ? 'REMOVE' : 'ADD TO CART'),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    addedToCart
                                        ? 'assets/icons/remove.png'
                                        : 'assets/icons/add.png',
                                    height: 16,
                                    width: 16,
                                    key: Key(
                                      addedToCart
                                          ? 'remove_image'
                                          : 'add_image',
                                    ),
                                  ),
                                ],
                              ),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                if (addedToCart) {
                                  bloc.removeFromCart(
                                    addOnProduct,
                                    bloc.cartId,
                                  );
                                } else {
                                  sendAdobeAnalytic(addOnProduct);

                                  bloc.addToCart(
                                    addOnProduct,
                                    bloc.cartId,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Text(
                          addOnProduct.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headline6.copyWith(
                            height: 1.43,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              '\$${addOnProduct.bundlePrice.toStringAsFixed(2)}',
                              style: theme.textTheme.headline5.copyWith(
                                color: theme.colorScheme.primary,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ProductBags(
                        product: addOnProduct,
                        showVertical: false,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
