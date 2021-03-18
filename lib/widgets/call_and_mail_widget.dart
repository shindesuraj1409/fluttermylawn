import 'package:bus/bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/models/theme_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAndMailWidget extends StatelessWidget {
  final margin;
  final emailAddress;
  final phoneNumber;

  CallAndMailWidget(this.margin, this.phoneNumber, this.emailAddress);

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendMail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = busSnapshot<ThemeModel, ThemeData>().textTheme;

    return Container(
      width: double.infinity,
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => _makePhoneCall('tel:+$phoneNumber'),
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/phone.png',
                  width: 24,
                  height: 24,
                  key: Key('phone_image'),
                ),
                Text(
                  phoneNumber,
                  style: textTheme.subtitle1.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          Container(height: 30.0, width: 1.0, color: Styleguide.color_gray_3),
          InkWell(
            onTap: () => _sendMail('mailto:$emailAddress?subject=&body='),
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/mail_gray.png',
                  width: 24,
                  height: 24,
                  key: Key('mail_image'),
                ),
                Text(
                  emailAddress,
                  style: textTheme.subtitle1.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
