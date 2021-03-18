import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/screens/subscription/widgets/product_bags_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';

class CarouselSection extends StatelessWidget {
  final List<Product> products;
  CarouselSection(this.products);

  @override
  Widget build(BuildContext context) {
    final topMargin = 16.0;
    final bottomMargin = 32.0;
    final cardSpacing = 12.0;

    return SizedBox(
      height: 216.0 + topMargin + bottomMargin,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 144,
            child: Card(
              margin: EdgeInsets.fromLTRB(
                0,
                topMargin,
                cardSpacing,
                bottomMargin,
              ),
              child: _ProductCard(products[index]),
              key: Key('carousal_product_el_' + index.toString()),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  _ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImage(
                productImageUrl: product.childProducts.first.imageUrl,
                height: 84,
                width: 56,
              ),
              ProductBags(product: product),
            ],
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              product.applicationWindow.season.toUpperCase(),
              style: theme.textTheme.caption.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Styleguide.color_green_2,
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
          margin: const EdgeInsets.only(top: 12, bottom: 8),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyText2.copyWith(height: 1.5),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              '\$${product.bundlePrice.toStringAsFixed(2)}',
              style: theme.textTheme.subtitle2.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
              key: Key('carousal_product_price'),
            ),
          ),
        )
      ],
    );
  }
}
