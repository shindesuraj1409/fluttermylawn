import 'dart:collection';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_event.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:pedantic/pedantic.dart';

class PlpFilterBloc extends Bloc<PlpFilterEvent, PlpFilterState> {
  PlpFilterBloc({
    RecommendationService recommendationService,
    ProductsService productsService,
    GeoService geoService,
  })  : productsService = productsService ?? registry<ProductsService>(),
        recommendationStream = recommendationService?.recommendationStream,
        geoService = geoService,
        super(PlpFilterInitialState());

  final ProductsService productsService;
  final Stream<Recommendation> recommendationStream;
  final GeoService geoService;
  List<Product> filteredList;
  List<Product> productList;
  List<ProductFilterBlockData> partialFilters = [];
  List<ProductFilterBlockData> appliedFilters = [];
  ProductCategory productCategory;

  @override
  Stream<PlpFilterState> mapEventToState(PlpFilterEvent event) async* {
    try {
      if (event is PlpInitialFilterEvent) {
        yield PlpFilterLoadingState();
        var displayAllGrassTypes = true;
        productCategory = event.productCategory;
        appliedFilters = event.filters;
        partialFilters = event.filters
            .map((e) => ProductFilterBlockData(
                id: e.id,
                filterOptionList: e.filterOptionList.map((f) => f).toList(),
                displayAll: e.displayAll,
                title: e.title))
            .toList();
        ;
        productList = event.productList;
        Recommendation recommendation;
        await recommendationStream.listen((event) {
          return recommendation = event;
        });

        final grassTypes = await geoService.getGrassTypes(
            recommendation.lawnData.lawnAddress?.zip?.substring(0, 3));
        final filters = grassTypes
            .where((element) => element.type != LawnData.unknownGrassType)
            .map((e) {
          return ProductFilterOption(id: e.name, name: e.name);
        }).toList();

        final userGrassType = recommendation.lawnData.grassType;
        if (userGrassType != null &&
            userGrassType != '' &&
            userGrassType != LawnData.unknownGrassType) {
          final grass =
              grassTypes.firstWhere((element) => element.type == userGrassType);
          displayAllGrassTypes = false;
          final option =
              filters.firstWhere((element) => element.id == grass.name);
          filters.removeWhere((element) => element.id == grass.name);
          filters.insert(0, option);
        }

        final grassTypeFilterBlock = ProductFilterBlockData(
            id: productFilterGrassTypes,
            title: 'Grass Type',
            displayAll: displayAllGrassTypes,
            filterOptionList: filters);

        final sunlightFilterBlock = ProductFilterBlockData(
            id: productFilterSunlight,
            title: 'Sunlight',
            filterOptionList: [
              ProductFilterOption(id: filterOptionShade, name: 'Shade'),
              ProductFilterOption(id: filterOptionFullSun, name: 'Full Sun'),
              ProductFilterOption(
                  id: filterOptionPartialSun, name: 'Partial Sun'),
            ]);

        final variableFilter = _getVariableFilters(productCategory);
        yield variableFilter.isNotEmpty
            ? PlpFilterLoadedState(
                productList: productList,
                productFilters: [
                      grassTypeFilterBlock,
                      sunlightFilterBlock,
                    ] +
                    variableFilter,
                appliedFilters: appliedFilters,
              )
            : PlpFilterLoadedState(
                productList: productList,
                productFilters: [
                  grassTypeFilterBlock,
                  sunlightFilterBlock,
                ],
                appliedFilters: appliedFilters,
              );
      }

      if (event is PlpAddFilterEvent) {
        yield PlpFilterUpdatingingState();
        final addinFilter = event.filter;
        final actualFilter = partialFilters.firstWhere(
            (element) => element.id == addinFilter.id,
            orElse: () => null);
        if (actualFilter != null) {
          //dont add filters that already exist
          final filtersToAdd = addinFilter.filterOptionList
              .where((element) => !actualFilter.filterOptionList
                  .map((e) => e.id)
                  .contains(element.id))
              .toList();
          actualFilter.filterOptionList.addAll(filtersToAdd);
        } else {
          partialFilters.add(addinFilter);
        }
        final newList = <ProductFilterBlockData>[];
        partialFilters.forEach((element) {
          newList.add(element.copyWith(
              filterOptionList: LinkedHashSet<ProductFilterOption>.from(
                      element.filterOptionList)
                  .toList()));
        });
        filteredList = await _calculateProductList();
        yield PlpFilterUpdatedState(
            partialAppliedFilters: partialFilters, products: filteredList);
      }

      if (event is PlpRemoveFilterEvent) {
        yield PlpFilterUpdatingingState();
        final addinFilter = event.filter;
        final existingFilter = partialFilters.firstWhere(
            (element) => element.id == addinFilter.id,
            orElse: () => null);
        if (existingFilter != null) {
          existingFilter.filterOptionList.removeWhere((element) =>
              addinFilter.filterOptionList.firstWhere(
                  (addin) => addin.id == element.id,
                  orElse: () => null) !=
              null);
        }
        filteredList = await _calculateProductList();
        yield PlpFilterUpdatedState(
            partialAppliedFilters: partialFilters, products: filteredList);
      }
    } catch (error) {
      yield PlpFilterErrorState(
          errorMessage: 'Something went wrong. Please try again');
      unawaited(
          FirebaseCrashlytics.instance.recordError(error, StackTrace.current));
    }
  }

  Future<List<Product>> _calculateProductList() async {
    final productCategoryFilter = ProductFilterBlockData(
        id: productCategory.type,
        filterOptionList: [ProductFilterOption(id: productCategory.title)]);
    if (partialFilters.isEmpty) {
      return await productsService.filterProducts([productCategoryFilter]);
    } else {
      final filters = List<ProductFilterBlockData>.from(partialFilters);
      filters.add(productCategoryFilter);
      return await productsService.filterProducts(filters);
    }
  }

  List<ProductFilterBlockData> _getVariableFilters(
      ProductCategory productCategory) {
    //variable filter
    final variableFilter = <ProductFilterBlockData>[];

    variableFilter.add(ProductFilterBlockData(
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
        ]));

    variableFilter.add(ProductFilterBlockData(
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
        ]));

    return variableFilter;
  }
}
