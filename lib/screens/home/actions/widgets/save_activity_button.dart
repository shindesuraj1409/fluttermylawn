import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class SaveActivityButton extends StatelessWidget {
  const SaveActivityButton({
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decoration(),
      height: 52,
      margin: const EdgeInsets.all(16),
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: FlatButton(
          color: Styleguide.color_green_4,
          padding: const EdgeInsets.all(16),
          onPressed: onTap,
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Styleguide.color_gray_0,
                ),
            key: Key('save'),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return const BoxDecoration(
      color: Styleguide.color_gray_0,
      boxShadow: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 1),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
