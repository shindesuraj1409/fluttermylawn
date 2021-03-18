import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_event.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_state.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';
import 'package:my_lawn/data/quiz/grass_type_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';

class MockProductService extends Mock implements ProductsService {}

class MockGeoService extends Mock implements GeoService {}

class MockRecommendationService extends Mock implements RecommendationService {}

final productFilters = [
  ProductFilterBlockData(
      id: productFilterGrassTypes,
      title: 'Grass Type',
      displayAll: false,
      filterOptionList: [ProductFilterOption(id: 'Test', name: 'Test')]),
  ProductFilterBlockData(
      id: productFilterSunlight,
      title: 'Sunlight',
      filterOptionList: [
        ProductFilterOption(id: filterOptionShade, name: 'Shade'),
        ProductFilterOption(id: filterOptionFullSun, name: 'Full Sun'),
        ProductFilterOption(id: filterOptionPartialSun, name: 'Partial Sun'),
      ]),
  ProductFilterBlockData(
      id: productFilterWhatItControlls,
      title: 'Type of Control',
      filterOptionList: [
        ProductFilterOption(
          id: filterOptionInsects,
          name: 'Insects',
        ),
        ProductFilterOption(
          id: filterOptionDiseases,
          name: 'Diseases',
        ),
      ]),
  ProductFilterBlockData(
      id: productFilterWeedType,
      title: 'Weed Type',
      filterOptionList: [
        ProductFilterOption(
          id: filterOptionCrabgrass,
          name: 'Crabgrass',
        ),
        ProductFilterOption(
          id: filterOptionMoss,
          name: 'Moss',
        ),
        ProductFilterOption(
          id: filterOptionDandelion,
          name: 'Dandelion',
        ),
        ProductFilterOption(
          id: filterOptionClover,
          name: 'Clover',
        ),
      ])
];

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

final productCategory = ProductCategory.increaseThickness;

final List<ProductFilterBlockData> filters = [
  ProductFilterBlockData(
    id: productCategory.type,
    filterOptionList: [ProductFilterOption(id: productCategory.title)],
  ),
  ProductFilterBlockData(
      id: productFilterGrassTypes,
      filterOptionList: [ProductFilterOption(id: 'Test')]),
];

final List<GrassType> grassTypes = [GrassType(type: 'Test', name: 'Test')];

void main() {
  final productService = MockProductService();
  final geoService = MockGeoService();
  RecommendationService recommendationService;
  PlpFilterBloc plpBloc;

  group('initial state', () {
    setUp(() {
      recommendationService = MockRecommendationService();
      plpBloc = PlpFilterBloc(
          productsService: productService,
          geoService: geoService,
          recommendationService: recommendationService);
    });
    test('initial state is PlpFilterInitialState', () {
      expect(plpBloc.state, PlpFilterInitialState());
      plpBloc.close();
    });
  });
  group('Plp Filter with products', () {
    final addinFilter = ProductFilterBlockData(
        id: 'Filter1', filterOptionList: [ProductFilterOption(id: 'Filter1')]);
    setUp(() {
      recommendationService = MockRecommendationService();
      final recommendation = Recommendation(
        lawnData: LawnData(
          grassType: 'Test',
          grassTypeName: 'Test',
          lawnAddress: AddressData(zip: '000'),
        ),
      );
      when(geoService.getGrassTypes('000')).thenAnswer((_) async => grassTypes);
      when(productService.filterProducts(any))
          .thenAnswer((_) async => productList);
      when(recommendationService.recommendationStream.listen(any))
          .thenAnswer((Invocation invocation) {
        final callback = invocation.positionalArguments.single;
        return callback(recommendation);
      });

      blocTest<PlpFilterBloc, PlpFilterState>('PlpInitialLoadEvent',
          build: () => PlpFilterBloc(
              productsService: productService,
              geoService: geoService,
              recommendationService: recommendationService),
          act: (bloc) => bloc.add(PlpInitialFilterEvent(
              filters: filters,
              productList: productList,
              productCategory: productCategory)),
          wait: const Duration(milliseconds: 800),
          expect: <PlpFilterState>[
            PlpFilterLoadingState(),
            PlpFilterLoadedState(
                productFilters: productFilters,
                productList: productList,
                appliedFilters: [
                  ProductFilterBlockData(
                      displayAll: true,
                      id: ProductCategory.increaseThickness.type,
                      filterOptionList: [
                        ProductFilterOption(
                            id: ProductCategory.increaseThickness.title)
                      ]),
                  ProductFilterBlockData(
                      displayAll: true,
                      id: productFilterGrassTypes,
                      filterOptionList: [ProductFilterOption(id: 'Test')]),
                ])
          ]);

      blocTest<PlpFilterBloc, PlpFilterState>('Add and then remove a filter',
          build: () => PlpFilterBloc(
              productsService: productService,
              geoService: geoService,
              recommendationService: recommendationService)
            ..add(PlpInitialFilterEvent(
                filters: filters,
                productList: productList,
                productCategory: productCategory)),
          act: (bloc) {
            plpBloc.add(PlpAddFilterEvent(filter: addinFilter));
            plpBloc.add(PlpRemoveFilterEvent(filter: addinFilter));
          },
          expect: <PlpFilterState>[
            PlpFilterLoadingState(),
            PlpFilterLoadedState(
                productFilters: productFilters,
                productList: productList,
                appliedFilters: [
                  ProductFilterBlockData(
                      displayAll: true,
                      id: ProductCategory.increaseThickness.type,
                      filterOptionList: [
                        ProductFilterOption(
                            id: ProductCategory.increaseThickness.title)
                      ]),
                  ProductFilterBlockData(
                      displayAll: true,
                      id: productFilterGrassTypes,
                      filterOptionList: [ProductFilterOption(id: 'Test')]),
                ]),
            PlpFilterUpdatingingState(),
            PlpFilterUpdatedState(
                products: productList,
                partialAppliedFilters: filters + [addinFilter]),
            PlpFilterUpdatingingState(),
            PlpFilterUpdatedState(
                products: productList,
                partialAppliedFilters: filters +
                    [
                      ProductFilterBlockData(
                          id: 'Filter1', displayAll: true, filterOptionList: [])
                    ])
          ]);
    });
  });
}
