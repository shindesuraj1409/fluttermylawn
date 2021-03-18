import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class ActivityEditButton extends StatelessWidget {
  const ActivityEditButton({
    @required this.middleText,
    Key key,
  }) : super(key: key);

  final String middleText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 40),
          child: Text(
            middleText ?? '',
            style: Theme.of(context).textTheme.subtitle1,
            key: Key('selected_middle_text'),
          ),
        ),
        Text(
          'Edit',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Styleguide.color_green_7,
              ),
          key: Key('edit_button'),
        )
      ],
    );
  }
}
