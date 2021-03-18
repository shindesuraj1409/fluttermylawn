import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class KillSwitchScreen extends StatelessWidget {
  final String message;

  KillSwitchScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 48, 48, 96),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/kill_switch.png',
              width: 160,
              height: 160,
            ),
            SizedBox(height: 32),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline4.copyWith(height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}
