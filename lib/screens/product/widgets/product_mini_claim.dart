import 'package:flutter/material.dart';
import 'package:my_lawn/data/product/product_data.dart';

class MiniClaims extends StatelessWidget {
  const MiniClaims({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      //only if it has mini claims display the padding
      padding: ((product.miniClaim1 != null && product.miniClaim1.isNotEmpty) ||
              (product.miniClaim2 != null && product.miniClaim2.isNotEmpty) ||
              (product.miniClaim3 != null && product.miniClaim3.isNotEmpty))
          ? EdgeInsets.only(top: 14)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (product.miniClaim1 != null && product.miniClaim1.isNotEmpty)
            MiniClaim(text: product.miniClaim1, icon: product.miniClaimImage1),
          if (product.miniClaim2 != null && product.miniClaim2.isNotEmpty)
            MiniClaim(text: product.miniClaim2, icon: product.miniClaimImage2),
          if (product.miniClaim3 != null && product.miniClaim3.isNotEmpty)
            MiniClaim(text: product.miniClaim3, icon: product.miniClaimImage3),
        ],
      ),
    );
  }
}

class MiniClaim extends StatelessWidget {
  const MiniClaim({
    Key key,
    String text,
    String icon,
  })  : text = text,
        icon = icon,
        super(key: key);

  final String text;
  final String icon;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: Image.network(
                icon,
                width: 24,
                frameBuilder: (
                  BuildContext context,
                  Widget child,
                  int frame,
                  bool wasSynchronouslyLoaded,
                ) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    child: child,
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 24,
                ),
              )),
          Container(
            child: Text(
              text,
              style: _theme.textTheme.bodyText1
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
