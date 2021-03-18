import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_action_bar.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_content.dart';
import 'package:my_lawn/screens/home/actions/widgets/ectivity_edit_button.dart';
import 'package:my_lawn/screens/home/actions/widgets/form_field_content.dart';
import 'package:my_lawn/screens/home/actions/widgets/picker_widget.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';

typedef OnValueSelected<T> = Function(T value);

class ActivityFormField<T> extends StatelessWidget {
  const ActivityFormField({
    @required this.title,
    @required this.onValueSelected,
    this.selectedItem,
    this.items,
    this.selected = false,
    this.selectable = false,
    Key key,
  }) : super(key: key);

  final String title;
  final List<String> items;
  final String selectedItem;
  final OnValueSelected<T> onValueSelected;
  final bool selected;
  final bool selectable;

  void _showDialog(BuildContext context) {
    var item = selectedItem;

    showBottomSheetDialog<T>(
      context: context,
      hasTopPadding: false,
      child: Column(
        children: [
          ActivityDialogActionBar(
            onSelectTap: () => onValueSelected(item as T),
          ),
          ActivityDialogContent(
            child: PickerWidget(
              selectedItem: item,
              items: items,
              onValueChanged: (newItem) {
                item = newItem;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldContent(
      onTap: () =>
          selectable ? onValueSelected(!selected as T) : _showDialog(context),
      title: title,
      child: selectable
          ? CupertinoSwitch(
              value: selected,
              onChanged: (val) => onValueSelected(val as T),
            )
          : ActivityEditButton(middleText: selectedItem),
    );
  }
}
