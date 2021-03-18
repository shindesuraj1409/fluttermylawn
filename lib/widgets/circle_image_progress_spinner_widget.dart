import 'package:flutter/material.dart';

import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class CircleImageProgressSpinner extends StatelessWidget {
  const CircleImageProgressSpinner({
    Key key,
    @required this.image,
  }) : assert(image != null, 'Image can\'t be null'), super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ProgressSpinner(
          size: 128,
          strokeWidth: 8,
          color: Styleguide.color_green_8,
        ),
        CircleAvatar(
          radius: 60,
          backgroundColor: Styleguide.color_gray_0,
          child: Image.asset(
            image,
            height: 84,
          ),
        ),
      ],
    );
  }
}
