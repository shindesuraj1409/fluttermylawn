import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/screens/product/widgets/product_badge.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      color: Styleguide.color_gray_0,
      child: Column(
        children: [
          Container(
            color: product.color != null
                ? product.color.withOpacity(0.08)
                : Styleguide.color_green_4.withOpacity(0.08),
            height: 256,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 31),
                  padding: const EdgeInsets.only(left: 16),
                  height: 56,
                  width: 76,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/guarantee.png',
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(height: 2),
                      GestureDetector(
                        key: Key('no_quibble_guarantee'),
                        child: Text(
                          'Scotts\nNo-Quibble Guarantee',
                          style: _theme.textTheme.bodyText1
                              .copyWith(fontSize: 10, height: 1.4),
                        ),
                        onTap: () => showBottomSheetDialog(
                            context: context,
                            title: Text(
                              'Scotts No-Quibble Guarantee',
                              style: _theme.textTheme.headline2,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 14),
                                  Text(
                                    'If for any reason you, the consumer, are not satisfied after using this product, you are entitled to get your money back. Simply send us evidence of purchase and we will mail you a refund check promptly.',
                                    style: _theme.textTheme.bodyText2
                                        .copyWith(height: 1.22),
                                  ),
                                  SizedBox(height: 40),
                                  FullTextButton(
                                    key: Key('got_it_of_no_quibble_guarantee'),
                                    text: 'GOT IT!',
                                    color: _theme.colorScheme.primary,
                                    border: Border.all(
                                      color: _theme.colorScheme.primary,
                                      width: 1,
                                    ),
                                    onTap: () => Navigator.of(context).pop(),
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 31),
                      height: 185,
                      width: 185,
                      child: ProductImage(
                        height: 185,
                        width: 185,
                        productImageUrl: product.imageUrl,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 76,
                ),
              ],
            ),
          ),
          ProductBadge(product: product),
        ],
      ),
    );
  }
}
