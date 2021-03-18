import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_state.dart';
import 'package:my_lawn/data/product/product_filter_option_data.dart';

class PlpFilterOptionWidget extends StatefulWidget {
  final ProductFilterOption filterOption;
  final PlpFilterBloc bloc;
  final double height;
  final List<ProductFilterOption> appliedFilters;
  final Function(ProductFilterOption) onAdd;
  final Function(ProductFilterOption) onRemove;

  const PlpFilterOptionWidget({
    Key key,
    this.filterOption,
    @required this.height,
    this.appliedFilters,
    this.onAdd,
    this.onRemove,
    this.bloc,
  }) : super(key: key);

  @override
  _PlpFilterOptionWidgetState createState() => _PlpFilterOptionWidgetState();
}

class _PlpFilterOptionWidgetState extends State<PlpFilterOptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO: @eugene change sizing and check padding of checkbox
      padding: const EdgeInsets.only(left: 24.0, right: 10.0),
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.filterOption.name,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Checkbox(
            value: widget.appliedFilters.firstWhere(
                  (element) => element.id == widget.filterOption.id,
                  orElse: () => null,
                ) !=
                null,
            onChanged: (widget.bloc.state is! PlpFilterUpdatingingState)
                ? (isSelected) {
                    if (isSelected) {
                      widget.onAdd(widget.filterOption);
                    } else {
                      widget.onRemove(widget.filterOption);
                    }
                  }
                : null,
            key: Key('filter_checkbox_${widget.filterOption.name.toLowerCase().replaceAll(' ', '_')}'),
          )
        ],
      ),
    );
  }
}
