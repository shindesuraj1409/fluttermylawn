import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:pedantic/pedantic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  StoreCard({this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    store.distanceMi.toString(),
                    style: theme.textTheme.headline5.copyWith(
                      height:
                          1.5, // Just adding line height here so that it aligns wells with store name field which has lineheight of "1.5"
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'mi',
                    style: theme.textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.w600,
                      height:
                          1.5, // Just adding line height here so that it aligns wells with store name field which has lineheight of "1.5"
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    store.name,
                    style: theme.textTheme.subtitle1.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    store.address,
                    style: theme.textTheme.caption.copyWith(
                      height: 1.36,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (store.latitude != null && store.longitude != null)
                    IconButton(
                      key: Key(
                          'location_icon_of_${store.name.removeNonCharsMakeLowerCaseMethod()}'),
                      icon: Image.asset(
                        'assets/icons/location_marker.png',
                        width: 32,
                        height: 32,
                      ),
                      onPressed: () => _showMapDialog(context, store),
                    ),
                  if (store.phone != null && store.phone.isNotEmpty)
                    IconButton(
                      key: Key(
                          'phone_icon_of_${store.name.removeNonCharsMakeLowerCaseMethod()}'),
                      icon: Image.asset(
                        'assets/icons/phone.png',
                        width: 32,
                        height: 32,
                      ),
                      onPressed: () => _showPhoneDialog(context, store.phone),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _showMapDialog(BuildContext context, Store store) async {
  // iOS
  if (Platform.isIOS) {
    final googleMapsUri = Uri(
      scheme: 'comgooglemaps',
      queryParameters: {
        'center': '${store.latitude},${store.longitude}',
        'q': '${store.name}',
      },
    );

    final appleMapsUri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      queryParameters: {
        'll': '${store.latitude},${store.longitude}',
        'q': '${store.name}',
      },
    );

    final canLaunchGoogleMaps = await canLaunch(googleMapsUri.toString());
    final canLaunchAppleMaps = await canLaunch(appleMapsUri.toString());
    final canLaunchBoth = canLaunchGoogleMaps && canLaunchAppleMaps;

    if (canLaunchBoth) {
      unawaited(
        showBottomSheetDialog(
          context: context,
          title: const DialogTitle(title: 'Open Maps'),
          child: DialogContent(
            actions: [
              RaisedButton(
                child: Text('GOOGLE MAPS'),
                onPressed: () => launch(googleMapsUri.toString()),
              ),
              FlatButton(
                child: Text('APPLE MAPS'),
                onPressed: () => launch(
                  appleMapsUri.toString(),
                ),
              ),
            ],
          ),
          trailingPositioned: const DialogCancelIcon(),
        ),
      );
    } else if (canLaunchGoogleMaps) {
      await launch(googleMapsUri.toString());
    } else if (canLaunchAppleMaps) {
      await launch(appleMapsUri.toString());
    }
  }

  // Android
  else {
    final googleMapsUri = Uri(
      scheme: 'geo',
      path: '${store.latitude},${store.longitude}',
      queryParameters: {'q': '${store.name}'},
    );
    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    }
  }
}

void _showPhoneDialog(BuildContext context, String phoneNumber) async {
  final telephoneUri = Uri(
    scheme: 'tel',
    path: '+1$phoneNumber',
  );

  unawaited(
    showDialog(
      context: context,
      builder: (_) => PlatformAwareAlertDialog(
        title: Text('Call Store'),
        content: Text(phoneNumber),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          FlatButton(
            onPressed: () async {
              if (await canLaunch(telephoneUri.toString())) {
                await launch(telephoneUri.toString());
              } else {
                Navigator.pop(context);
              }
            },
            child: Text('CALL'),
          )
        ],
      ),
    ),
  );
}
