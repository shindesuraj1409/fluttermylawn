import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_event.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_state.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/services/products/i_products_service.dart';

class MockProductService extends Mock implements ProductsService {}

final List<Product> productList = [
  Product(
      name: 'Scotts® Turf Builder® with Moss Control (5m)',
      skipped: false,
      isSubscribed: false,
      isArchived: false,
      isAddedByMe: false,
      applied: false,
      lawnCondition: 'Wet',
      sku: '38505',
      imageUrl:
          'https://images.scottsprogram.com/develop/pub/media/catalog/product/cache/cb865d9a255a148cb1d745eb912418f7/3/8/38505_1.png')
];

void main() {
  final productService = MockProductService();
  PlpSearchBloc plpBloc;

  group('initial state', () {
    setUp(() {
      plpBloc = PlpSearchBloc(productsService: productService);
    });
    test('initial state is PlpSearchInitialState', () {
      expect(plpBloc.state, PlpSearchInitialState());
      plpBloc.close();
    });
  });
  group('Plp search with products', () {
    setUp(() {
      plpBloc = PlpSearchBloc(productsService: productService);
    });

    blocTest<PlpSearchBloc, PlpSearchState>('PlpInitialLoadEvent',
        build: () => plpBloc,
        act: (bloc) =>
            bloc.add(PlpSearchInitialEvent(productList: productList)),
        wait: const Duration(milliseconds: 800),
        expect: <PlpSearchState>[PlpSearchInitializedState()]);

    blocTest<PlpSearchBloc, PlpSearchState>('PlpSearchUpdateEvent',
        build: () => plpBloc,
        act: (bloc) async {
          bloc.add(PlpSearchInitialEvent(productList: productList));
          await Future.delayed(Duration(milliseconds: 900));
          bloc.add(PlpSearchUpdateEvent('Scotts'));
        },
        wait: const Duration(milliseconds: 1700),
        expect: [
          isA<PlpSearchInitializedState>(),
          isA<PlpSearchUpdatedState>()
        ]);
  });
  group('Plp search without products', () {
    setUp(() {
      plpBloc = PlpSearchBloc(productsService: productService);
      when(when(productService.searchProducts(''))
          .thenAnswer((_) async => await productList));
    });

    blocTest<PlpSearchBloc, PlpSearchState>('PlpInitialLoadEvent',
        build: () => plpBloc,
        act: (bloc) => bloc.add(PlpSearchInitialEvent()),
        wait: const Duration(milliseconds: 800),
        expect: <PlpSearchState>[PlpSearchInitializedState()]);

    blocTest<PlpSearchBloc, PlpSearchState>('PlpSearchUpdateEvent',
        build: () => plpBloc,
        act: (bloc) async {
          bloc.add(PlpSearchInitialEvent());
          await Future.delayed(Duration(milliseconds: 900));
          bloc.add(PlpSearchUpdateEvent('Scotts'));
        },
        wait: const Duration(milliseconds: 1700),
        expect: [
          isA<PlpSearchInitializedState>(),
          isA<PlpSearchLoadingState>(),
          isA<PlpSearchUpdatedState>()
        ]);
  });
}
