import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class LinkSocialAccountScreen extends StatefulWidget {
  @override
  _LinkSocialAccountScreenState createState() =>
      _LinkSocialAccountScreenState();
}

class _LinkSocialAccountScreenState extends State<LinkSocialAccountScreen>
    with RouteMixin<LinkSocialAccountScreen, String> {
  Widget _buildSocialButton(
    BuildContext context,
    String iconPath,
    String buttonName,
    bool borderTransparent,
    Function onTapped,
  ) {
    final _theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 56,
      child: OutlineButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              iconPath,
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              buttonName,
            ),
          ],
        ),
        borderSide: BorderSide(
          color: borderTransparent ? Colors.transparent : _theme.primaryColor,
        ),
        highlightedBorderColor:
            borderTransparent ? Colors.transparent : _theme.primaryColor,
        onPressed: onTapped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      appBarElevation: 0,
      leading: BackButton(
        color: _theme.colorScheme.onBackground,
        onPressed: () => registry<Navigation>().pop(),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 48,
            ),
            Text(
              'This Email Looks Familiar',
              style: _theme.textTheme.headline1,
            ),
            SizedBox(height: 16),
            Text(
              'You’ve previously logged in via [Google] account. Would you like to continue with [Google]?',
              style: _theme.textTheme.subtitle2,
            ),
            SizedBox(height: 160),
            _buildSocialButton(
              context,
              'assets/icons/google.png',
              'Continue with Google'.toUpperCase(),
              false,
              () {},
            ),
            _buildSocialButton(
              context,
              'assets/icons/mail.png',
              'Continue with Email'.toUpperCase(),
              true,
              () {
                registry<Navigation>().push(
                  '/auth/enteremail',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
