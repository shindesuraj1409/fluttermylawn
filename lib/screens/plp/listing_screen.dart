import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_event.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/plp/product_filter_screen.dart';
import 'package:my_lawn/screens/plp/widgets/plp_tile_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class ProductListingScreen extends StatefulWidget {
  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with RouteMixin<ProductListingScreen, ProductCategory> {
  ProductCategory category;
  PlpBloc bloc = registry<PlpBloc>();
  List<ProductFilterBlockData> _filters;
  var filterCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      category = routeArguments;
      bloc.add(
        PlpInitialLoadEvent(category: category),
      );
    }
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void showFilterModal(ProductCategory category, List<Product> productList) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return PlpFilterScreen(
            plpBloc: bloc,
            category: category,
            productList: productList,
            initialFilters: List<ProductFilterBlockData>.from(_filters),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    var _products = <Product>[];

    return BlocConsumer<PlpBloc, PlpState>(
      listenWhen: (previous, current) => current is PlpLoadedState,
      listener: (context, state) {
        return filterCount = (state as PlpLoadedState)
                .inititalFilters
                .expand((element) => element.filterOptionList)
                .toSet()
                .length -
            1;
      },
      cubit: bloc,
      builder: (context, state) {
        if (state is PlpLoadedState) {
          _products = state.productList;
          _filters = List<ProductFilterBlockData>.from(state.inititalFilters);
        }
        return BasicScaffoldWithSliverAppBar(
          isNotUsingWillPop: true,
          childFillsRemainingSpace: false,
          hasScrollBody: true,
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/icons/search.png',
                  key: Key('product_search'),
                  width: 28,
                  fit: BoxFit.contain,
                ),
              ),
              onTap: () => registry<Navigation>()
                  .push('/plp/search', arguments: _products),
            )
          ],
          appBarSecondLine: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 52,
            decoration: BoxDecoration(
              color: Styleguide.color_gray_0,
              border: Border(
                bottom: BorderSide(width: 1, color: Styleguide.color_gray_2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_products.length} items',
                key: Key('Items_count'),
                    style: _theme.textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Styleguide.color_green_5)),
                if (state is PlpLoadedState)
                  OutlineButton(
            key:    Key('filter_button'),
                    child:
                        Text('FILTERS ${filterCount != 0 ? filterCount : ''}',
                        key: Key('filter_text')),
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    borderSide: BorderSide(color: Styleguide.color_green_5),
                    textColor: Styleguide.color_green_5,
                    onPressed: () => showFilterModal(category, _products),
                  ),
              ],
            ),
          ),
          appBarSecondLineHeight: 52,
          appBarElevation: 0,
          appBarBackgroundColor: category.color,
          trailing: Image.asset(
            category.appbarIcon,
            height: 23,
          ),
          titleString: category.title,
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                if (state is PlpInitialState) Container(),
                if (state is PlpLoadingState)
                  Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: Center(
                      child: ProgressSpinner(),
                    ),
                  ),
                if (state is PlpErrorState)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Text(
                          '${state.errorMessage}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Retry',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        onPressed: () =>
                            bloc.add(PlpInitialLoadEvent(category: category)),
                      ),
                    ],
                  ),
                if (state is PlpLoadedState)
                  Column(
                    children: [
                      ..._products.map(
                        (e) => PlpTileWidget(
                          index: _products.indexOf(e),
                          showLeading: true,
                          showTrailing: false,
                          showProduct: true,
                          isTitleCentered: false,
                          isLeadingNetworkImage: true,
                          isTrailingNetworkImage: false,
                          isSubtitle: true,
                          isProductList: true,
                          title: e.name,
                          subtitle: '', // TODO Subscription data implementation
                          leadingIcon: e.imageUrl,
                          trailingIcon: null,
                          color: Styleguide.color_gray_0,
                          elevation: 0,
                          listTileVerticalPadding: 16,
                          onTapMethod: () {
                            registry<Navigation>()
                                .push('/product/detail', arguments: e);
                          },
                          cardVerticalPadding: 0,
                          cardHorizontalPadding: 0,
                          cardBorderRadius: 0,
                          trailingPadding: 0,
                          titleLeftPadding: 12,
                          titleTopPadding: 0,
                          titleBottomPadding: 8,
                          subTitleLeftPadding: 16,
                          subTitleTopPadding: 0,
                          subTitleBottomPadding: 0,
                          leadingContainerHorizontalPadding: 0,
                          leadingContainerVerticalPadding: 0,
                          trailingContainerHorizontalPadding: 0,
                          trailingContainerVerticalPadding: 0,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
