import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/filter_data.dart';
import 'package:my_lawn/data/tips/filter_option_data.dart';

import 'package:my_lawn/screens/tips/widgets/filter_dialog/filter_option.dart';

class ExpandedFilterBlock extends StatefulWidget {
  final FilterBlockData filter;

  ExpandedFilterBlock({
    Key key,
    this.filter,
  }) : super(key: key);

  @override
  _ExpandedFilterBlockState createState() => _ExpandedFilterBlockState();
}

class _ExpandedFilterBlockState extends State<ExpandedFilterBlock> {
  List<FilterOption> optionList;

  @override
  void initState() {
    optionList = widget.filter.filter_option_list;
    super.initState();
  }

  bool _isOpen = false;

  void openContainer() => setState(() => _isOpen = !_isOpen);

  bool checkIfAllSelected(List<String> selectedFilters) {
    return optionList
        .every((element) => selectedFilters.contains(element.filter_id));
  }

  void changeGroupSelection(bool isAllSelected, Filter filter) {
    final selectedIdList = optionList.map((e) => e.filter_id).toList();
    if (!isAllSelected) {
      //add them to the list
      registry<TipsFilterBloc>()
          .add(ApplyTipsFilter(filterIdList: selectedIdList, filter: filter));
    } else {
      //remove them of the list
      registry<TipsFilterBloc>()
          .add(RemoveTipsFilter(filterIdList: selectedIdList, filter: filter));
    }
    setState(() {});
  }

  //The default size of filter option< if changed, the size of expanded container will change tto
  //can be modified in future
  final double filterWidgetHeight = 40.0;
  // The number of shown elements for filter option by default
  final int defaultFilterClosedSize = 2;
  // Animation duration of the filter options container list
  final Duration animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocBuilder<TipsFilterBloc, TipsFilterState>(
      cubit: registry<TipsFilterBloc>(),
      builder: (context, state) {
        var _isAllSelected = false;
        Filter filter;
        if (state is TipsFilterOpened) {
          filter = state.filter;
          _isAllSelected = checkIfAllSelected(state.filter.partialFilters);
        }
        if (state is TipsBeingFiltered) {
          filter = state.filter;
          _isAllSelected = checkIfAllSelected(state.filter.partialFilters);
        }

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
                      onTap: () => changeGroupSelection(_isAllSelected, filter),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          _isAllSelected ? 'Deselect all' : 'Select All',
                          style: theme.bodyText2.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.1,
                            color: Styleguide.color_green_4,
                          ),
                          key: Key(
                              '${widget.filter.title.toLowerCase().replaceAll(' ', '_')}_filter_checkbox_select_deselect_all'),
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
                    return FilterOptionWidget(
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
                                _isOpen ? 'Show less' : 'show more',
                                style: theme.headline6.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Styleguide.color_green_4,
                                ),
                                key: Key(
                                    '${widget.filter.title.toLowerCase().replaceAll(' ', '_')}_filter_options_show_more_and_show_less'),
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
      },
    );
  }
}
