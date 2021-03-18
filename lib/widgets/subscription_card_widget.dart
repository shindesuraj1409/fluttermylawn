import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/widgets/product_image.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/widgets/bag_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/ribbon_widget.dart';
import 'package:url_launcher/url_launcher.dart';

enum SubscriptionCardStatus { Active, Applied, Skipped, Missed, Future }

class SubscriptionCard extends StatefulWidget {
  final Product product;
  final int id;
  final bool isCollapsed;
  final Function(bool) onArchivedTapped;
  final Function(bool) onAppliedTapped;
  final Function(bool) onSkippedTapped;
  final Function(bool) onBuyNowTapped;
  SubscriptionCard({
    key,
    this.id,
    this.onArchivedTapped,
    this.onAppliedTapped,
    this.onSkippedTapped,
    this.onBuyNowTapped,
    this.product,
    this.isCollapsed,
  }) : super(key: key);

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  bool shipmentSkipped;
  bool isSubscribed;
  bool addedByMe;
  bool applied;
  bool skipped;
  Product product;
  Color backgroundColor;
  Color accentColor;
  SubscriptionCardStatus status;
  DateTime startDate;
  DateTime endDate;
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isCollapsed;
    shipmentSkipped = widget.product.skipped;
    isSubscribed = widget.product.isSubscribed;
    applied = widget.product.applied;
    skipped = widget.product.skipped;
    addedByMe = widget.product.isAddedByMe;
    backgroundColor = widget.product.childProducts.first.color != null
        ? widget.product.childProducts.first.color.withOpacity(0.08)
        : Styleguide.color_green_4.withOpacity(0.08);
    accentColor =
        widget.product.childProducts.first.color ?? Styleguide.color_green_4;
    status = getTimeframe(widget.product.applicationWindow.startDate,
        widget.product.applicationWindow.endDate);
    startDate = widget.product.applicationWindow.startDate;
    endDate = widget.product.applicationWindow.endDate;
  }

  ThemeData _theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    product = widget.product;
    // Modified = state where card was acted on, which means it was either applied or skipped.
    final modified = applied || skipped;

    return Container(
      key: Key(product.name),
      margin: EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: modified ? _buildModifiedMainRow() : _buildCurrentCard(),
            ),
          ),
          modified
              ? Container()
              : Positioned(
                  bottom: _expanded ? 7 : 4,
                  right: 4,
                  child: BaseButton(
                    borderRadius: BorderRadius.circular(8),
                    color: accentColor,
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Styleguide.color_gray_0,
                      size: 24,
                      key: Key(
                          _expanded ? 'sub_card_collapse' : 'sub_card_expand'),
                    ),
                  ),
                ),
          // Added by me
          addedByMe && !modified
              ? Positioned(
                  top: 0,
                  right: 12,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            'Added by me',
                            style: _theme.textTheme.bodyText2
                                .copyWith(fontSize: 11),
                          ),
                        ),
                        Ribbon(color: accentColor),
                      ],
                    ),
                  ),
                )
              : Container(),
          if (!modified)
            Positioned(top: 8, left: 18, child: _buildStatusIcon()),
        ],
      ),
    );
  }

  SubscriptionCardStatus getTimeframe(DateTime startDate, DateTime endDate) {
    SubscriptionCardStatus status;
    final today = DateTime.now();

    // Past
    if (endDate != null && today.isAfter(endDate)) {
      status = SubscriptionCardStatus.Missed;
    }
    // Present
    else if (today.isAfter(startDate) &&
        (endDate == null || today.isBefore(endDate))) {
      status = SubscriptionCardStatus.Active;
    }
    // Future
    else if (today.isBefore(startDate)) {
      status = SubscriptionCardStatus.Future;
    }
    return status;
  }

  Widget _buildStatusIcon(
      {EdgeInsets margin = const EdgeInsets.only(bottom: 4)}) {
    String iconName;

    if (applied) {
      iconName = 'applied';
    } else if (skipped) {
      iconName = 'skipped';
    } else if (shipmentSkipped) {
      iconName = 'shipment_skipped';
    } else if (status == SubscriptionCardStatus.Missed) {
      iconName = 'missed';
    } else if (status == SubscriptionCardStatus.Active) {
      iconName = 'active';
    } else if (status == SubscriptionCardStatus.Future) {
      iconName = '';
    } else {
      return Icon(
        Icons.warning,
        size: 16,
      );
    }

    return iconName.isNotEmpty
        ? Container(
            margin: margin,
            child: Image(
              image: AssetImage('assets/icons/subscription-card/$iconName.png'),
              width: 16,
              key: Key('check_image'),
            ),
          )
        : Container();
  }

  /*
    Modified Main Row does not have an expandable detail row. 
    It does have an archive button that dismisses it.
    It can either one of two icons: applied or skipped.
  */
  Widget _buildModifiedMainRow() {
    final decisionDate = product.completedDate;
    final pastFormat = DateFormat('MMM. dd');

    Widget _buildDate() {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 4, color: accentColor),
          ),
        ),
        width: 48,
        child: Column(
          children: <Widget>[
            decisionDate == null
                ? _buildStatusIcon(margin: EdgeInsets.symmetric(vertical: 4))
                : _buildStatusIcon(),
            if (decisionDate != null)
              Text(
                '${pastFormat.format(decisionDate)}',
                style: _theme.textTheme.bodyText2.copyWith(fontSize: 10),
              ),
          ],
        ),
      );
    }

    Widget _buildProductImage() {
      return Container(
        width: 24,
        child: ProductImage(
          productImageUrl: product.childProducts.first.imageUrl,
          width: 24,
          height: 32,
        ),
      );
    }

    Widget _buildDescription() {
      return Flexible(
        child: Container(
          padding: EdgeInsets.fromLTRB(9, 0, 12, 0),
          child: Text(
            product.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    //this is being hidden temporarily until there is backend support for this

    // Widget _buildArchiveText() {
    //   return Container(
    //     padding: EdgeInsets.only(right: 16),
    //     child: TappableText(
    //       child: Text('ARCHIVE', style: _theme.textTheme.bodyText1),
    //       onTap: () {
    //         widget.onArchivedTapped(true);
    //       },
    //     ),
    //   );
    // }

    return GestureDetector(
      onTap: () => goToProductDetails(),
      child: Container(
        color: backgroundColor,
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          children: <Widget>[
            _buildDate(),
            _buildProductImage(),
            _buildDescription(),
            //TODO: this is being hidden temporarily until there is backend support for this
            //_buildArchiveText(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainRow() {
    Widget _buildApplyText() {
      return status == SubscriptionCardStatus.Active ||
              status == SubscriptionCardStatus.Future
          ? Text(
              'Apply',
              style: _theme.textTheme.bodyText2.copyWith(
                fontSize: 10,
                height: 1.3636,
              ),
            )
          : Container();
    }

    Widget _buildDates() {
      final dayFormat = DateFormat('dd');
      final monthFormat = DateFormat('MMM');

      final line = Container(
        margin: EdgeInsets.only(top: 6),
        color: Styleguide.color_gray_9,
        height: 4,
        width: 2,
      );

      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 4, color: accentColor),
          ),
        ),
        width: 48,
        child: Column(
          children: <Widget>[
            _buildApplyText(),
            Text(
              '${dayFormat.format(startDate)}',
              style: _theme.textTheme.headline4.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.22,
              ),
              key: Key('sub_card_apply_from_date'),
            ),
            Text(
              '${monthFormat.format(startDate)}',
              style: _theme.textTheme.bodyText2.copyWith(
                fontSize: 10,
                height: 1.0,
              ),
              key: Key('sub_card_apply_from_month'),
            ),
            if (endDate != null) line,
            if (endDate != null)
              Text(
                '${dayFormat.format(endDate)}',
                style: _theme.textTheme.headline4.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.22,
                ),
                key: Key('sub_card_apply_to_date'),
              ),
            if (endDate != null)
              Text(
                '${monthFormat.format(endDate)}',
                style: _theme.textTheme.bodyText2.copyWith(
                  fontSize: 10,
                  height: 1.0,
                ),
                key: Key('sub_card_apply_to_month'),
              ),
          ],
        ),
      );
    }

    Widget _buildProductImage() {
      return GestureDetector(
        onTap: () => goToProductDetails(),
        child: ProductImage(
          productImageUrl: product.childProducts.first.imageUrl,
          width: 48,
          height: 72,
          key: Key('sub_card_product_image'),
        ),
      );
    }

    Widget _buildDescription() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TappableText(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Text(
                product.name ?? '',
                style: _theme.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.22,
                ),
                key: Key('sub_card_product_name'),
              ),
              onTap: () => goToProductDetails(),
            ),
            Container(
              child: TappableText(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'VIEW DETAILS',
                  style: _theme.textTheme.button.copyWith(
                    color: _theme.primaryColor,
                    height: 1.66,
                  ),
                ),
                onTap: () => registry<Navigation>()
                    .push('/product/detail', arguments: product),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 24, 0, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildDates(),
          _buildProductImage(),
          Expanded(
            child: _buildDescription(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow() {
    Widget _buildUnsubscribedDetailRow() {
      Widget _buildQuantity() {
        return Container(
          margin: EdgeInsets.only(left: 8, bottom: 18),
          width: 98,
          child: Row(
            mainAxisAlignment: product.childProducts.length > 1
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  if (product.childProducts.length > 1)
                    Bag(
                      bagSize: BagSize.Small,
                      quantity: product.childProducts.first.quantity,
                      text: NumberFormat.compact().format(
                              product.childProducts.first.coverageArea) +
                          ' sqft',
                    ),
                ],
                key: Key('bag_details_small'),
              ),
              Column(
                children: <Widget>[
                  if (product.childProducts.last.coverageArea != null)
                    Bag(
                      bagSize: BagSize.Large,
                      quantity: product.childProducts.last.quantity,
                      text: NumberFormat.compact()
                              .format(product.childProducts.last.coverageArea) +
                          ' sqft',
                    ),
                ],
                key: Key('bag_details_big'),
              ),
            ],
          ),
        );
      }

      Widget _buildDescription() {
        Widget _bullet(String text, String icon) => Container(
              child: Row(
                children: <Widget>[
                  if (icon.isNotEmpty)
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
                        child: Image.network(
                          icon,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 24,
                          ),
                        )),
                  Container(
                    child: Text(text),
                  ),
                ],
              ),
            );

        return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _bullet(product.childProducts.first.miniClaim1,
                  product.childProducts.first.miniClaimImage1),
              _bullet(product.childProducts.first.miniClaim2,
                  product.childProducts.first.miniClaimImage2),
              _bullet(product.childProducts.first.miniClaim3,
                  product.childProducts.first.miniClaimImage3),
            ],
          ),
        );
      }

      return _expanded
          ? Container(
              color: backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _buildQuantity(),
                  Expanded(child: _buildDescription()),
                ],
              ),
            )
          : Container();
    }

    Widget _buildSubscribedDetailRow() {
      final line = Container(
        color: Styleguide.color_gray_2,
        height: 30,
        width: 1,
      );

      Widget _buildLabel() {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
          width: 44,
          child: Text(
            'Apply When',
            style: _theme.textTheme.bodyText2.copyWith(
              fontSize: 11,
              height: 1.3636,
            ),
          ),
        );
      }

      Widget _buildDescription() {
        final style = TextStyle(
          color: Styleguide.color_gray_9,
          fontFamily: 'ProximaNova',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
        );

        return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      if (product.childProducts.first.lawnCondition != null &&
                          product.childProducts.first.lawnCondition != 'null')
                        if (product.childProducts.first.lawnCondition
                            .substring(
                                1,
                                product.childProducts.first.lawnCondition
                                        .length -
                                    1)
                            .isNotEmpty)
                          _applyWhenBullet(
                            text: Text('Lawn is ' +
                                product.childProducts.first.lawnCondition
                                    .substring(
                                        1,
                                        product.childProducts.first
                                                .lawnCondition.length -
                                            1)),
                          ),
                      if (product.childProducts.first.minTemp != null)
                        _applyWhenBullet(
                          text: Text(
                              'Temp is ${product.childProducts.first.minTemp}-${product.childProducts.first.maxTemp}F'),
                        ),
                      if (product.childProducts.first.afterSeed != null)
                        _applyWhenBullet(
                          text: Text(
                              'After your ${product.childProducts.first.afterSeed}${int.tryParse(product.childProducts.first.afterSeed) == 1 ? "st" : "th"} mow for newly seeded or sodded areas'),
                        ),
                    ],
                  )),
              if (product.childProducts.first.youtubeUrl != null)
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(
                        product.childProducts.first.youtubeUrl)) {
                      await launch(product.childProducts.first.youtubeUrl);
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'WATCH VIDEO ',
                      style: style.copyWith(
                        color: Styleguide.color_green_4,
                        fontWeight: FontWeight.w700,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Styleguide.color_green_4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      return _expanded
          ? Container(
              color: backgroundColor,
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildLabel(),
                  line,
                  Expanded(child: _buildDescription()),
                ],
              ),
            )
          : Container();
    }

    return (isSubscribed || addedByMe) &&
            status == SubscriptionCardStatus.Active
        ? _buildSubscribedDetailRow()
        : _buildUnsubscribedDetailRow();
  }

  Widget _buildActionRow() {
    Widget _buildSubscribedActionRow() {
      final line = Container(
        color: Styleguide.color_gray_2,
        height: 24,
        width: 1,
      );

      Widget _action(String text, {Function onTap}) {
        return Center(
          child: TappableText(
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              style: _theme.textTheme.bodyText1.copyWith(height: 1.66),
            ),
            onTap: onTap,
          ),
        );
      }

      return _expanded
          ? Container(
              decoration: BoxDecoration(
                color: _theme.colorScheme.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: status == SubscriptionCardStatus.Active
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: _action(
                            'SKIPPED',
                            onTap: () {
                              widget.onSkippedTapped(true);
                            },
                          ),
                        ),
                        line,
                        Expanded(
                          child: _action(
                            'APPLIED',
                            onTap: () {
                              widget.onAppliedTapped(true);
                            },
                          ),
                        ),
                      ],
                    )
                  : _action(''),
            )
          : Container();
    }

    Widget _buildUnsubscribedActionRow() {
      Widget _action(String text, {Function onTap}) {
        return Center(
          child: TappableText(
            padding: EdgeInsets.all(10),
            child: Text(
              text,
              style: _theme.textTheme.bodyText1.copyWith(height: 1.66),
            ),
            onTap: onTap,
          ),
        );
      }

      return _expanded
          ? Container(
              decoration: BoxDecoration(
                color: _theme.colorScheme.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _action(''),
                  ),
                ],
              ),
            )
          : Container();
    }

    return isSubscribed
        ? _buildSubscribedActionRow()
        : _buildUnsubscribedActionRow();
  }

  Widget _buildCurrentCard() {
    return Column(
      children: <Widget>[
        _buildMainRow(),
        _buildDetailRow(),
        status == SubscriptionCardStatus.Missed
            ? Container()
            : _buildActionRow(),
      ],
    );
  }

  void goToProductDetails() {
    registry<Navigation>().push('/product/detail', arguments: product);
  }
}

class _applyWhenBullet extends StatelessWidget {
  final Text text;
  const _applyWhenBullet({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Image.asset(
            'assets/icons/bullet_point.png',
            height: 12,
          ),
        ),
        SizedBox(
          width: 4.5,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: text,
          ),
        )
      ],
    );
  }
}
