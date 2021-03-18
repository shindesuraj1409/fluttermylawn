import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget(
      {Key key, this.title, this.text, this.leading, this.trailing})
      : super(key: key);

  final String title;
  final String text;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: title == null ? 24 : 48,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: Text(title, style: textTheme.caption),
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: title == null ? 24 : 32,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leading != null) leading,
                        Expanded(
                          child: Text(
                            text,
                            style: textTheme.subtitle1,
                            key: Key('section_main_label'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              Container(
                height: title == null ? 24 : 48,
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
