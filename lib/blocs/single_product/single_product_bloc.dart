import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/services/single_product/single_product_service_impl.dart';
import 'package:pedantic/pedantic.dart';

part 'single_product_event.dart';
part 'single_product_state.dart';

class SingleProductBloc extends Bloc<SingleProductEvent, SingleProductState> {
  final SingleProductService _service;
  SingleProductBloc(this._service) : super(SingleProductInitial());

  @override
  Stream<SingleProductState> mapEventToState(
    SingleProductEvent event,
  ) async* {
    if (event is SingleProductLoad) {
      yield SingleProductLoading();
      try {
        final productWithSku = await _service.getProductSku(variables: {
          'category': event.category,
          'code': event.productId,
        });
        final product = await _service.getProduct(product: productWithSku);

        yield SingleProductSuccess(
          product: product,
          title: product.name,
        );
      } catch (exception) {
        yield SingleProductError();
        unawaited(
          FirebaseCrashlytics.instance
              .recordError(exception, StackTrace.current),
        );
      }
    }
    if (event is SingleProductOpened) {
      yield SingleProductInitial();
    }
  }
}
