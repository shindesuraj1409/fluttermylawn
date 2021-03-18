import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/order_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/subscription/order_details/order_details_service.dart';
import 'package:pedantic/pedantic.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDetailsService _service;

  OrderDetailsBloc(this._service)
      : assert(_service != null,
            'OrderDetailsService is required to use OrderDetailsBloc'),
        super(OrderDetailsInitial());

  @override
  Stream<OrderDetailsState> mapEventToState(
    OrderDetailsEvent event,
  ) async* {
    if (event is GetOrderDetails) {
      try {
        yield OrderDetailsLoading();

        if (event.shipments.isEmpty) {
          throw Exception();
        }

        final orders = await Future.wait(event.shipments
            .map((shipment) => _service.getOrder(shipment.orderId)));

        yield OrderDetailsSuccess(orders: orders);
      } catch (exception) {
        yield OrderDetailsError();
        unawaited(FirebaseCrashlytics.instance
            .recordError(exception, StackTrace.current));
      }
    }
  }
}
