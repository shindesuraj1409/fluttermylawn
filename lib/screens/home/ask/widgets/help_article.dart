import 'package:flutter/material.dart';
import 'package:my_lawn/data/help_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/tips/contentful_rich.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_widget_config.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class HelpArticleScreen extends StatefulWidget {
  const HelpArticleScreen({Key key}) : super(key: key);

  @override
  _HelpArticleScreenState createState() => _HelpArticleScreenState();
}

class _HelpArticleScreenState extends State<HelpArticleScreen>
    with RouteMixin<HelpArticleScreen, HelpData> {
  HelpData article;

  @override
  void initState() {
    super.initState();
    article = HelpData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      article = routeArguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      childFillsRemainingSpace: true,
      titleString: article.title,
      child: Column(
        children: <Widget>[
          ContentfulRichText(article.content,
                  options: contentfulOptions(context, article.assets))
              .documentToWidgetTree,
        ],
      ),
    );
  }
}
