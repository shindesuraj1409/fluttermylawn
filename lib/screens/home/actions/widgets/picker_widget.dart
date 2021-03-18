import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class PickerWidget extends StatelessWidget {
  const PickerWidget({
    @required this.selectedItem,
    @required this.items,
    @required this.onValueChanged,
    Key key,
  }) : super(key: key);

  final String selectedItem;
  final List<String> items;
  final ValueChanged<String> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: items.indexOf(selectedItem),
      ),
      useMagnifier: true,
      itemExtent: 40,
      onSelectedItemChanged: (index) => onValueChanged(items[index]),
      children: items.map((item) => _buildItem(item, context)).toList(),
    );
  }

  Widget _buildItem(String item, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 60),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            item,
            style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Styleguide.color_gray_9,
                ),
          ),
        ],
      ),
    );
  }
}
