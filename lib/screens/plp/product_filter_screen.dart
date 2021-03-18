import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_event.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_state.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_event.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';

import 'widgets/filters/expanded_filter_block.dart';

class PlpFilterScreen extends StatefulWidget {
  final PlpBloc plpBloc;
  final ProductCategory category;
  final List<Product> productList;
  final List<ProductFilterBlockData> initialFilters;

  const PlpFilterScreen(
      {Key key,
      this.plpBloc,
      this.category,
      this.productList,
      this.initialFilters})
      : super(key: key);

  @override
  _PlpFilterScreenState createState() => _PlpFilterScreenState();
}

class _PlpFilterScreenState extends State<PlpFilterScreen> {
  PlpFilterBloc plpFilterBloc;
  List<Product> prodList;
  List<ProductFilterBlockData> filterList;
  var partialAppliedFilters;

  var count = 0;
  @override
  void initState() {
    prodList = <Product>[];
    filterList = <ProductFilterBlockData>[];
    partialAppliedFilters =
        List<ProductFilterBlockData>.from(widget.initialFilters);
    plpFilterBloc = registry<PlpFilterBloc>();
    plpFilterBloc.add(
      PlpInitialFilterEvent(
        plpBloc: widget.plpBloc,
        productCategory: widget.category,
        productList: widget.productList,
        filters: partialAppliedFilters,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    plpFilterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<PlpFilterBloc, PlpFilterState>(
      cubit: plpFilterBloc,
      builder: (context, state) {
        if (state is PlpFilterLoadedState) {
          prodList = state.productList;
          count = prodList.length;
          filterList = state.productFilters;
        }
        if (state is PlpFilterUpdatedState) {
          partialAppliedFilters = state.partialAppliedFilters;
          prodList = state.products;
          count = prodList?.length;
        }

        return Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 13),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Styleguide.color_gray_2),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 17, left: 24.0, right: 24.0, bottom: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Styleguide.color_gray_2, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Filters',
                      style: theme.textTheme.subtitle1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL',
                        key: Key('filter_cancel_button'),
                        style: theme.textTheme.bodyText2.copyWith(
                          color: Styleguide.color_green_4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state is PlpFilterLoadingState)
                Expanded(
                  child: Container(child: Center(child: ProgressSpinner())),
                ),
              if (state is PlpFilterErrorState)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: () => plpFilterBloc.add(
                                PlpInitialFilterEvent(
                                  plpBloc: widget.plpBloc,
                                  productCategory: widget.category,
                                  productList: widget.productList,
                                  filters: partialAppliedFilters,
                                ),
                              )),
                    ],
                  ),
                ),
              if (state is PlpFilterLoadedState ||
                  state is PlpFilterUpdatedState ||
                  state is PlpFilterUpdatingingState)
                Expanded(
                  child: Container(
                    child: ListView(
                      children: [
                        ...intersperse(
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Divider(
                              key: Key('product_divider'),
                              color: Styleguide.color_gray_2,
                              thickness: 1.0,
                            ),
                          ),
                          filterList
                              .map(
                                (e) => PlpExpandedFilterBlock(
                                  plpFilterBloc: plpFilterBloc,
                                  appliedFilters:
                                      partialAppliedFilters.firstWhere(
                                          (element) => element.id == e.id,
                                          orElse: () => ProductFilterBlockData(
                                              id: e.id, filterOptionList: [])),
                                  displayAll: e.displayAll,
                                  filter: e,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              if (state is! PlpFilterErrorState)
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(0, 3),
                      blurRadius: 5.0,
                      spreadRadius: -1,
                    ),
                    BoxShadow(
                      color: Color(0x1e000000),
                      offset: Offset(0, 1),
                      blurRadius: 18.0,
                      spreadRadius: 0.0,
                    ),
                    BoxShadow(
                      color: Color(0x1e000000),
                      offset: Offset(0, 1),
                      blurRadius: 18.0,
                      spreadRadius: 0.0,
                    ),
                  ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                            onPressed: (count == 0 ||
                                    count == null ||
                                    state is PlpFilterUpdatingingState)
                                ? null
                                : () {
                                    widget.plpBloc.add(PlpApplyFilterEvent(
                                        appliedFilters: partialAppliedFilters,
                                        productList: prodList));
                                    registry<Navigation>().pop();
                                  },
                            child: Container(
                              child: count == null ||
                                      state is PlpFilterUpdatingingState
                                  ? ProgressSpinner()
                                  : Text(
                                      'SHOW $count PRODUCTS',
                                    key: Key('show_product_button'),
                                    ),
                            )),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 45.0,
                        child: FlatButton(
                          onPressed: () {
                            widget.plpBloc.add(PlpClearFilterEvent());
                            registry<Navigation>().pop();
                          },
                          child: Text(
                            'CLEAR FILTERS',
                          key: Key('clear_filter_button'),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
