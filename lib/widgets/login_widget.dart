import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/social_buttons_widgets.dart';

void buildLoginBottomCard(BuildContext context) {
  showBottomSheetDialog(
      hasDivider: true,
      trailing: TappableText(
        child: Text(
          'CANCEL',
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Theme.of(context).primaryColor),
          key: Key('welcome_screen_bottom_sheet_cancel_button'),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SocialButtons(
            appleSignInTapped: () =>
                registry<LoginBloc>().socialLogin(SocialService.APPLE),
            googleSignInTapped: () =>
                registry<LoginBloc>().socialLogin(SocialService.GOOGLE),
            facebookLoginTapped: () =>
                registry<LoginBloc>().socialLogin(SocialService.FB),
          ),
          SizedBox(
            height: 25,
          )
        ],
      ));
}
