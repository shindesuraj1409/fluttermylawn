import 'package:flutter/material.dart';

enum LI_TYPE { UNORDERED, ORDERED }

class ListItem extends StatelessWidget {
  final LI_TYPE type;
  final double indent;
  final String text;
  final String punctuation;
  final String index;
  final List<Widget> children;

  ListItem({
    @required this.type,
    @required this.text,
    this.index,
    this.indent,
    this.punctuation,
    this.children,
  });

  ListItem.unordered({
    this.type = LI_TYPE.UNORDERED,
    @required this.text,
    this.index,
    this.indent,
    this.punctuation,
    this.children,
  });

  ListItem.ordered({
    this.type = LI_TYPE.ORDERED,
    @required this.text,
    @required this.index,
    this.indent,
    this.punctuation = '.',
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LI_TYPE.UNORDERED:
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                width: 12,
                height: 20,
                child: Image.asset(
                  'assets/icons/bullet_point.png',
                  height: 12,
                  width: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: text != null
                        ? Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                            ),
                            child: Text(
                              text,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: children ?? [],
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      case LI_TYPE.ORDERED:
        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: 16,
                    child: Text(
                      '$index$punctuation',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: text != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(text),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: children ?? [],
                          ),
                  ),
                ],
              ),
            )
          ],
        );
    }
    return Container();
  }
}
