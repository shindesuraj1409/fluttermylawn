import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/extensions/number_extension.dart';

class SeasonalShipmentList extends StatefulWidget {
  final List<Product> products;
  SeasonalShipmentList(this.products);

  @override
  SeasonalShipmentListState createState() => SeasonalShipmentListState();
}

class SeasonalShipmentListState extends State<SeasonalShipmentList> {
  bool _showAllShipments = false;

  String _firstShipmentLabel;
  String _firstShipmentPrice;

  final List<String> _otherShipmentLabels = [];
  final List<String> _otherShipmentPrices = [];

  int noOfShipments;

  @override
  void initState() {
    super.initState();

    _firstShipmentLabel =
        '1st shipment: ${widget.products.first.applicationWindow.season}';
    _firstShipmentPrice = widget.products.first.bundlePrice.toStringAsFixed(2);

    widget.products.asMap().forEach((key, value) {
      if (key != 0) {
        _otherShipmentLabels.add(
            '${key + 1}${(key + 1).ordinal} shipment: ${value.applicationWindow.season}');
        _otherShipmentPrices.add(value.bundlePrice.toStringAsFixed(2));
      }
    });

    // 1st Shipment + Other Shipments
    noOfShipments = _otherShipmentLabels.length + 1;
  }

  Widget _buildShipmentLabel(String label, String price, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.subtitle2
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: Text(
              '\$$price',
              style: theme.textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.w600,
                color: Styleguide.color_green_4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        _buildShipmentLabel(_firstShipmentLabel, _firstShipmentPrice, theme),
        AnimatedContainer(
          height: _showAllShipments ? noOfShipments * 18.0 : 0,
          alignment: Alignment.topLeft,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            children: [
              for (var i = 0; i < _otherShipmentLabels.length; i++)
                _buildShipmentLabel(
                  _otherShipmentLabels[i],
                  _otherShipmentPrices[i],
                  theme,
                )
            ],
          ),
        ),
        GestureDetector(
          child: Row(
            children: <Widget>[
              _showAllShipments
                  ? Text(
                      'Show less',
                      style: theme.textTheme.headline6.copyWith(
                        color: Styleguide.color_green_4,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      'Show all $noOfShipments shipments',
                      style: theme.textTheme.headline6.copyWith(
                        color: Styleguide.color_green_4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              _showAllShipments
                  ? Icon(
                      Icons.keyboard_arrow_up,
                      color: Styleguide.color_green_4,
                      size: 20.0,
                      key: Key('hide_all_shipments'),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: Styleguide.color_green_4,
                      size: 20.0,
                      key: Key('show_all_shipments'),
                    ),
            ],
          ),
          onTap: () {
            setState(() {
              _showAllShipments = !_showAllShipments;
            });
          },
        ),
      ],
    );
  }
}
