import 'package:contentful_rich_text/types/types.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_list_item.dart';

class UnorderedList extends StatelessWidget {
  final double indent;
  final List<dynamic> children;
  final Next next;

  UnorderedList(this.children, this.next, {this.indent});

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[];
    children.forEach((child) {
      listItems.add(
        ListItem.unordered(
          text: child['value'],
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
