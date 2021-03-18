import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final BLOCKS level;
  final String text;
  final List<dynamic> content;
  final TextStyle textStyle;
  final Next next;

  Heading({
    @required this.text,
    this.level = BLOCKS.HEADING_1,
    this.content,
    this.textStyle,
    this.next,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: text ?? '',
                  children: next(content),
                  style: textStyle,
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
          Container(
            height: 20,
          )
        ],
      ),
    );
  }
}
