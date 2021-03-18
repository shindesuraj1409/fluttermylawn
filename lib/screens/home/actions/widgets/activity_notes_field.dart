import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class ActivityNotesField extends StatelessWidget {
  const ActivityNotesField({
    @required this.controller,
    Key key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Styleguide.color_gray_1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        minLines: 5,
        maxLines: 20,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'Any notes?',
          hintStyle: Theme.of(context).textTheme.subtitle1,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 20,
          ),
        ),
        key: Key('enter_task_notes_input_field'),
      ),
    );
  }
}
