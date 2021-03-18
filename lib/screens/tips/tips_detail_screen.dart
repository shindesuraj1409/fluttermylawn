import 'package:flutter/material.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/tips/contentful_rich.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_widget_config.dart';
import 'package:my_lawn/screens/tips/widgets/recommended_product_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class TipsDetailScreen extends StatefulWidget {
  const TipsDetailScreen({Key key}) : super(key: key);

  @override
  _TipsDetailScreenState createState() => _TipsDetailScreenState();
}

class _TipsDetailScreenState extends State<TipsDetailScreen>
    with RouteMixin<TipsDetailScreen, TipsArticleData> {
  TipsArticleData tips;

  @override
  void initState() {
    super.initState();
    tips = TipsArticleData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      tips = routeArguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      childFillsRemainingSpace: true,
      titleString: tips.title,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tips.shortDescription,
                  style: theme.textTheme.subtitle2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      if (tips.readTime != null)
                        Text('${tips.readTime} min Read',
                            style: theme.textTheme.bodyText1)
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!tips.isVideoArticle)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Image.network(
                tips.image,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 256,
              ),
            ),
          ContentfulRichText(tips.contentfulPage,
                  options: contentfulOptions(context, tips.assets))
              .documentToWidgetTree,
          if (tips.recommendedProduct != null)
            RecommendedProduct(
              recommendedProduct: tips.recommendedProduct,
            )
        ],
      ),
    );
  }
}
