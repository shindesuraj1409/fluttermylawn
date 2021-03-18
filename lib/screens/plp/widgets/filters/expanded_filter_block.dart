import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_event.dart';

import 'package:my_lawn/config/colors_config.dart';

import 'package:my_lawn/data/product/product_filter_block_data.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';

import 'filter_option.dart';

class PlpExpandedFilterBlock extends StatefulWidget {
  final ProductFilterBlockData filter;
  final ProductFilterBlockData appliedFilters;
  final bool displayAll;
  final PlpFilterBloc plpFilterBloc;
  PlpExpandedFilterBlock({
    Key key,
    this.filter,
    this.displayAll,
    this.appliedFilters,
    this.plpFilterBloc,
  }) : super(key: key);

  @override
  _PlpExpandedFilterBlockState createState() => _PlpExpandedFilterBlockState();
}

class _PlpExpandedFilterBlockState extends State<PlpExpandedFilterBlock> {
  List<ProductFilterOption> optionList;
  // The number of shown elements for filter option by default
  int defaultFilterClosedSize = 1;
  @override
  void initState() {
    widget.displayAll == true
        ? defaultFilterClosedSize = widget.filter.filterOptionList.length
        : defaultFilterClosedSize = 1;
    optionList = widget.filter.filterOptionList;

    super.initState();
  }

  bool _isOpen = false;

  void openContainer() => setState(() => _isOpen = !_isOpen);

  bool checkIfAllSelected(List<ProductFilterOption> selectedFilters) {
    return optionList.every((element) => selectedFilters.contains(element));
  }

  void changeGroupSelection() {
    final allOptions = List<ProductFilterOption>.of(optionList);
    if (!checkIfAllSelected(widget.appliedFilters.filterOptionList)) {
      //add them to the list
      widget.plpFilterBloc.add(PlpAddFilterEvent(
          filter: ProductFilterBlockData(
              id: widget.filter.id, filterOptionList: allOptions)));
    } else {
      //remove them from the list
      widget.plpFilterBloc.add(PlpRemoveFilterEvent(
          filter: ProductFilterBlockData(
              id: widget.filter.id, filterOptionList: allOptions)));
    }
  }

  //The default size of filter option< if changed, the size of expanded container will change tto
  //can be modified in future
  final double filterWidgetHeight = 40.0;
  // Animation duration of the filter options container list
  final Duration animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.only(top: 24.0, bottom: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.filter.title}',
                  style: theme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.1,
                  ),
                ),
                InkWell(
                  onTap: () => changeGroupSelection(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      checkIfAllSelected(widget.appliedFilters.filterOptionList)
                          ? 'Deselect all'
                          : 'Select All',
                      style: theme.bodyText2.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.1,
                        color: Styleguide.color_green_4,
                      ),
                      key: Key('${widget.filter.title.toLowerCase().replaceAll(' ', '_')}_filter_checkbox_select_deselect_all'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            key: Key(hashCode.toString()),
            duration: animationDuration,
            curve: Curves.easeInOut,
            //Calculating the current animating container height according to list length and comparing to default
            //list value in [defaultFilterClosedSize]
            height: (_isOpen
                    ? optionList.length
                    : (defaultFilterClosedSize > optionList.length
                        ? optionList.length
                        : defaultFilterClosedSize)) *
                filterWidgetHeight,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _isOpen
                  ? optionList.length
                  : (defaultFilterClosedSize < optionList.length)
                      ? defaultFilterClosedSize
                      : optionList.length,
              itemBuilder: (BuildContext context, int index) {
                return PlpFilterOptionWidget(
                  bloc: widget.plpFilterBloc,
                  onAdd: (a) {
                    widget.plpFilterBloc.add(PlpAddFilterEvent(
                        filter: ProductFilterBlockData(
                            id: widget.filter.id, filterOptionList: [a])));
                  },
                  onRemove: (a) {
                    widget.plpFilterBloc.add(PlpRemoveFilterEvent(
                        filter: ProductFilterBlockData(
                            id: widget.filter.id, filterOptionList: [a])));
                  },
                  appliedFilters: widget.appliedFilters.filterOptionList,
                  filterOption: optionList[index],
                  height: filterWidgetHeight,
                );
              },
            ),
          ),
          if (optionList.length > defaultFilterClosedSize)
            Container(
              margin: const EdgeInsets.only(right: 24.0, left: 14),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: openContainer,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _isOpen ? 'Show less' : 'Show more',
                            style: theme.headline6.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Styleguide.color_green_4,
                            ),
                            key: Key('${widget.filter.title.toLowerCase().replaceAll(' ', '_')}_filter_options_show_more_and_show_less'),
                          ),
                          Icon(
                            _isOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Styleguide.color_green_4,
                            size: 18.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
