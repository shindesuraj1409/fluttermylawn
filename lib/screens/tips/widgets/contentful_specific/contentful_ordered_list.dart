import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_list_item.dart';

class OrderedList extends StatelessWidget {
  final double indent;
  final String punctuation;
  final Next next;

  /// index character, text for item
  final List<dynamic> children;

  OrderedList(this.children, this.next, {this.indent, this.punctuation = '.'});

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[];
    children.forEach((child) {
      listItems.add(
        ListItem.ordered(
          indent: indent,
          text: child['value'],
          index: (children.indexOf(child) + 1).toString(),
          children: <Widget>[
            next(child['content'])
          ], // TODO: Implement nested lists
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: listItems,
      ),
    );
  }
}
