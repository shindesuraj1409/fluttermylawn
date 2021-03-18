import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_event.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_state.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/products/i_products_service.dart';

class MockProductService extends Mock implements ProductsService {}

class MockSessionManager extends Mock implements SessionManager {}

final List<Product> productList = [
  Product(
    name: 'Scotts® Turf Builder® with Moss Control (5m)',
    sku: '38505',
    lawnCondition: 'Wet',
    imageUrl:
        'https://images.scottsprogram.com/develop/pub/media/catalog/product/cache/cb865d9a255a148cb1d745eb912418f7/3/8/38505_1.png',
  )
];

final productCategory = ProductCategory.increaseThickness;

final List<ProductFilterBlockData> filters = [
  ProductFilterBlockData(
    id: productCategory.type,
    filterOptionList: [ProductFilterOption(id: productCategory.title)],
  ),
  ProductFilterBlockData(
      id: productFilterGrassTypes,
      filterOptionList: [ProductFilterOption(id: 'Test', name: 'Test')]),
];

void main() {
  final productService = MockProductService();
  final SessionManager sessionManager = MockSessionManager();

  group('initial state', () {
    PlpBloc plpBloc;
    setUp(() {
      plpBloc = PlpBloc(
          productsService: productService, sessionManager: sessionManager);
    });
    test('initial state is Plp', () {
      expect(plpBloc.state, PlpInitialState());
      plpBloc.close();
    });
  });
  group('', () {
    setUp(() {
      when(sessionManager.getLawnData()).thenAnswer(
          (_) async => LawnData(grassType: 'TST', grassTypeName: 'Test'));
      when(productService.filterProducts(filters))
          .thenAnswer((_) async => await productList);
    });

    blocTest<PlpBloc, PlpState>('PlpInitialLoadEvent',
        build: () => PlpBloc(
              productsService: productService,
              sessionManager: sessionManager,
            ),
        act: (bloc) => bloc.add(PlpInitialLoadEvent(category: productCategory)),
        expect: <PlpState>[
          PlpLoadingState(),
          PlpLoadedState(
            category: productCategory,
            productList: productList,
            inititalFilters: filters,
          ),
        ]);
    blocTest<PlpBloc, PlpState>('PlpApplyFilterEvent',
        build: () => PlpBloc(
              productsService: productService,
              sessionManager: sessionManager,
            ),
        act: (bloc) => bloc
            .add(PlpApplyFilterEvent(appliedFilters: filters, productList: [])),
        expect: <PlpState>[
          PlpLoadedState(
            productList: [],
            inititalFilters: filters,
          ),
        ]);
  });
}
