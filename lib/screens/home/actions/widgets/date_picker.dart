import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    @required this.onValueChanged,
    @required this.datePickerMode,
    @required this.selectedItem,
    Key key,
  }) : super(key: key);

  final ValueChanged<DateTime> onValueChanged;
  final CupertinoDatePickerMode datePickerMode;
  final DateTime selectedItem;

  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
      mode: datePickerMode,
      onDateTimeChanged: (date) => onValueChanged(date),
      initialDateTime: selectedItem,
      key: Key('date_picker'),
    );
  }
}
