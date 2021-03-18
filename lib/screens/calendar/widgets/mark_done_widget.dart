import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

const _borderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(8),
  bottomRight: Radius.circular(8),
);

class MarkDoneWidget extends StatelessWidget {
  const MarkDoneWidget({
    this.onTap,
    Key key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: _borderRadius,
      child: Material(
        elevation: 4,
        borderRadius: _borderRadius,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: Styleguide.color_gray_0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              'MARK AS DONE',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Styleguide.color_gray_9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
