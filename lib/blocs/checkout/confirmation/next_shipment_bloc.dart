import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/confirmation_screen/state.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_exception.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:pedantic/pedantic.dart';

part 'next_shipment_event.dart';
part 'next_shipment_state.dart';

const errorMessage = "We're sorry! We're unable to get Shipment details";

class NextShipmentBloc extends Bloc<NextShipmentEvent, NextShipmentState> {
  final FindSubscriptionsByCustomerIdService service;
  final AdobeRepository adobeRepository;
  NextShipmentBloc({@required this.service, this.adobeRepository})
      : assert(service != null,
            'FindSubscriptionsByCustomerIdService is required to get shipments'),
        super(NextShipmentInitial());

  @override
  Stream<NextShipmentState> mapEventToState(
    NextShipmentEvent event,
  ) async* {
    if (event is NextShipmentEvent) {
      try {
        yield NextShipmentLoading();

        final subscriptions =
            await service.findSubscriptionsByCustomerId(event.customerId);

        // Get "shipments" list from latest subscription
        final shipments = subscriptions.last.shipments;

        // Get first "Subscription Products" shipment
        // and shipmentDate
        final firstSubscriptionShipment =
            shipments.firstWhere((shipment) => shipment.planCode != 'add-ons');
        final firstShipmentDate =
            firstSubscriptionShipment.products.first.shippingStartDate;

        // Get "Add-on Products" shipment
        final addOnShipment = shipments.firstWhere(
            (shipment) => shipment.planCode == 'add-ons',
            orElse: () => null);

        // See if there is "Add-on Products" shipment contains any
        // product with shipping date before or same as first
        // "Subscription Products" shipment
        final addOnProductsInFirstShipment = addOnShipment?.products
                ?.where((product) =>
                    product.shippingStartDate.isBefore(
                      firstShipmentDate,
                    ) ||
                    product.shippingStartDate
                            .difference(firstShipmentDate)
                            .inDays ==
                        0)
                ?.toList() ??
            [];

        final shipmentProducts = [
          ...firstSubscriptionShipment.products,
          ...addOnProductsInFirstShipment
        ];

        adobeRepository.trackAppState(ConfirmationScreenAdobeState(
          products: adobeRepository.buildProductsFromShipmentProductString(
            shipmentProducts,
          ),
          purchaseId: subscriptions.first.orderId,
          //TODO: what is purchase mean?
          purchase: '1',
        ));

        yield NextShipmentSuccess(
          products: shipmentProducts,
          firstShipmentDate: firstShipmentDate,
        );
      } on FindSubscriptionByCustomerIdException catch (exception) {
        yield NextShipmentError(errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      } catch (exception) {
        yield NextShipmentError(errorMessage);
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
  }
}
