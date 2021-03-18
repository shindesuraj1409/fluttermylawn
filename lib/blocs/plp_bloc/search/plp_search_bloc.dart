import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_event.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class PlpSearchBloc extends Bloc<PlpSearchEvent, PlpSearchState> {
  PlpSearchBloc({ProductsService productsService})
      : productsService = productsService ?? registry<ProductsService>(),
        super(PlpSearchInitialState());

  final ProductsService productsService;
  List<Product> productList;

  @override
  Stream<Transition<PlpSearchEvent, PlpSearchState>> transformEvents(
    Stream<PlpSearchEvent> events,
    TransitionFunction<PlpSearchEvent, PlpSearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 800)),
      transitionFn,
    );
  }

  @override
  Stream<PlpSearchState> mapEventToState(PlpSearchEvent event) async* {
    try {
      if (event is PlpSearchInitialEvent) {
        productList = event.productList;
        yield PlpSearchInitializedState();
      }
      if (event is PlpSearchUpdateEvent) {
        final searchString = event.searchString;
        if (searchString.length < 3) return;
        if (productList != null) {
          yield PlpSearchUpdatedState(
              productList: productList
                  .where((element) => element.name
                      .contains(RegExp('$searchString', caseSensitive: false)))
                  .toList());
        } else {
          yield PlpSearchLoadingState();
          final productList =
              await productsService.searchProducts(event.searchString);
          yield PlpSearchUpdatedState(productList: productList);
        }
      }
    } on FormatException catch (exception) {
      exception;
      yield PlpSearchUpdatedState(productList: []);
    } catch (exception) {
      yield PlpSearchErrorState(
          errorMessage: 'Something went wrong. Please try again');
      unawaited(FirebaseCrashlytics.instance.recordError(
        exception,
        StackTrace.current,
      ));
    }
  }

  @override
  Future<void> close() {
    productList = null;
    return super.close();
  }
}
