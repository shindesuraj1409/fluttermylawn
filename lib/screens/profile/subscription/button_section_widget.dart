import 'package:flutter/material.dart';
import 'package:my_lawn/screens/profile/subscription/section_widget.dart';

class ButtonSectionWidget extends StatelessWidget {
  const ButtonSectionWidget(
      {Key key,
      this.title,
      this.text,
      this.leadingImageName,
      this.leadingIconData,
      this.onTap,
      this.width,
      this.height})
      : super(key: key);

  final String title;
  final String text;
  final String leadingImageName;
  final IconData leadingIconData;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      child: SectionWidget(
        title: title,
        text: text,
        leading: leadingImageName == null && leadingIconData == null
            ? null
            : Padding(
                padding: EdgeInsets.only(
                  right: leadingImageName != null ? 16 : 20,
                ),
                child: leadingImageName != null
                    ? Image.asset(
                        leadingImageName,
                        width: width ?? 24,
                        height: height ?? 24,
                        key: Key('image'),
                      )
                    : Icon(
                        leadingIconData,
                        size: 20,
                        color: theme.primaryColor,
                        key: Key('icon'),
                      ),
              ),
        trailing: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: title == null ? 0 : 8,
            ),
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: theme.textTheme.bodyText2.color,
              key: Key('navigate_to_icon'),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
