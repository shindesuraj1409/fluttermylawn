import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/text_with_optional_actions_widget.dart';
import 'package:pedantic/pedantic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

const orderSupportEmail = 'scotts-orders@scotts.com';
const customerSupportContact = '1-877-220-3091';

Future<void> showAddressValidationFailureDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  AddressData address,
}) async {
  final theme = Theme.of(context);

  await showBottomSheetDialog(
    context: context,
    title: Expanded(
      child: Text(
        title,
        style: theme.textTheme.headline2,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 32),
      child: Column(
        children: [
          TextWithOptionalActions(
            style: theme.textTheme.subtitle2,
            actionStyle: theme.textTheme.subtitle2.copyWith(
              color: theme.colorScheme.primaryVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
            children: [
              content,
              [
                ' $orderSupportEmail',
                () async {
                  await _sendAddressValidationFailureEmail(
                    title,
                    address,
                    orderSupportEmail,
                  );
                }
              ],
              ' or call us at ',
              [
                '$customerSupportContact',
                () async {
                  await _callCustomerSupport(customerSupportContact);
                }
              ]
            ],
          ),
          SizedBox(height: 16),
          FractionallySizedBox(
            widthFactor: 1,
            child: RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('UPDATE ADDRESS'),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _sendAddressValidationFailureEmail(
  String subjectText,
  AddressData address,
  String orderSupportEmail,
) async {
  final subject = '$subjectText Error'.sanitizeTextForEmail;
  String body;
  if (address != null) {
    body = '''
Address Information:
Street Address : ${address.address1} 
Apartment/Suite/Other : ${address?.address2 ?? ''} 
City : ${address.city} 
State : ${address.state} 
Zip : ${address.zip}
'''
        .sanitizeTextForEmail;
  } else {
    body = '';
  }

  final uri =
      Uri.encodeFull('mailto:$orderSupportEmail?subject=$subject&body=$body');

  try {
    if (await canLaunch(uri)) {
      await launch(uri);
    }
  } catch (e) {
    unawaited(FirebaseCrashlytics.instance.recordError(
      e,
      StackTrace.current,
      reason:
          'Unable to launch app to send email from address validation failure dialog',
    ));
  }
}

Future<void> _callCustomerSupport(String customerSupportContact) async {
  final uri = 'tel:$customerSupportContact';

  try {
    if (await canLaunch(uri)) {
      await launch(uri);
    }
  } catch (e) {
    unawaited(FirebaseCrashlytics.instance.recordError(
      e,
      StackTrace.current,
      reason:
          'Unable to launch app to contact customer support from address validation failure dialog',
    ));
  }
}
