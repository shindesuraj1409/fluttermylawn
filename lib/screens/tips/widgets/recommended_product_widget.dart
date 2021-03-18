import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendedProduct extends StatelessWidget {
  final RecommendedProductData recommendedProduct;

  const RecommendedProduct({Key key, this.recommendedProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 264,
        width: 328,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Image.network(
                    recommendedProduct.image,
                    height: 166,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        recommendedProduct.description,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FullTextButton(
              backgroundColor: Styleguide.color_orange_2,
              onTap: () async {
                if (await canLaunch(recommendedProduct.url)) {
                  await launch(recommendedProduct.url);
                }
              },
              text: 'BUY NOW',
              color: Styleguide.color_gray_0,
            ),
          ],
        ),
      ),
    );
  }
}
