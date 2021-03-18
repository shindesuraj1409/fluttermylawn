import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:url_launcher/url_launcher.dart';

void showLawnSizeLimitErrorDialog({
  @required BuildContext context,
  @required String errorMessage,
  Function onUpdateLawnSize,
}) {
  final theme = Theme.of(context);

  showBottomSheetDialog(
    context: context,
    hasTopPadding: false,
    trailing: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Image.asset(
        'assets/icons/close.png',
        width: 24,
        height: 24,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Large Lawn Size',
            style: theme.textTheme.headline2,
          ),
          SizedBox(height: 12),
          Text(
            errorMessage,
            style: theme.textTheme.subtitle2,
          ),
          SizedBox(height: 8),
          RaisedButton(
            onPressed: () {
              if (onUpdateLawnSize != null) onUpdateLawnSize();
              Navigator.pop(context);
            },
            child: Text('ENTER A SMALLER LAWN SIZE'),
          ),
          SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactUsDialog(context);
            },
            child: Text('CONTACT US'),
          ),
        ],
      ),
    ),
  );
}

void _showContactUsDialog(BuildContext context) {
  final theme = Theme.of(context);
  final emailAddress = 'consumer.services@scotts.com';
  final phoneNumber = '1-866-882-0846';

  showBottomSheetDialog(
    context: context,
    hasTopPadding: false,
    trailing: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Image.asset(
        'assets/icons/close.png',
        width: 24,
        height: 24,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Contact Us', style: theme.textTheme.headline2),
          SizedBox(height: 16),
          RaisedButton(
            onPressed: () => _makePhoneCall('tel:+$phoneNumber'),
            child: Text('CALL US'),
          ),
          SizedBox(height: 12),
          OutlineButton(
            onPressed: () => _sendMail('mailto:$emailAddress?subject=&body='),
            child: Text('EMAIL US'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

Future<void> _sendMail(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
