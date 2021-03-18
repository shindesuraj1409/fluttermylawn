import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> items;
  final TextStyle style;
  final Widget bullet;
  final EdgeInsets bulletMargin;

  const BulletList(
    this.items, {
    this.bullet,
    this.bulletMargin,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    /*
      ListView automatically adds padding so need to wrap in MediaQuery.removePadding with removeTop: true
      https://github.com/flutter/flutter/issues/14842
     */
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        padding: null,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: bulletMargin,
                child: bullet ??
                    Container(
                      width: 2,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
              ),
              Expanded(
                child: Text(
                  '${items[index]}',
                  style: style,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
