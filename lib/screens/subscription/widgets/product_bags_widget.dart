import 'package:flutter/material.dart';
import 'package:my_lawn/data/product/product_data.dart';

class ProductBags extends StatelessWidget {
  final Product product;
  final bool showVertical;
  ProductBags({
    this.product,
    this.showVertical = true,
  });

  List<Widget> _buildBags(int noOfChildProducts, ThemeData theme) {
    final bags = <Widget>[];
    for (var i = 0; i < noOfChildProducts; i++) {
      bags.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              product.childProducts[i].coverageArea <= 5000
                  ? 'assets/icons/bag_small.png'
                  : 'assets/icons/bag_large.png',
              color: theme.colorScheme.onBackground,
              height: product.childProducts[i].coverageArea <= 5000 ? 32 : 40,
              key: Key('bag_image_$i'),
            ),
            Text(
              '\u00D7\u200A${product.childProducts[i].quantity}',
              style: theme.textTheme.subtitle2.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
              key: Key('bag_text_$i'),
            ),
          ],
        ),
      ));
    }

    return bags;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noOfChildProducts = product.childProducts.length;

    return showVertical
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildBags(noOfChildProducts, theme))
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildBags(noOfChildProducts, theme),
          );
  }
}
