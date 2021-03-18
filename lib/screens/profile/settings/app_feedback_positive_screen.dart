import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFeedbackPositiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(flex: 1),
            Image.asset(
              'assets/icons/review_positive.png',
              width: 64,
              height: 64,
              key: Key('thankyou_image'),
            ),
            SizedBox(height: 24),
            Text(
              'Thank you!',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline1,
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Would you like to rate us and write a review in the app store?',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1.copyWith(height: 1.43),
              ),
            ),
            SizedBox(height: 32),
            RaisedButton(
              child: Text('GO TO APP STORE'),
              key: Key('go_to_app_store_button'),
              onPressed: () async {
                final didLaunch = await launch(
                  Platform.isIOS
                      ? 'itms-apps://itunes.apple.com/app/id372269879'
                      : 'market://details?id=com.scotts.lawnapp',
                );
                unawaited(
                  (didLaunch)
                      ? registry<Navigation>().popTo('/profile/settings')
                      : showBottomSheetDialog(
                          context: context,
                          title: const DialogTitle(
                              title: 'Unable to Open App Store'),
                          child: const DialogContent(
                            content: 'Please try again, '
                                'or open the app store manually.',
                          ),
                        ),
                );
              },
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
