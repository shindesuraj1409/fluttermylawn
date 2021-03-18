// ML.SC.019: Profile Overview Screen
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/extensions/address_data_extension.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_scotts_account_screen/state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/profile_screen/state.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isGuestUser;

  SubscriptionBloc _bloc;
  User _user;

  @override
  void initState() {
    super.initState();
    _isGuestUser = registry<AuthenticationBloc>().state.isGuest;
    _user = registry<AuthenticationBloc>().state.user;

    _bloc = registry<SubscriptionBloc>();
    _bloc.add(FindSubscription(_user.customerId));

    adobeAnalyticStateCall(LawnProfileAdobeState());
  }

  void adobeAnalyticStateCall(AdobeAnalyticState state) {
    registry<AdobeRepository>().trackAppState(
      state,
    );
  }

  void _showEditLawnConfirmationDialog() {
    showBottomSheetDialog(
      context: context,
      trailingPositioned: Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: Image.asset(
            'assets/icons/cancel.png',
            key: Key('cancel_button'),
            height: 24,
            width: 24,
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      title: Flexible(
        child: Text(
          'Edit your lawn profile?',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      child: DialogContent(
        content:
            'Changing lawn conditions might result in getting products different from your current subscription',
        actions: [
          SizedBox(
            height: 48,
          ),
          RaisedButton(
            key: Key('edit_anyway_button'),
            child: Text('EDIT ANYWAY'),
            onPressed: () {
              Navigator.pop(context);
              _takeToEditLawnProfileScreen();
            },
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  void _takeToEditLawnProfileScreen() {
    registry<AdobeRepository>().trackAppState(EditLawnProfileAdobeState());
    registry<Navigation>().push('/profile/editlawn');
  }

  Widget _buildLawnProfile(BuildContext context, LawnData lawnData) {
    final imageSize = 84.0;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lawnData?.grassType == LawnData.unknownGrassType)
                Image.asset(
                  'assets/icons/unknown_grass.png',
                  width: imageSize,
                  height: imageSize,
                  key: Key('grass_type_image'),
                )
              else
                FadeInImage.assetNetwork(
                  placeholder: 'assets/icons/unknown_grass.png',
                  image: lawnData?.grassTypeImageUrl ?? '',
                  width: imageSize,
                  height: imageSize,
                  imageErrorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/icons/unknown_grass.png',
                      width: imageSize,
                      height: imageSize,
                    );
                  },
                  key: Key('grass_type_image'),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8, right: 8),
                  child: _buildGrassType(context, lawnData),
                ),
              ),
              BlocBuilder<SubscriptionBloc, SubscriptionState>(
                  cubit: _bloc,
                  builder: (context, state) {
                    return !state.status.isLoading
                        ? TextButton(
                            child: Text('EDIT'),
                            onPressed: () {
                              if (state.status.hasSubscriptionData) {
                                _showEditLawnConfirmationDialog();
                              } else {
                                _takeToEditLawnProfileScreen();
                              }
                            },
                            key: Key('edit_button'),
                          )
                        : Container();
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrassType(BuildContext context, LawnData lawnData) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            lawnData.grassTypeNameString,
            style: textTheme.subtitle2.copyWith(fontWeight: FontWeight.w600),
            key: Key('grass_name_label'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            '${lawnData.lawnSqFt} sqft',
            style: textTheme.bodyText2,
            key: Key('lawn_size_value'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            lawnData.lawnAddress.getFormattedAddressForLawnProfile(),
            style: textTheme.bodyText2,
            key: Key('zip_code'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            'Spreader type: ${lawnData.spreader.shortString}',
            style: textTheme.bodyText2,
            key: Key('spreader_type_label'),
          ),
        ),
      ],
    );
  }

  Widget _buildGrassQuality(BuildContext context, LawnData lawnData) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Thickness',
                      style: textTheme.bodyText2,
                    ),
                  ),
                  Text(
                    lawnData.thickness.string,
                    key: Key('thickness_value'),
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: VerticalDivider(color: Styleguide.color_gray_1),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Color',
                      style: textTheme.bodyText2,
                    ),
                  ),
                  Text(
                    lawnData.color.string,
                    key: Key('color_value'),
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: VerticalDivider(color: Styleguide.color_gray_1),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Weeds',
                      style: textTheme.bodyText2,
                    ),
                  ),
                  Text(
                    lawnData.weeds.string,
                    key: Key('weeds_value'),
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
                height: 160,
                child: Card(
                  child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                    cubit: _bloc,
                    builder: (context, state) {
                      if (state.status.isLoading) {
                        return Center(child: ProgressSpinner());
                      } else {
                        return InkWell(
                          key: Key(state.status.hasSubscriptionData
                              ? 'my_subscription'
                              : 'get_products_delivered'),
                          onTap: () {
                            if (state.status.hasSubscriptionData) {
                              registry<Navigation>()
                                  .push('/profile/subscription');
                            } else {
                              registry<Navigation>().push(
                                  '/subscription/options',
                                  arguments: _user.recommendationId);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/icons/subscription.png',
                                  width: 64,
                                  height: 64,
                                  color: theme.primaryColor,
                                ),
                                Text(
                                  state.status.hasSubscriptionData
                                      ? 'My Subscription'
                                      : 'Get Products Delivered',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.subtitle2,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )),
          ),
          Container(width: 8),
          if (!_isGuestUser)
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 160,
                child: Card(
                  child: InkWell(
                    key: Key('my_scotts_account'),
                    onTap: () {
                      adobeAnalyticStateCall(MyScottsAccountScreenAdobeState());

                      registry<Navigation>().push('/account');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/icons/account.png',
                            width: 64,
                            height: 64,
                            color: theme.primaryColor,
                          ),
                          Text(
                            'My Scotts Account',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Container(width: 8),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 160,
              child: Card(
                child: InkWell(
                  key: Key('app_settings'),
                  onTap: () => registry<Navigation>().push('/profile/settings'),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/app_settings.png',
                          width: 64,
                          height: 64,
                          color: theme.primaryColor,
                        ),
                        Text(
                          'App Settings',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isGuestUser)
            Spacer(
              flex: 1,
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      titleString: 'Profile',
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        cubit: registry<AuthenticationBloc>(),
        listenWhen: (prev, current) {
          return prev.isGuest && current.isLogggedIn;
        },
        listener: (context, current) {
          registry<Navigation>().setRoot('/home');
        },
        child: BlocConsumer<LoginBloc, LoginState>(
          cubit: registry<LoginBloc>(),
          listener: (context, state) {
            if (state is LoginSuccessState) {
              registry<AuthenticationBloc>().add(LoginRequested());
            } else if (state is PendingRegistrationState) {
              registry<Navigation>().push(
                '/auth/pendingregistration',
                arguments: {'email': state.email, 'regToken': state.regToken},
              );
            } else if (state is LoginErrorState) {
              showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  color: Styleguide.color_gray_1,
                  child: Column(
                    children: [
                      Container(
                        color: theme.colorScheme.background,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: BlocConsumer<AuthenticationBloc,
                            AuthenticationState>(
                          cubit: registry<AuthenticationBloc>(),
                          listener: (context, state) {
                            _isGuestUser = state.isGuest;
                          },
                          builder: (context, state) {
                            assert(state.lawnData != null);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLawnProfile(context, state.lawnData),
                                _buildGrassQuality(context, state.lawnData),
                              ],
                            );
                          },
                        ),
                      ),
                      _buildButtons(context),
                    ],
                  ),
                ),
                if (state is LoginLoadingState)
                  Center(
                    child: ProgressSpinner(size: 40),
                  )
              ],
            );
          },
        ),
      ),
      bottom: _isGuestUser ? _GetStartedButton() : null,
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Styleguide.color_gray_1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create an account to unlock all the great features!',
            style: theme.textTheme.subtitle2,
            textAlign: TextAlign.center,
          ),
          Container(
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: RaisedButton(
                  key: Key('get_started'),
                  onPressed: () => buildLoginBottomCard(context),
                  child: Text(
                    'GET STARTED',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
