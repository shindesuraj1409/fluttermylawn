import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String productImageUrl;
  final double width, height;
  final BoxFit fit;

  ProductImage({
    @required this.productImageUrl,
    @required this.width,
    @required this.height,
    BoxFit fit = BoxFit.contain,
    Key key,
  })  : fit = fit,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      width: width,
      height: height,
      placeholder: 'assets/images/product_placeholder.png',
      image: productImageUrl ?? '',
      imageErrorBuilder: (_, __, ___) {
        return Image.asset(
          'assets/images/product_placeholder.png',
          width: width,
          height: height,
          key: Key('product_image'),
          fit: fit,
        );
      },
      fit: fit,
      key: Key('product_image'),
    );
  }
}
