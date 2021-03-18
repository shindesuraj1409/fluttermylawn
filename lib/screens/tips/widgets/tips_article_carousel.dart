import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/screens/tips/widgets/tips_footer.dart';
import 'package:my_lawn/screens/tips/widgets/gradient_text.dart';
import 'package:my_lawn/services/analytic/actions/localytics/article_events.dart';
import 'package:navigation/navigation.dart';

class TipsCarouselWidget extends StatelessWidget {
  final List<TipsArticleData> tipsCarouselData;

  const TipsCarouselWidget({Key key, this.tipsCarouselData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: tipsCarouselData.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == tipsCarouselData.length) {
            return Container(
              width: 100.0,
            );
          }
          return CarouselSlide(
            tipsCardModel: tipsCarouselData[index],
            tipsDataIndex: index,
          );
        },
      ),
    );
  }
}

class CarouselSlide extends StatelessWidget {
  final TipsArticleData tipsCardModel;
  final tipsDataIndex;

  CarouselSlide({this.tipsCardModel, this.tipsDataIndex});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 296.0,
      margin: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(
              0,
              2,
            ),
            spreadRadius: -2,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          tagTipEvent(tipsCardModel);
          registry<Navigation>().push('/tips/detail', arguments: tipsCardModel);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            width: 240.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              key: Key('lawn_tips_carousel_card_${tipsDataIndex}'),
              children: <Widget>[
                Container(
                  height: 137.0,
                  width: 240.0,
                  color: Styleguide.color_gray_2,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Hero(
                    tag: hashCode,
                    child: tipsCardModel.image != null
                        ? Image.network(tipsCardModel.image,
                            fit: BoxFit.cover,
                            key: Key(
                                'lawn_tips_carousel_card_image_${tipsDataIndex}'))
                        : Image.asset('assets/images/grass_background.png'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tipsCardModel.type[0],
                        style: textTheme.bodyText2,
                        key: Key(
                            'lawn_tips_carousel_tips_type_${tipsDataIndex}'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          tipsCardModel.title,
                          style: textTheme.headline5,
                          key: Key(
                              'lawn_tips_carousel_card_title_${tipsDataIndex}'),
                        ),
                      ),
                      GradientText(
                        tipsCardModel.shortDescription * 2,
                        style: textTheme.bodyText2.copyWith(
                          color: Styleguide.color_gray_0,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 3,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: TipsFooter(
                    readTime: tipsCardModel.readTime,
                    margin: EdgeInsets.only(left: 8, right: 16, bottom: 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
