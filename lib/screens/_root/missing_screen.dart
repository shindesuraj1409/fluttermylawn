import 'package:flutter/material.dart';
import 'package:my_lawn/extensions/route_arguments_extension.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class MissingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = Colors.red.shade100;
    final textColor = Colors.red.shade900;

    return BasicScaffoldWithSliverAppBar(
      backgroundColor: backgroundColor,
      appBarBackgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Missing Screen',
            textAlign: TextAlign.center,
            style: textTheme.headline1.copyWith(color: textColor),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 64,
            ),
            child: Text(
              routeName(context),
              textAlign: TextAlign.center,
              style: textTheme.headline2.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
