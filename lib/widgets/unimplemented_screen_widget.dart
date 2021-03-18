import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

/// Implements a standardized screen for yet to be implemented screens.
/// This is a full screen with a scaffold and app bar.
@immutable
class UnimplementedScreen extends StatelessWidget {
  final Widget parent;
  final Widget child;

  UnimplementedScreen(
    this.parent, {
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = Colors.orange.shade100;
    final textColor = Colors.orange.shade900;

    return BasicScaffoldWithSliverAppBar(
      backgroundColor: backgroundColor,
      appBarBackgroundColor: backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Unimplemented Screen',
              textAlign: TextAlign.center,
              style: textTheme.headline1.copyWith(color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 64,
              ),
              child: Text(
                parent.runtimeType.toString(),
                textAlign: TextAlign.center,
                style: textTheme.headline2.copyWith(color: textColor),
              ),
            ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }
}
