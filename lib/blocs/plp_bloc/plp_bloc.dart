import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_event.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:pedantic/pedantic.dart';

class PlpBloc extends Bloc<PlpEvent, PlpState> {
  PlpBloc({ProductsService productsService, SessionManager sessionManager})
      : productsService = productsService ?? registry<ProductsService>(),
        sessionManager = sessionManager ?? registry<SessionManager>(),
        super(PlpInitialState());

  final ProductsService productsService;
  final SessionManager sessionManager;
  List<Product> productList;
  ProductCategory category;

  @override
  Stream<PlpState> mapEventToState(event) async* {
    try {
      if (event is PlpInitialLoadEvent) {
        category = event.category;
        yield PlpLoadingState();
        List<Product> products;
        final filters = <ProductFilterBlockData>[];

        filters.add(ProductFilterBlockData(
          id: category.type,
          filterOptionList: [ProductFilterOption(id: category.title)],
        ));

        final _lawnData = await sessionManager.getLawnData();

        if (_lawnData?.grassType != LawnData.unknownGrassType) {
          final grassTypeFilter = ProductFilterBlockData(
              id: productFilterGrassTypes,
              filterOptionList: [
                ProductFilterOption(
                    id: _lawnData.grassTypeName, name: _lawnData.grassTypeName)
              ]);
          filters.add(grassTypeFilter);
        }
        products = await productsService.filterProducts(filters);

        yield PlpLoadedState(
          inititalFilters: filters,
          productList: products,
          category: category,
        );
      }
      if (event is PlpApplyFilterEvent) {
        final filters = event.appliedFilters;
        final list = event.productList;
        yield PlpLoadedState(
          inititalFilters: filters,
          productList: list,
          category: category,
        );
      }
      if (event is PlpClearFilterEvent) {
        add(PlpInitialLoadEvent(category: category));
      }
    } catch (e) {
      yield PlpErrorState(
          errorMessage: 'Something went wrong. Please try again');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
