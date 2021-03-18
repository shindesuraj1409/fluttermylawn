import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/edit_lawn_profile/edit_lawn_profile_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_condition_screen_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/extensions/address_data_extension.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/widgets/have_moved_bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class EditLawnProfileScreen extends StatefulWidget {
  @override
  _EditLawnProfileScreenState createState() => _EditLawnProfileScreenState();
}

class _EditLawnProfileScreenState extends State<EditLawnProfileScreen> {
  EditLawnProfileBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = registry<EditLawnProfileBloc>();
  }

  Widget _buildLink(
    Key key,
    Key key_value,
    BuildContext context, {
    String imageUrl,
    String imageAsset,
    IconData iconData,
    String title,
    String description,
    Widget child,
    VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title,
                      style: theme.textTheme.caption.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                      key: Key(title
                              .toLowerCase()
                              .replaceAll(RegExp(r'\s+'), '_')
                              .replaceAll("'", '') +
                          '_label'),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (imageUrl != null ||
                          imageAsset != null ||
                          iconData != null)
                        Padding(
                          padding: EdgeInsets.only(
                              right: imageUrl != null || imageAsset != null
                                  ? 16
                                  : 20),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 48,
                                  height: 48,
                                )
                              : imageAsset != null
                                  ? Image.asset(
                                      imageAsset,
                                      width: 48,
                                      height: 48,
                                    )
                                  : Icon(
                                      iconData,
                                      size: 40,
                                      color: theme.primaryColor,
                                    ),
                        ),
                      Expanded(
                        child: (description != null)
                            ? Text(
                                description,
                                key: key_value,
                                style: theme.textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : child,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: theme.textTheme.bodyText2.color,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLawnCondition(BuildContext context, LawnData lawnData) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
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
                style: textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
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
                style: textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
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
              Text(lawnData.weeds.string,
                  key: Key('weeds_value'),
                  style: textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLawnAddressAndSizeLink(
    BuildContext context,
    LawnData lawnData,
  ) {
    final theme = Theme.of(context);
    final hasSubscription =
        registry<SubscriptionBloc>().state.status.hasSubscriptionData;

    return hasSubscription
        ? [
            _buildLink(
              Key('lawn_address'),
              Key('lawn_address_value'),
              context,
              title: 'Lawn Address',
              description:
                  lawnData.lawnAddress.getFormattedAddressForLawnProfile(),
              onTap: () => buildIHaveMovedBottomDialog(context, theme),
            ),
            Divider(),
            _buildLink(
              Key('lawn_size'),
              Key('lawn_size_value'),
              context,
              title: 'Lawn Size',
              description: '${lawnData.lawnSqFt} sqft',
              onTap: () {
                _bloc.editLawnProfile(
                  screenPath: '/quiz/lawnsizezipcode',
                  lawnData: lawnData,
                );
              },
            )
          ]
        : [
            InkWell(
              onTap: () {
                _bloc.editLawnProfile(
                  screenPath: '/quiz/lawnaddress',
                  lawnData: lawnData,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Lawn Address',
                                  key: Key('lawn_address'),
                                  style: theme.textTheme.caption.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    lawnData.lawnAddress
                                        .getFormattedAddressForLawnProfile(),
                                    key: Key('lawn_address_value'),
                                    style: theme.textTheme.subtitle2.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Lawn Size',
                                  key: Key('lawn_size'),
                                  style: theme.textTheme.caption.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${lawnData.lawnSqFt} sqft',
                                    key: Key('lawn_size_value'),
                                    style: theme.textTheme.subtitle2.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 24,
                      color: theme.textTheme.bodyText2.color,
                    )
                  ],
                ),
              ),
            )
          ];
  }

  Widget _buildLawnProfile(
    BuildContext context,
    LawnData lawnData,
  ) =>
      BlocConsumer<EditLawnProfileBloc, EditLawnProfileState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is EditLawnProfileStateSuccess) {
            if (state.lawnData != null) {
              registry<AuthenticationBloc>().add(UserUpdated());
              registry<QuizModel>().setAnswers(state.lawnData);
              registry<Navigation>().setRoot(
                '/quiz/submit',
                rootName: '/profile/editlawn',
              );
            }
          } else if (state is EditLawnProfileStateError) {
            showSnackbar(
                context: context,
                text: state.errorMessage,
                duration: Duration(seconds: 2));
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLink(
                    Key('grass_type'),
                    Key('grass_type_value'),
                    context,
                    title: 'Grass Type',
                    description: lawnData.grassTypeNameString,
                    imageUrl: lawnData.grassType == LawnData.unknownGrassType
                        ? null
                        : lawnData.grassTypeImageUrl,
                    imageAsset: 'assets/icons/unknown_grass.png',
                    onTap: () {
                      _bloc.editLawnProfile(
                        screenPath: '/quiz/grasstype',
                        lawnData: lawnData,
                      );
                    },
                  ),
                  Divider(),
                  ..._buildLawnAddressAndSizeLink(context, lawnData),
                  Divider(),
                  _buildLink(
                    Key('spreader_type'),
                    Key('spreader_type_value'),
                    context,
                    title: 'Spreader Type',
                    description: lawnData.spreader.string,
                    onTap: () {
                      _bloc.editLawnProfile(
                        screenPath: '/quiz/spreadertype',
                        lawnData: lawnData,
                      );
                    },
                  ),
                  Divider(),
                  _buildLink(
                    Key('lawn_condition'),
                    Key('lawn_condition_value'),
                    context,
                    title: 'Lawn Condition',
                    child: _buildLawnCondition(context, lawnData),
                    onTap: () {
                      _bloc.editLawnProfile(
                        screenPath: '/quiz/lawncondition',
                        lawnData: LawnConditionScreenData(lawnData: lawnData),
                      );
                    },
                  ),
                ],
              ),
              if (state is EditLawnProfileStateLoading)
                ProgressSpinner(
                  size: 40,
                ),
            ],
          );
        },
      );

  Widget _buildLawnQuizButton(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Completely different lawn?',
              style: theme.textTheme.subtitle2,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: OutlineButton(
              key: Key('retake_lawn_quiz'),
              borderSide: BorderSide(color: theme.primaryColor),
              child: Text('RETAKE LAWN QUIZ'),
              onPressed: () => registry<Navigation>().push('/quiz'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, LawnData lawnData) {
    final theme = Theme.of(context);
    final hasSubscription =
        registry<SubscriptionBloc>().state.status.hasSubscriptionData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hasSubscription
                ? 'Changing lawn conditions might result in getting products different from your current subscription.'
                : 'Changing lawn conditions might result in getting different lawn product recommendations.',
            style: theme.textTheme.subtitle2.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      titleString: 'Edit Lawn Profile',
      childFillsRemainingSpace: false,
      appBarElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          key: Key('close_icon'),
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () => registry<Navigation>().pop(),
      ),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        cubit: registry<AuthenticationBloc>(),
        builder: (context, state) {
          final lawnData = state.lawnData;
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, lawnData),
              _buildLawnProfile(context, lawnData),
              _buildLawnQuizButton(context),
            ],
          );
        },
      ),
    );
  }
}
