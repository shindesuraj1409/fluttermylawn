import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancel_subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/order_data.dart';
import 'package:my_lawn/data/refund_preview_data.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/analytic/actions/localytics/subscription_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class ShipmentCardWidget extends StatefulWidget {
  final SubscriptionData subscription;
  final SubscriptionShipment shipment;
  final List<SkippingReasons> skippingReasons;
  final List<SkippingReasons> selectedSkippingReasons;
  final Function formatDate;
  final OrderDetailsBloc orderDetailsBloc;
  final int index;
  final updateOrderDetails;

  const ShipmentCardWidget({
    Key key,
    @required this.subscription,
    @required this.shipment,
    @required this.skippingReasons,
    @required this.selectedSkippingReasons,
    @required this.formatDate,
    this.orderDetailsBloc,
    this.index,
    this.updateOrderDetails,
  }) : super(key: key);

  @override
  _ShipmentCardWidgetState createState() => _ShipmentCardWidgetState();
}

class _ShipmentCardWidgetState extends State<ShipmentCardWidget> {
  CancelSubscriptionBloc _skipBloc;

  List<SkippingReasons> skippingReasons;
  List<SkippingReasons> selectedSkippingReasons;
  OrderData order;
  int index;
  String _shipmentStatus = '';
  String _shipmentShippingStatus = 'Updating...';
  String _shipmentAction = '';
  bool _canBeSkipped = false;
  bool _canBeTracked = false;
  bool _canShowDate = false;
  String _cancelationDate = '';

  int _smallBagsQty;
  int _largeBagsQty;

  RefundData refundData;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    skippingReasons = widget.skippingReasons;
    selectedSkippingReasons = widget.selectedSkippingReasons;
    _smallBagsQty =
        getNumberOfBags(shipment: widget.shipment, isSmallBag: true);
    _largeBagsQty =
        getNumberOfBags(shipment: widget.shipment, isSmallBag: false);
    _skipBloc = registry<CancelSubscriptionBloc>();
  }

  int getNumberOfBags({SubscriptionShipment shipment, bool isSmallBag}) {
    final products = shipment.products;
    int bagCoverage;
    int bagIndex;

    for (var i = 0; i < products.length; i++) {
      if (products[i]?.coverage == null) {
        bagCoverage = bagCoverage ?? 0;
        bagIndex = bagIndex ?? i;
        break;
      }
      if (bagCoverage == null) {
        bagCoverage = products[i].coverage;
        bagIndex = i;
      }
      if (isSmallBag && products[i].coverage < bagCoverage) {
        bagCoverage = products[i].coverage;
        bagIndex = i;
      } else if (!isSmallBag && products[i].coverage > bagCoverage) {
        bagCoverage = products[i].coverage;
        bagIndex = i;
      }
    }

    if (bagCoverage == 0) {
      return 0;
    } else if (isSmallBag && bagCoverage < 6000) {
      return products[bagIndex].qty;
    } else if (!isSmallBag && bagCoverage >= 6000) {
      return products[bagIndex].qty;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        cubit: widget.orderDetailsBloc,
        builder: (context, state) {
          if (state is OrderDetailsSuccess) {
            order = state.orders[index];
            _shipmentStatus = _getShipmentStatus(order);
            _shipmentShippingStatus = _getShipmentShippingStatus(order);
            _shipmentAction = _getShipmentAction(order);
            _canBeSkipped = order.canBeSkipped;
            _canBeTracked =
                order.isShipped && order.shipments.first.trackingNumber != null;
            _canShowDate = (order.isCanceled &&
                    (order.cancellationDate != null ||
                        widget.shipment.canceledAt != null)) ||
                widget.shipment.invoiceAt != null;

            _cancelationDate =
                order.cancellationDate ?? widget.shipment.canceledAt ?? '';
          }
          if (state is OrderDetailsError) {
            _shipmentShippingStatus = 'Lost Connection';
          }

          return Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_shipmentStatus, style: textTheme.bodyText2),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _shipmentShippingStatus,
                              style: textTheme.headline3,
                            ),
                          ),
                          if (_canShowDate)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Image.asset(
                                    order.isCanceled
                                        ? 'assets/icons/shipment_skipped.png'
                                        : 'assets/icons/shipment_completed.png',
                                    width: 16,
                                    height: 16,
                                    colorBlendMode: BlendMode.srcATop,
                                    color: order.isCanceled
                                        ? theme.disabledColor
                                        : theme.primaryColor,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    order.isCanceled
                                        ? 'Canceled on ${widget.formatDate(DateTime.tryParse(_cancelationDate))}'
                                        : 'Charged on ${widget.formatDate(DateTime.tryParse(widget.shipment.invoiceAt))}',
                                    style: textTheme.bodyText2,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.shipment?.products?.first
                                      ?.thumbnailImage !=
                                  null)
                                ProductImage(
                                  productImageUrl: widget
                                      .shipment.products.first.thumbnailImage,
                                  width: 80,
                                  height: 96,
                                  fit: BoxFit.contain,
                                ),
                              SizedBox(
                                height: 96,
                                width: 40,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/bag_small.png',
                                          color: _smallBagsQty > 0
                                              ? textTheme.bodyText1.color
                                              : theme.disabledColor,
                                          colorBlendMode: BlendMode.srcATop,
                                          height: 32,
                                          key: Key('bag_image'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 1,
                                          ),
                                          child: Text(
                                            '\u00D7\u200A${_smallBagsQty > 0 ? _smallBagsQty : 0}',
                                            style: textTheme.caption.copyWith(
                                              color: 1 == 0
                                                  ? theme.disabledColor
                                                  : textTheme.bodyText1.color,
                                            ),
                                            key: Key('bag_text'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/bag_large.png',
                                          color: _largeBagsQty > 0
                                              ? textTheme.bodyText1.color
                                              : theme.disabledColor,
                                          colorBlendMode: BlendMode.srcATop,
                                          height: 48,
                                          key: Key('large_bag_image'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 2,
                                          ),
                                          child: Text(
                                            '\u00D7\u200A${_largeBagsQty > 0 ? _largeBagsQty : 0}',
                                            style: textTheme.caption.copyWith(
                                              color: 2 == 0
                                                  ? theme.disabledColor
                                                  : textTheme.bodyText1.color,
                                            ),
                                            key: Key('large_bag_text'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      child: Text(
                        _shipmentAction,
                        style: textTheme.button
                            .copyWith(color: theme.primaryColor),
                      ),
                      onTap: _canBeSkipped
                          ? () => _bottomSheetDialog(context, theme)
                          : () => registry<Navigation>().push(
                                _canBeTracked
                                    ? '/profile/subscription/track'
                                    : null,
                                arguments: {
                                  'title': 'Track Shipment',
                                  'url':
                                      'https://www.fedex.com/apps/fedextrack/?action=track&tracknumbers=${order.shipments.first.trackingNumber}&locale=en_US&cntry_code=us',
                                },
                              ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${widget.shipment.products.first.productName ?? widget.shipment.products.first.thumbnailLabel ?? ''}',
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2
                          .copyWith(height: 1.5, letterSpacing: 0),
                      key: Key('product_name'),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future _bottomSheetDialog(BuildContext context, ThemeData theme) {
    return showBottomSheetDialog(
      context: context,
      hasDivider: true,
      isFullScreen: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Text(
          'Why do you wish to skip?',
          style: theme.textTheme.subtitle1.copyWith(
            color: Styleguide.color_gray_9,
            height: 1.5,
          ),
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: GestureDetector(
          onTap: () {
            selectedSkippingReasons.clear();
            Navigator.of(context).pop();
          },
          child: SizedBox(
            height: 32,
            width: 48,
            child: Center(
              child: Text(
                'CANCEL',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Styleguide.color_green_4, height: 1.67),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter modalState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: List<Widget>.generate(
                        skippingReasons.length,
                        (int index) {
                          return Row(
                            children: [
                              CircularCheckBox(
                                key: Key('skip_reasons_checkbox_'+(index+1).toString()),
                                value: selectedSkippingReasons
                                    .contains(skippingReasons[index]),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                onChanged: (bool value) {
                                  modalState(
                                    () {
                                      if (value) {
                                        selectedSkippingReasons
                                            .add(skippingReasons[index]);
                                      } else {
                                        selectedSkippingReasons
                                            .remove(skippingReasons[index]);
                                      }
                                    },
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () => modalState(
                                  () {
                                    if (!selectedSkippingReasons
                                        .contains(skippingReasons[index])) {
                                      selectedSkippingReasons
                                          .add(skippingReasons[index]);
                                    } else {
                                      selectedSkippingReasons
                                          .remove(skippingReasons[index]);
                                    }
                                  },
                                ),
                                child: Text(
                                  skippingReasons[index].reason,
                                  style: theme.textTheme.bodyText2.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 13.0, bottom: 32, left: 8, right: 8),
              child: Container(
                height: 52,
                child: BlocListener<CancelSubscriptionBloc,
                    CancelSubscriptionState>(
                  cubit: _skipBloc,
                  listenWhen: (previous, current) =>
                      previous is CancelSubscriptionStateLoading &&
                      current is CancelSubscriptionStateSuccess,
                  listener: (context, state) {
                    if (_skipBloc.state is CancelSubscriptionStateSuccess) {
                      Navigator.of(context).pop();
                      _showShipmentSkippedModal(context, theme);
                    }
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: RaisedButton(
                      child: Text('SUBMIT'),
                      onPressed: () async {
                        unawaited(registry<LocalyticsService>()
                            .tagEvent(SkipShipmentEvent()));

                        await _skipBloc
                            .add(PreviewSubscriptionRefundEvent(order.orderId));
                        Navigator.of(context).pop();
                        await _showShipmentSkippedModal(context, theme);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShipmentStatus(OrderData order) => order.isDelivered
      ? 'DELIVERED'
      : order.isShipped
          ? 'SHIPPED'
          : !order.isShipped &&
                  DateTime.parse(order.shippingEndDate).isBefore(DateTime.now())
              ? 'PAST SHIPMENT'
              : !order.isShipped &&
                      DateTime.now()
                              .difference(
                                  DateTime.parse(order.shippingStartDate))
                              .inDays <
                          31
                  ? 'NEXT SHIPMENT'
                  : order.isCanceled || order.isSkipped
                      ? 'CANCELED'
                      : 'UPCOMING';

  String _getShipmentShippingStatus(OrderData order) => order.isDelivered
      ? ''
      : order.isCanceled || order.isSkipped
          ? 'Shipment Skipped'
          : order.isShipped && order.shippingStartDate != null
              ? DateFormat('E MMM. d')
                  .format(DateTime.parse(order.shippingStartDate))
              : !order.isShipped && order.shippingStartDate != null
                  ? 'Est. ${DateFormat('MMM. d').format(DateTime.parse(order.shippingStartDate))}'
                  : 'Not Scheduled';

  String _getShipmentAction(OrderData order) =>
      order.isShipped && order.shipments.first.trackingNumber != null
          ? 'TRACK PACKAGE'
          : order.canBeSkipped
              ? 'SKIP SHIPMENT'
              : '';

  Future<dynamic> _showShipmentSkippedModal(
      BuildContext context, ThemeData theme) {
    return showBottomSheetDialog(
      context: context,
      hasDivider: false,
      isFullScreen: false,
      trailingPositioned: Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: Image.asset(
            'assets/icons/cancel.png',
            key: Key('cancel_button'),
            height: 24,
            width: 24,
            color: Styleguide.color_gray_9,
          ),
          onTap: () {
            widget.updateOrderDetails();
            return registry<Navigation>().pop();
          },
        ),
      ),
      child: BlocConsumer<CancelSubscriptionBloc, CancelSubscriptionState>(
        cubit: _skipBloc,
        listener: (context, state) {
          if (state is PreviewSubscriptionStateSuccess) {
            refundData = state.refundData;
            _skipBloc.add(CancelSubscriptionEvent(order.orderId));
          }
          if (state is CancelSubscriptionStateSuccess) {
            final customerId =
                registry<AuthenticationBloc>().state.user.customerId;
            registry<SubscriptionBloc>().add(FindSubscription(customerId));
          }
        },
        builder: (context, state) {
          if (state is CancelSubscriptionStateSuccess) {
            return ShipmentSkippedStatusWidget(
              widget: widget,
              theme: theme,
              padding: const EdgeInsets.fromLTRB(24, 41, 24, 89),
              image: 'assets/icons/order_completed.png',
              headline: 'Shipment Skipped!',
              subtitle: widget.subscription.subscriptionType.isAnnual
                  ? 'Your refund of \$${refundData.estimatedRefund} will appear in your original payment method within 7 days.'
                  : 'You won’t be billed for this shipment.',
            );
          }
          if (state is CancelSubscriptionStateError) {
            return ShipmentSkippedStatusWidget(
              widget: widget,
              theme: theme,
              padding: const EdgeInsets.fromLTRB(24, 41, 24, 89),
              image: 'assets/icons/question.png',
              headline: 'Error',
              subtitle: 'Please, try again later',
            );
          }
          return ShipmentSkippedStatusWidget(
            widget: widget,
            theme: theme,
            padding: const EdgeInsets.fromLTRB(24, 41, 24, 95),
            image: 'assets/icons/order_processing.png',
            headline: 'Processing',
          );
        },
      ),
    );
  }
}

class ShipmentSkippedStatusWidget extends StatelessWidget {
  const ShipmentSkippedStatusWidget({
    Key key,
    @required this.widget,
    @required this.theme,
    @required this.padding,
    this.image,
    this.headline,
    this.subtitle,
  }) : super(key: key);

  final ShipmentCardWidget widget;
  final ThemeData theme;
  final EdgeInsets padding;
  final String image;
  final String headline;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 64,
                width: 64,
                key: Key('skip_shipment_check_image'),
              ),
            ],
          ),
          SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(headline, style: theme.textTheme.headline2),
            ],
          ),
          SizedBox(height: 19),
          if (subtitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    subtitle,
                    style: theme.textTheme.subtitle2.copyWith(height: 1.43),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    key: Key('shipment_skipped_subtitle'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
