import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/models/theme_model.dart';
import 'package:my_lawn/widgets/badge_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';

class CollapsedCard extends StatelessWidget {
  const CollapsedCard({
    Key key,
    @required this.color,
    @required this.imageUrl,
    @required this.startDate,
    @required this.endDate,
    @required this.itemName,
    @required this.itemPrice,
    this.isNew = false,
  })  : assert(color != null, 'Color should\'t be null'),
        assert(imageUrl != null, 'imageUrl should\'t be null'),
        assert(startDate != null, 'startDate should\'t be null'),
        assert(endDate != null, 'endDate should\'t be null'),
        assert(itemName != null, 'itemName should\'t be null'),
        assert(itemPrice != null, 'itemPrice should\'t be null'),
        super(key: key);

  final Color color;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String itemName;
  final String itemPrice;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final theme = busSnapshot<ThemeModel, ThemeData>();
    final formatter = DateFormat('MMM');
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: 128,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(width: 0.1),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 90,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 4, color: color),
                        ),
                      ),
                      width: 44,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Apply',
                            style: theme.textTheme.caption.copyWith(
                                height: 1.36,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.8)),
                          ),
                          DayWidget(date: startDate, theme: theme),
                          MonthWidget(
                              formatter: formatter,
                              date: startDate,
                              theme: theme),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            color: Styleguide.color_gray_9.withOpacity(0.64),
                            height: 4,
                            width: 2,
                          ),
                          DayWidget(date: endDate, theme: theme),
                          MonthWidget(
                              formatter: formatter,
                              date: endDate,
                              theme: theme),
                        ],
                      ),
                    ),
                    ProductImage(
                      productImageUrl: imageUrl,
                      width: 50,
                      height: 70,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              itemName,
                              style: theme.textTheme.headline5,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              child: Text(
                                itemPrice,
                                style: theme.textTheme.bodyText1.copyWith(
                                  color: theme.primaryColor,
                                  height: 1.67,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isNew)
            Positioned(
              top: 8,
              right: 8,
              child: Badge(
                text: 'NEW',
                color: Styleguide.color_green_1,
                margin: EdgeInsets.all(5),
                size: BadgeSize.Small,
              ),
            )
        ],
      ),
    );
  }
}

class MonthWidget extends StatelessWidget {
  const MonthWidget({
    Key key,
    @required this.formatter,
    @required this.date,
    @required this.theme,
  }) : super(key: key);

  final DateFormat formatter;
  final DateTime date;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatter.format(date),
      style: theme.textTheme.caption.copyWith(
          fontSize: 10.0,
          color: theme.colorScheme.onBackground.withOpacity(0.8)),
    );
  }
}

class DayWidget extends StatelessWidget {
  const DayWidget({
    Key key,
    @required this.date,
    @required this.theme,
  }) : super(key: key);

  final DateTime date;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(date.day.toString(),
        style: theme.textTheme.headline4.copyWith(
            letterSpacing: 0,
            color: theme.colorScheme.onBackground.withOpacity(0.8)));
  }
}
