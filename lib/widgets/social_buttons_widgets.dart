import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:navigation/navigation.dart';

class SocialButtons extends StatelessWidget {
  final bool isRegistered;
  final VoidCallback googleSignInTapped;
  final VoidCallback appleSignInTapped;
  final VoidCallback facebookLoginTapped;

  const SocialButtons({
    Key key,
    this.isRegistered = false,
    this.googleSignInTapped,
    this.appleSignInTapped,
    this.facebookLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (Platform.isIOS)
            _buildSocialButton(
              context: context,
              iconPath: 'assets/icons/apple_dark.png',
              buttonText: 'CONTINUE WITH APPLE',
              onTapped: () => appleSignInTapped(),
              key: 'social_button_continue_with_apple',
            ),
          _buildSocialButton(
              context: context,
              iconPath: 'assets/icons/google.png',
              buttonText: 'CONTINUE WITH GOOGLE',
              onTapped: () => googleSignInTapped(),
              key: 'social_button_continue_with_google'),
          _buildSocialButton(
              context: context,
              iconPath: 'assets/icons/facebook.png',
              buttonText: 'CONTINUE WITH FACEBOOK',
              onTapped: () => facebookLoginTapped(),
              key: 'social_button_continue_with_facebook'),
          _buildSocialButton(
            context: context,
            iconPath: 'assets/icons/mail.png',
            buttonText: 'CONTINUE WITH EMAIL',
            onTapped: () {
              //TODO Navigator.dart:37 - currentRouteName not getting reset on <Navigation>.pop()
              registry<Navigation>()
                  .navigatorKey
                  .currentState
                  .pushNamed('/auth/enteremail');
            },
            key: 'continue_with_email_button',
            isTransparentBorder: true,
            iconWidth: 24,
            iconHeight: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    BuildContext context,
    String iconPath,
    String buttonText,
    Function onTapped,
    bool isTransparentBorder = false,
    double iconWidth = 20,
    double iconHeight = 20,
    String key,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 56,
      child: OutlineButton(
        key: Key(key),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: constraints.maxWidth / 12,
                ),
                Image.asset(
                  iconPath,
                  width: iconWidth,
                  height: iconHeight,
                  key: Key('social_button_logo'),
                ),
                SizedBox(
                  width: constraints.maxWidth / 12,
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      buttonText,
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth / 12,
                ),
              ],
            );
          },
        ),
        borderSide: BorderSide(
          color: isTransparentBorder ? Colors.transparent : theme.primaryColor,
        ),
        highlightedBorderColor:
            isTransparentBorder ? Colors.transparent : theme.primaryColor,
        onPressed: onTapped,
      ),
    );
  }
}
