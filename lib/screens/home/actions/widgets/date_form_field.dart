import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_action_bar.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_content.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_form_field.dart';
import 'package:my_lawn/screens/home/actions/widgets/date_picker.dart';
import 'package:my_lawn/screens/home/actions/widgets/ectivity_edit_button.dart';
import 'package:my_lawn/screens/home/actions/widgets/form_field_content.dart';
import 'package:my_lawn/screens/home/actions/widgets/lawn_utils.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';

class DateFormField extends StatelessWidget {
  const DateFormField({
    Key key,
    @required this.selectedItem,
    @required this.onValueSelected,
    this.datePickerMode = CupertinoDatePickerMode.date,
  }) : super(key: key);

  final DateTime selectedItem;
  final OnValueSelected<DateTime> onValueSelected;
  final CupertinoDatePickerMode datePickerMode;

  void _showDialog(BuildContext context) {
    var item = selectedItem;

    showBottomSheetDialog(
      context: context,
      hasTopPadding: false,
      child: Column(
        children: [
          ActivityDialogActionBar(
            onSelectTap: () => onValueSelected(item),
          ),
          ActivityDialogContent(
            child: DatePicker(
              datePickerMode: datePickerMode,
              selectedItem: item,
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
      onTap: () {
        FocusScope.of(context).unfocus();
        _showDialog(context);
      },
      title: 'When',
      child: ActivityEditButton(
        middleText: lawnDateFormat.format(selectedItem),
      ),
    );
  }
}
