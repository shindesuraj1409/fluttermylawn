import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/filter_data.dart';
import 'package:my_lawn/data/tips/filter_option_data.dart';

class FilterOptionWidget extends StatefulWidget {
  final FilterOption filterOption;
  final double height;

  const FilterOptionWidget({
    Key key,
    this.filterOption,
    @required this.height,
  }) : super(key: key);

  @override
  _FilterOptionWidgetState createState() => _FilterOptionWidgetState();
}

class _FilterOptionWidgetState extends State<FilterOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipsFilterBloc, TipsFilterState>(
        cubit: registry<TipsFilterBloc>(),
        builder: (context, state) {
          Filter filter;
          if (state is TipsBeingFiltered) {
            filter = state.filter;
          }
          if (state is TipsFilterOpened) {
            filter = state.filter;
          }
          return Container(
            //TODO: @eugene change sizing and check padding of checkbox
            padding: const EdgeInsets.only(left: 24.0, right: 10.0),
            height: widget.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.filterOption.filter_name,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Checkbox(
                  value: state is TipsFilterOpened
                      ? state.filter.partialFilters
                          .contains(widget.filterOption.filter_id)
                      : state is TipsBeingFiltered
                          ? state.filter.partialFilters
                              .contains(widget.filterOption.filter_id)
                          : false,
                  onChanged: (isSelected) {
                    if (isSelected) {
                      registry<TipsFilterBloc>().add(ApplyTipsFilter(
                          filterIdList: [widget.filterOption.filter_id],
                          filter: filter));
                    } else {
                      registry<TipsFilterBloc>().add(RemoveTipsFilter(
                          filterIdList: [widget.filterOption.filter_id],
                          filter: filter));
                    }
                    setState(() {});
                  },
                  key: Key(
                      'filter_checkbox_${widget.filterOption.filter_name.toLowerCase().replaceAll(' ', '_')}'),
                )
              ],
            ),
          );
        });
  }
}
