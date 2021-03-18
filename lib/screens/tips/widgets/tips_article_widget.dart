import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/tips/widgets/tips_footer.dart';
import 'package:my_lawn/services/analytic/actions/localytics/article_events.dart';
import 'package:my_lawn/services/analytic/screen_state_action/tips_screen/state.dart';
import 'package:navigation/navigation.dart';

class TipsListElement extends StatelessWidget {
  final TipsArticleData tipsListModel;

  TipsListElement({this.tipsListModel});

  void onPressed(bool result) {
    registry<Logger>().d('[TipsListElement] => <onPressed> => result $result');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        registry<AdobeRepository>().trackAppState(
            ArticleScreenAdobeState(articleTitle: tipsListModel.title));

        tagTipEvent(tipsListModel);
        registry<Navigation>().push('/tips/detail', arguments: tipsListModel);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Styleguide.color_gray_2,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 83,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            tipsListModel.type[0].toUpperCase(),
                            style: theme.bodyText2
                                .copyWith(color: Styleguide.color_gray_9),
                          ),
                        ),
                        Text(
                          tipsListModel.title,
                          style: theme.headline5.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    TipsFooter(
                      readTime: tipsListModel.readTime,
                      onPressed: onPressed,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              width: 125.0,
              height: 83.0,
              color: Styleguide.color_gray_2,
              child: tipsListModel.image != null
                  ? Image.network(
                      tipsListModel.image,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/grass_background.png'),
            ),
          ],
        ),
      ),
    );
  }
}
