import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class MaybeSpinnerButton extends StatelessWidget {
  final bool spinner;
  final String spinnerText;
  final String text;

  MaybeSpinnerButton({this.spinner, this.spinnerText, this.text});

  @override
  Widget build(BuildContext context) => spinner
      ? Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              ProgressSpinner(
                size: 16,
                color: Theme.of(context).disabledColor,
              ),
              SizedBox(width: 16),
              Text(spinnerText)
            ])
      : Text(text);
}
