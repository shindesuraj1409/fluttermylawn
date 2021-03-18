import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

void showSnackbar({BuildContext context, String text, Duration duration}) {
  Flushbar<String>(
    margin: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    boxShadows: [
      BoxShadow(color: Colors.black38, offset: Offset(0, 3), blurRadius: 18)
    ],
    borderRadius: 4,
    backgroundColor: Theme.of(context).colorScheme.onSecondary,
    messageText: Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(color: Styleguide.color_gray_2),
      key: Key('task_saved_notification'),
    ),
    duration: duration,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    flushbarStyle: FlushbarStyle.FLOATING,
  )..show(context);
}
