import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFeedbackNegativeScreen extends StatelessWidget {
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
              'assets/icons/review_negative.png',
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
                'Would you like to contact customer support '
                'and tell us more about your experience?',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1.copyWith(height: 1.43),
              ),
            ),
            SizedBox(height: 32),
            RaisedButton(
              child: Text('CONTACT CUSTOMER SUPPORT'),
              key: Key('contact_customer_support_button'),
              onPressed: () async {
                const subject = 'App Feedback from My Lawn App';

                final uri = Uri.encodeFull(
                    'mailto:consumer.services@scotts.com?subject=$subject');

                if (await canLaunch(uri)) {
                  await launch(uri);
                } else {
                  final snackBar =
                      SnackBar(content: Text('Unable to send an email'));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
