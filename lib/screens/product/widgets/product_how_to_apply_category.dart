import 'package:flutter/material.dart';

class HowToUseCategory extends StatelessWidget {
  final Widget header;
  final Widget description;
  final bool hasDivider;

  const HowToUseCategory({
    Key key,
    this.header,
    this.description,
    this.hasDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: header,
        ),
        description,
        if (hasDivider)
          Container(
            margin: EdgeInsets.symmetric(vertical: 24),
            child: Divider(thickness: 1),
          ),
      ]),
    );
  }
}
