import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/services/analytic/resources.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:my_lawn/extensions/user_extension.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountBloc _bloc;
  bool isChildScreenCalled = false;
  final _subscriptionBloc = registry<SubscriptionBloc>();

  @override
  void initState() {
    super.initState();

    _bloc = registry<AccountBloc>();
  }

  Widget _buildSectionHeader(BuildContext context, [String headerTitle = '']) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Text(
          headerTitle.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ),
      );

  Widget _buildGraySpacer(BuildContext context, {Widget child}) => Container(
        color: Styleguide.nearBackground(Theme.of(context)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: child ?? Container(),
        ),
      );

  void _updateAdobeUserProfileRepository(String attribute, bool value) {
    registry<AdobeUserProfileRepository>()
        .updateUserAttribute(attribute, value);
  }

  Widget _buildSwitch({
    BuildContext context,
    String imageName,
    IconData iconData,
    String description,
    bool value,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BlocConsumer<AccountBloc, AccountState>(
      cubit: _bloc,
      listenWhen: (previous, current) {
        return !isChildScreenCalled;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (imageName != null || iconData != null)
                Padding(
                  padding: EdgeInsets.only(right: imageName != null ? 16 : 20),
                  child: imageName != null
                      ? Image.asset(
                          imageName,
                          width: 24,
                          height: 24,
                          color: theme.primaryColor,
                          key: Key('subscribe_icon'),
                        )
                      : Icon(
                          iconData,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                ),
              Expanded(child: Text(description, style: textTheme.subtitle2)),
              Switch(
                key: Key('subscribe_to_scotts_emails'),
                value: value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (enabled) {
                  enabled
                      ? showBottomSheetDialog(
                          context: context,
                          title: const DialogTitle(
                            key: Key('subscribe_to_scotts_emails'),
                            title: 'Subscribe to Scotts Emails',
                          ),
                          child: DialogContent(
                            content:
                                'By opting in, you are signing up to receive emails marketed '
                                'by Scotts Miracle-Gro, its affiliates, and select partners '
                                'with related tips, information, and promotions.',
                            actions: [
                              RaisedButton(
                                key: Key('subscribe_button'),
                                child: Text('SUBSCRIBE'),
                                onPressed: () {
                                  _bloc.subscribeToNewsLetter();
                                  _updateAdobeUserProfileRepository(
                                      emailSubscribedAttributeStr, enabled);
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: FlatButton(
                                  key: Key('go_back'),
                                  child: Text('GO BACK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : () {
                          _bloc.updateAccount(isNewsletterSubscribed: false);

                          _updateAdobeUserProfileRepository(
                              emailSubscribedAttributeStr, enabled);
                        }();
                },
              ),
            ],
          ),
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case AccountStatus.success:
            registry<AuthenticationBloc>().add(UserUpdated());
            showSnackbar(
                context: context,
                text: state.successMessage,
                duration: Duration(seconds: 2));
            break;
          case AccountStatus.error:
            showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2));
            break;
          default:
            break;
        }
      },
    );
  }

  Widget _buildLink({
    BuildContext context,
    String imageName,
    IconData iconData,
    String label,
    String description,
    String route,
    VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(label, style: textTheme.caption),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (imageName != null || iconData != null)
                      Padding(
                        padding:
                            EdgeInsets.only(right: imageName != null ? 16 : 20),
                        child: imageName != null
                            ? Image.asset(
                                imageName,
                                width: 24,
                                height: 24,
                                color: theme.primaryColor,
                                key: Key('create_new_pass_icon'),
                              )
                            : Icon(
                                iconData,
                                size: 20,
                                color: theme.primaryColor,
                              ),
                      ),
                    Text(description,
                        style: textTheme.subtitle2,
                        key: Key((label != null)
                            ? label.removeNonCharsMakeLowerCaseMethod(
                                identifier: '_input')
                            : description.removeNonCharsMakeLowerCaseMethod(
                                identifier: '_input'))),
                  ],
                  key: Key((label != null)
                      ? label.removeNonCharsMakeLowerCaseMethod(
                          identifier: '_row')
                      : description.removeNonCharsMakeLowerCaseMethod(
                          identifier: '_row')),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: textTheme.bodyText2.color,
              key: Key((label != null)
                  ? label.removeNonCharsMakeLowerCaseMethod(identifier: '_icon')
                  : description.removeNonCharsMakeLowerCaseMethod(
                      identifier: '_icon')),
            ),
          ],
        ),
      ),
      onTap: onTap ??
          () {
            isChildScreenCalled = true;
            registry<Navigation>().push(route, arguments: _bloc).then((value) {
              if (value != null) {
                showSnackbar(
                    context: context,
                    text: value,
                    duration: Duration(seconds: 2));
              }
              isChildScreenCalled = false;
            });
          },
    );
  }

  Widget _buildLogoutButton(BuildContext context) => Center(
        child: FlatButton(
          key: Key('logout_button'),
          child: Text('LOG OUT'),
          onPressed: () => showBottomSheetDialog(
            context: context,
            title: const DialogTitle(title: 'Log Out?'),
            child: DialogContent(
              content:
                  'You\'ll need to log in again, to retrieve your lawn information.',
              actions: [
                RaisedButton(
                    key: Key('drawer_logout_button'),
                    child: Text('LOG OUT'),
                    onPressed: () {
                      registry<AuthenticationBloc>().add(LogoutRequested());
                      _subscriptionBloc.add(SubscriptionUpdated([]));
                      unawaited(
                          FirebaseCrashlytics.instance.setUserIdentifier(''));
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: FlatButton(
                    key: Key('go_back_button'),
                    child: Text('GO BACK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      titleString: 'My Scotts Account',
      child: BlocBuilder<AccountBloc, AccountState>(
        cubit: _bloc,
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context),
                  _buildLink(
                    context: context,
                    label: 'Name',
                    description: state.user.fullName,
                    route: '/account/name',
                  ),
                  Divider(),
                  _buildLink(
                    context: context,
                    label: 'Email',
                    description: state.user.email,
                    route: '/account/email',
                  ),
                  Divider(),
                  _buildGraySpacer(context),
                  _buildSwitch(
                    context: context,
                    imageName: 'assets/icons/mail.png',
                    description: 'Subscribe to Scotts Emails',
                    value: state.user.isNewsletterSubscribed ?? false,
                  ),
                  Divider(),
                  _buildLink(
                    context: context,
                    imageName: 'assets/icons/lock.png',
                    description: 'Create New Password',
                    route: '/account/password',
                  ),
                  Divider(),
                  _buildGraySpacer(context),
                  Divider(),
                  _buildLogoutButton(context),
                  Divider(),
                  Expanded(
                    child: _buildGraySpacer(context),
                  ),
                ],
              ),
              if (state.status == AccountStatus.loading)
                Container(
                  child: Center(
                    child: ProgressSpinner(),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
