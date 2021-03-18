import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';

class FaqParagraph extends StatelessWidget {
  final dynamic node;
  final Next next;

  FaqParagraph(this.node, this.next);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.3),
        children: [
          TextSpan(
            children: next(node['content']),
          ),
        ],
      ),
    );
  }
}
