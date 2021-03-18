import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ForcedUpdateScreen extends StatelessWidget {
  final String message;

  ForcedUpdateScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/grass_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AlertDialog(
          title: Text(
            'My Lawn Needs to be Updated',
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.5),
          ),
          actions: [
            FlatButton(
              child: Text('UPDATE'),
              onPressed: () => launch(
                Platform.isIOS
                    ? 'itms-apps://itunes.apple.com/app/id372269879'
                    : 'market://details?id=com.scotts.lawnapp',
              ),
            )
          ],
          insetPadding: EdgeInsets.all(48),
          titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          actionsPadding: EdgeInsets.symmetric(horizontal: 8),
          elevation: 8,
        ),
      ),
    );
  }
}
