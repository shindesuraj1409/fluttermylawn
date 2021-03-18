import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  final dynamic node;
  final Next next;

  Paragraph(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.subtitle1,
          children: [
            TextSpan(
              children: next(node['content']),
            ),
          ],
        ),
      ),
    );
  }
}
