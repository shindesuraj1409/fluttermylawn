import 'dart:math';

import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/credit_card_model.dart';
import 'package:my_lawn/screens/checkout/order_processing_screen.dart';
import 'package:my_lawn/screens/checkout/widgets/order_summary_subscreen_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/payment_subscreen_widget.dart';
import 'package:my_lawn/screens/checkout/widgets/shipping_subscreen_widget.dart';
import 'package:my_lawn/screens/home/home_screen.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/complete_checkout_event.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/deeplinks_handler.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';

enum Section {
  shipping,
  payment,
  orderSummary,
  none,
}

class CheckoutScreenArguments extends Equatable {
  final String zipCode;
  final String recommendationId;
  final String customerId;
  final String cartId;
  final int subscriptionId;
  // This is when user is purchasing add-on after purchasing subx
  final AddressData existingShippingAddress;
  final CartType cartType;
  final List<String> addOnSkus;
  final SubscriptionType selectedSubscriptionType;

  CheckoutScreenArguments({
    this.zipCode,
    this.cartType,
    this.recommendationId,
    this.customerId,
    this.subscriptionId,
    this.existingShippingAddress,
    this.cartId,
    this.addOnSkus,
    this.selectedSubscriptionType,
  });

  @override
  List<Object> get props => [
        recommendationId,
        customerId,
        cartId,
        cartType,
        subscriptionId,
      ];
}

class EnabledSections extends Data {
  final bool shipping;
  final bool payment;
  final bool orderSummary;

  EnabledSections({
    this.shipping = false,
    this.payment = false,
    this.orderSummary = false,
  });

  bool isSectionEnabled(Section section) {
    switch (section) {
      case Section.shipping:
        return shipping;
      case Section.payment:
        return payment;
      case Section.orderSummary:
        return orderSummary;
      case Section.none:
        return false;
    }
    return false;
  }

  @override
  List<Object> get props => [shipping, payment, orderSummary];
}

// Empty marker class, to message that the section description was updated.
class SectionDescriptionUpdate {}

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with RouteMixin<CheckoutScreen, CheckoutScreenArguments> {
  final _sectionsBus = Bus(channels: [
    Channel(Section),
    Channel(EnabledSections),
    Channel(SectionDescriptionUpdate),
  ]);

  ThemeData _theme;

  Color _dividerColor;

  AddressData _shippingAddress;
  AddressData _disabledShippingAddressFields;
  String _recurlyToken;
  bool _isShippingDone = false;

  PaymentType _paymentType;
  CreditCardData _creditCard;
  CreditCardIssuer _creditCardIssuer;
  CreditCardValidity _creditCardValidity;
  AddressData _billingAddress;
  bool _isPaymentDone = false;

  bool _isOrderSummaryDone = false;
  String _customerId;
  String _recommendationId;
  String _cartId;
  CartType _cartType;
  String _zipCode;
  String _total;
  List<String> _addOnSkus;
  SubscriptionType _selectedSubscriptionType;
  int _subscriptionId;
  final String orderFailureMessage = '''
We’re sorry, but your order could not be completed at this time. You have not been charged. 

Our consumer services team is available to help.
  ''';

  final _keys = {
    Section.shipping: UniqueKey(),
    Section.payment: UniqueKey(),
    Section.orderSummary: UniqueKey(),
  };

  @override
  void dispose() {
    _sectionsBus.destroy();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
    _dividerColor = Color.lerp(_theme.dividerColor, _theme.disabledColor, 0.35);

    if (_cartId != routeArguments.cartId) {
      _recommendationId = routeArguments.recommendationId;
      _customerId = routeArguments.customerId;
      _zipCode = routeArguments.zipCode;
      _cartId = routeArguments.cartId;
      _subscriptionId = routeArguments.subscriptionId;
      _cartType = routeArguments.cartType;
      _addOnSkus = routeArguments.addOnSkus;
      _selectedSubscriptionType = routeArguments.selectedSubscriptionType;
      _disabledShippingAddressFields = AddressData(
        zip: _zipCode,
      );

      _shippingAddress = _cartType == CartType.addOn
          ? routeArguments.existingShippingAddress
          : // Prefill shipping address with any disabled fields for annual/season checkout flow.
          _disabledShippingAddressFields?.copyWith(
                  /* copy all */) ??
              AddressData();

      if (_cartType == CartType.addOn) {
        // If it is add "add-on" to existing subx flow
        // we disable "shipping address" section
        // and directly take user to "payment" section.
        // Plus, update their shipping address in cart.
        _isShippingDone = true;
        _updateActiveSection(Section.payment);
        registry<ShippingAddressBloc>().verifyAddress(
          _shippingAddress,
          _cartId,
        );
      } else {
        _updateActiveSection(Section.shipping);
      }
    }
  }

  void _updateActiveSection(Section section) {
    _keys.addAll({
      Section.shipping: UniqueKey(),
      Section.payment: UniqueKey(),
      Section.orderSummary: UniqueKey(),
    });
    switch (section) {
      case Section.shipping:
        _updateEnabledSections(EnabledSections(
          // This is because shipping section should be disabled for add-on carttype
          shipping: _cartType == CartType.addOn ? false : true,
          payment: _isShippingDone,
          orderSummary: _isPaymentDone,
        ));
        break;
      case Section.payment:
        _updateEnabledSections(EnabledSections(
          // This is because shipping section should be disabled for add-on carttype
          shipping: _cartType == CartType.addOn ? false : true,
          payment: true,
          orderSummary: _isPaymentDone,
        ));
        break;
      case Section.orderSummary:
        _updateEnabledSections(EnabledSections(
          // This is because shipping section should be disabled for add-on carttype
          shipping: _cartType == CartType.addOn ? false : true,
          payment: true,
          orderSummary: true,
        ));
        break;
      case Section.none:
        break;
    }
    _sectionsBus.publish<Section>(data: section);
  }

  void _updateEnabledSections(EnabledSections sections) {
    final enabledSections = _sectionsBus.snapshot<EnabledSections>();
    if (sections != enabledSections) {
      _sectionsBus.publish<EnabledSections>(data: sections);
    }
  }

  Widget _buildSectionDescription(Section section) {
    switch (section) {
      case Section.shipping:
        return Text(
          '${_shippingAddress?.address1 ?? ''}\n${_shippingAddress?.zip ?? ''}'
              .trim(),
          style: _theme.textTheme.bodyText2.copyWith(height: 1.5),
          key: Key('zip_code_label'),
        );
      case Section.payment:
        switch (_paymentType) {
          case PaymentType.googlePay:
            return Image.asset(
              'assets/icons/payment_google_pay.png',
              height: 16,
            );
          case PaymentType.applePay:
            return Image.asset(
              'assets/icons/payment_apple_pay.png',
              height: 16,
            );
          case PaymentType.payPal:
            return Image.asset(
              'assets/icons/payment_paypal.png',
              height: 16,
            );
          case PaymentType.creditCard:
            String issuerImagePath;
            var issuerImageHeight = 24.0;

            switch (_creditCardIssuer) {
              case CreditCardIssuer.americanExpress15:
                issuerImagePath = 'assets/icons/payment_amex.png';
                break;
              case CreditCardIssuer.dinersClub16:
              case CreditCardIssuer.mastercard16:
                issuerImagePath = 'assets/icons/payment_mastercard.png';
                break;
              case CreditCardIssuer.visa16:
                issuerImagePath = 'assets/icons/payment_visa.png';
                break;
              case CreditCardIssuer.unknown:
              default:
                issuerImagePath = 'assets/icons/payment.png';
                issuerImageHeight = 32;
                break;
            }

            return Row(
              children: [
                Image.asset(
                  issuerImagePath,
                  height: issuerImageHeight,
                  key: Key('credit_card_image'),
                ),
                SizedBox(width: 8),
                if (_creditCardValidity.isNumberValid)
                  Text(
                    _creditCard.number.substring(
                      max(_creditCard.number.length - 4, 0),
                    ),
                    style: _theme.textTheme.bodyText2,
                  ),
              ],
            );
          case PaymentType.none:
            break;
          case PaymentType.visa:
            // TODO: Handle this case.
            break;
          case PaymentType.mastercard:
            // TODO: Handle this case.
            break;
        }
        break;
      case Section.orderSummary:
        return Text(
          _total != null ? 'Total: \$${_total}' : '',
          style: _theme.textTheme.bodyText2,
        );
      case Section.none:
        break;
    }

    return Container();
  }

  bool _isSectionDone(Section section) {
    switch (section) {
      case Section.shipping:
        return _isShippingDone;
      case Section.payment:
        return _isPaymentDone;
      case Section.orderSummary:
        return _isOrderSummaryDone;
      default:
        return false;
    }
  }

  Widget _buildListItem({
    String title,
    Widget child,
    Section section,
  }) =>
      busStreamBuilder<Bus, EnabledSections>(
        busInstance: _sectionsBus,
        builder: (context, bus, enabledSections) => IgnorePointer(
          ignoring: !enabledSections.isSectionEnabled(section),
          child: busStreamBuilder<Bus, Section>(
            busInstance: _sectionsBus,
            builder: (context, bus, activeSection) => Theme(
              data: _theme.copyWith(
                // down arrow
                unselectedWidgetColor: enabledSections.isSectionEnabled(section)
                    ? _theme.textTheme.bodyText1.color
                    : _theme.disabledColor,
                // up arrow
                accentColor: _theme.textTheme.bodyText1.color,
                // dividers above and below
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                key: _keys[section],
                initiallyExpanded: activeSection == section,
                onExpansionChanged: (isExpanded) =>
                    _updateActiveSection(isExpanded ? section : Section.none),
                title: Text(
                  title,
                  style: _theme.textTheme.subtitle2.copyWith(
                    color: enabledSections.isSectionEnabled(section)
                        ? _theme.textTheme.bodyText1.color
                        : _theme.disabledColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: busStreamBuilder<Bus, SectionDescriptionUpdate>(
                  busInstance: _sectionsBus,
                  builder: (context, bus, sectionDescriptionUpdate) => SizedBox(
                    width: 200,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _buildSectionDescription(section),
                            ),
                          ),
                          if (_isSectionDone(section)) ...[
                            Image.asset(
                              'assets/icons/checkout_section_completed.png',
                              height: 16,
                            ),
                            SizedBox(width: 8),
                          ],
                          activeSection == section
                              ? Icon(
                                  Icons.expand_less,
                                  key: Key(title
                                          .toLowerCase()
                                          .replaceAll(RegExp(r'[^\w]'), '_') +
                                      '_expand'),
                                )
                              : Icon(
                                  Icons.expand_more,
                                  key: Key(title
                                          .toLowerCase()
                                          .replaceAll(RegExp(r'[^\w]'), '_') +
                                      '_collapse'),
                                ),
                        ]),
                  ),
                ),
                children: [
                  Divider(color: _dividerColor),
                  Container(
                    color: Styleguide.nearBackground(_theme),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildPlaceOrderButton() => Padding(
        padding: const EdgeInsets.all(24),
        child: busStreamBuilder<Bus, SectionDescriptionUpdate>(
          busInstance: _sectionsBus,
          builder: (context, bus, sectionDescriptionUpdate) => RaisedButton(
            child: Text('PLACE ORDER'),
            onPressed: _isOrderSummaryDone
                ? () async {
                    registry<AppsFlyerService>().tagEvent(CompleteCheckoutEvent(
                      cartValue: _cartId,
                      orderTotal: _total,
                    ));
                    final arguments = OrderProcessingArguments(
                      cartType: _cartType,
                      customerId: _customerId,
                      recommendationId: _recommendationId,
                      cartId: _cartId,
                      selectedSubscriptionType: _selectedSubscriptionType,
                      addOnSkus: _addOnSkus,
                      phone: _shippingAddress.phone,
                      recurlyToken: _recurlyToken,
                      subscriptionId: _subscriptionId,
                    );

                    final errorMessage = await registry<Navigation>().push(
                      '/checkout/processing',
                      arguments: arguments,
                    ) as String;

                    if (errorMessage != null && errorMessage.isNotEmpty) {
                      final theme = Theme.of(context);
                      unawaited(
                        showBottomSheetDialog(
                          context: context,
                          title: const DialogTitle(
                            title: 'Your Order Could Not Be Completed',
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  orderFailureMessage,
                                  style: theme.textTheme.subtitle2,
                                ),
                                SizedBox(height: 16),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    registry<Navigation>().push(
                                      '/home',
                                      arguments: HomeScreenArguments(
                                        HomeScreenTab.ask,
                                        '',
                                      ),
                                    );
                                  },
                                  child: Text('CONTACT CUSTOMER SERVICE'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                : null,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => BasicScaffoldWithSliverAppBar(
        titleString: 'Checkout',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildListItem(
              title: 'Shipping',
              child: busStreamBuilder<Bus, Section>(
                busInstance: _sectionsBus,
                builder: (context, bus, activeSection) => ShippingSubscreen(
                  initialShippingAddress: _shippingAddress,
                  disabledAddressFields: _disabledShippingAddressFields,
                  cart_id: _cartId,
                  onChanged: ({
                    shippingAddress,
                    isDone,
                  }) {
                    _shippingAddress = shippingAddress;
                    _isShippingDone = isDone;
                    if (isDone) {
                      _updateActiveSection(Section.payment);
                    } else {
                      _sectionsBus.publish(data: SectionDescriptionUpdate());
                    }
                  },
                ),
              ),
              section: Section.shipping,
            ),
            Divider(color: _dividerColor),
            _buildListItem(
              title: 'Payment',
              child: busStreamBuilder<Bus, Section>(
                busInstance: _sectionsBus,
                builder: (context, bus, activeSection) => PaymentSubscreen(
                  initalPaymentType: _paymentType,
                  initialCreditCard: _creditCard,
                  shippingAdress: _shippingAddress,
                  initialBillingAddress: _billingAddress,
                  cart_id: _cartId,
                  onChanged: ({
                    paymentType,
                    creditCard,
                    creditCardIssuer,
                    creditCardValidity,
                    billingAddress,
                    isDone,
                    recurlyToken,
                  }) {
                    _paymentType = paymentType;
                    _creditCard = creditCard;
                    _creditCardIssuer = creditCardIssuer;
                    _creditCardValidity = creditCardValidity;
                    _billingAddress = billingAddress;
                    _isPaymentDone = _recurlyToken != null ? true : isDone;
                    _recurlyToken = recurlyToken ?? _recurlyToken;
                    if (isDone) {
                      _updateActiveSection(Section.orderSummary);
                    } else {
                      _sectionsBus.publish(data: SectionDescriptionUpdate());
                    }
                  },
                ),
              ),
              section: Section.payment,
            ),
            Divider(color: _dividerColor),
            _buildListItem(
              title: 'Order Summary',
              child: busStreamBuilder<Bus, Section>(
                busInstance: _sectionsBus,
                builder: (context, bus, activeSection) => OrderSummarySubscreen(
                  cartId: _cartId,
                  addOnSkus: _addOnSkus,
                  selectedSubscriptionType: _selectedSubscriptionType,
                  onTermsAccepted: (didAcceptTerms, total) {
                    _total = total;
                    _isOrderSummaryDone = didAcceptTerms;
                    _sectionsBus.publish(data: SectionDescriptionUpdate());
                  },
                ),
              ),
              section: Section.orderSummary,
            ),
            // This divider is needed to overlap the border added
            // by last expansion tile of "Order Summary" section
            // otherwise it shows up as "white" divider on our gray background
            Divider(
              color: Styleguide.nearBackground(_theme),
              thickness: 3,
              height: 2,
            ),
            Expanded(
              child: Container(color: Styleguide.nearBackground(_theme)),
              flex: 1,
            ),
          ],
        ),
        bottom: busStreamBuilder<Bus, Section>(
          busInstance: _sectionsBus,
          builder: (context, bus, activeSection) =>
              activeSection == Section.orderSummary || _isOrderSummaryDone
                  ? _buildPlaceOrderButton()
                  : Container(width: 0, height: 0),
        ),
      );
}
