import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_event.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_state.dart';
import 'package:my_lawn/blocs/single_product/single_product_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/learn_more_event.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/product_applied_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/learn_more_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/product_events.dart';
import 'package:my_lawn/services/analytic/actions/localytics/remind_me_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/subscribe_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PDP_screen/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/home_screen/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/utils/regex_util.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/circular_fab.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:my_lawn/widgets/dismissible_card_widget.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/icon_widget.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/product_image.dart';
import 'package:my_lawn/widgets/rainfall_track_widget/rainfall_track_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/plan_skeleton_loader.dart';
import 'package:my_lawn/widgets/subscription_card_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';

class PlanScreen extends StatefulWidget {
  final String deepLinkPath;

  const PlanScreen({Key key, this.deepLinkPath});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<PlanScreen> {
  ThemeData _theme;

  LawnData _lawnData;
  String _lawnName;
  final _lawnNameController = TextEditingController();
  int _lawnNameCharacterCount = 0;
  final _lawnNameCharacterLimit = 16;
  bool _lawnNameSaveIsDisabled = true;
  bool _remindMeNextYear = false;

  User _user;

  String _deepLinkPath;
  final _singleProductBloc = registry<SingleProductBloc>();

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant PlanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _deepLinkPath = widget.deepLinkPath;
    _lawnData = registry<AuthenticationBloc>().state.lawnData;
    _lawnName = _lawnData?.lawnName ?? 'My Lawn';
    _user = registry<AuthenticationBloc>().state.user;

    if (_deepLinkPath != null && _deepLinkPath.isNotEmpty) {
      _singleProductBloc.add(SingleProductLoad(
        category: '$_deepLinkPath',
        productId: 'drupalproductid',
      ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  void dispose() {
    _lawnNameController?.dispose();
    super.dispose();
  }

  Future<void> _tagDetailsEvent<T>() async {
    LocalyticsEvent event;
    final user = await registry<SessionManager>().getUser();
    final userType =
        user?.customerId != null ? UserType.LoggedIn : UserType.Guest;
    final zoneName = registry<QuizModel>().answers[QuestionType.lawnZone];

    if (T == LearnMoreEvent) {
      event = LearnMoreEvent(userType, zoneName);
    } else if (T == RemindMeEvent) {
      event = RemindMeEvent(userType, zoneName);
    } else if (T == SubscribeEvent) {
      event = SubscribeEvent(userType, zoneName);
    }

    await registry<LocalyticsService>().tagEvent(event);
  }

  void _tagSkipEvent(Product product, SkipReason reason) {
    final event = ProductSkippedEvent(
      productName: product.name,
      activityFrom: product.isAddedByMe ? 'Added by me' : 'Recommendation',
      reasonSkipped: reason.toString(),
    );

    registry<LocalyticsService>().tagEvent(event);
    registry<AppsFlyerService>().tagEvent(ProductSkippedAppsFlyer(product.sku));
  }

  void _tagAppliedEvent(Product product) {
    final event = ProductAppliedEvent(
      productName: product.name,
      productId: product.parentSku,
      activityFrom: product.isAddedByMe ? 'Added by me' : 'Recommendation',
      dueDate: product.applicationWindow.endDate?.toString(),
    );

    registry<LocalyticsService>().tagEvent(event);
    registry<AppsFlyerService>().tagEvent(ProductAppliedAppsFlyer(product.sku));
  }

  void _onLawnNameChanged(String modifiedLawnName, StateSetter setDialogState) {
    if (modifiedLawnName.length > _lawnNameCharacterLimit) {
      modifiedLawnName = modifiedLawnName.substring(0, _lawnNameCharacterLimit);
      _lawnNameController.text = modifiedLawnName;
      _lawnNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: modifiedLawnName.length));
    }
    setDialogState(() {
      _lawnNameCharacterCount = modifiedLawnName.length;

      if (modifiedLawnName.isNotEmpty && modifiedLawnName != _lawnName) {
        _lawnNameSaveIsDisabled = false;
      } else {
        _lawnNameSaveIsDisabled = true;
      }
    });
  }

  void _onLawnNameSaved(StateSetter setDialogState) {
    final modifiedLawnName = _lawnNameController.text;

    registry<AuthenticationBloc>()
        .add(UpdateLawnNameRequested(_lawnNameController.text));

    setDialogState(() {
      _lawnNameSaveIsDisabled = modifiedLawnName != _lawnName;
    });
  }

  void _didPressProfileButton() {
    registry<Navigation>().push('/profile');
  }

  void _onSubscriptionTapped(String recommendationId) {
    registry<Navigation>()
        .push('/subscription/options', arguments: recommendationId);
  }

  void _showLawnNameDialog(Function() loginGuestCallback) {
    final isGuest = registry<AuthenticationBloc>().state.isGuest;
    _lawnNameCharacterCount = _lawnNameController.text.length;

    showBottomSheetDialog(
      context: context,
      hasDivider: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          'Name Your Lawn',
          style: _theme.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            height: 32,
            child: Center(
              child: Text(
                'CANCEL',
                key: Key('cancel_button_of_lawn_name'),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Styleguide.color_green_7),
              ),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: Key('lawn_name'),
                autofocus: true,
                controller: _lawnNameController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_lawnNameCharacterLimit),
                  FilteringTextInputFormatter.deny(
                      RegExp(symbolsAndEmojiRegex)),
                ],
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Lawn Name',
                ),
                maxLength: _lawnNameCharacterLimit,
                maxLengthEnforced: true,
                onChanged: (input) => _onLawnNameChanged(input, setDialogState),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  '${_lawnNameCharacterCount}/${_lawnNameCharacterLimit} Characters',
                  style: _theme.textTheme.bodyText2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55, bottom: 32),
                child: FullTextButton(
                  key: Key('save_button_of_lawn_name'),
                  backgroundColor: _theme.primaryColor,
                  disabledColor: _theme.primaryColor,
                  color: _theme.backgroundColor,
                  isDisabled: _lawnNameSaveIsDisabled,
                  text: 'SAVE',
                  onTap: () {
                    if (isGuest) {
                      Navigator.of(context).pop();
                      loginGuestCallback();
                      _lawnNameSaveIsDisabled = true;
                    } else {
                      _onLawnNameSaved(setState);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDismissibleInfoSection() {
    return Container(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: WelcomeMessageCard(
          grassType: _lawnData.grassTypeName,
          lawnSqft: _lawnData.lawnSqFt,
        ));
  }

  Widget _buildYearLine(int year) {
    return Container(
      key: Key('divider_line'),
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Styleguide.color_gray_2,
              height: 1,
              width: double.infinity,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$year',
              style: _theme.textTheme.bodyText2.copyWith(fontSize: 11),
            ),
          ),
          Expanded(
            child: Container(
              color: Styleguide.color_gray_2,
              height: 1,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  void adobeStateCall(List<Product> _productList) async {
    final quizModel = registry<QuizModel>();

    if (quizModel.answers.isNotEmpty) {
      final lawnData = await registry<SessionManager>().getLawnData();

      final state = QuizResultEventScreenState(
        products: registry<AdobeRepository>()
            .buildProductString(_productList, parentSku: true, sku: true),
        recommendationId: _user.recommendationId,
        lawnSize: '${lawnData.inputType}:${lawnData.lawnSqFt} ',
        zip: quizModel.answers[QuestionType.zipCode],
        grassColor: quizModel.answers[QuestionType.lawnColor],
        grassThickness: quizModel.answers[QuestionType.lawnThickness],
        grassWeeds: quizModel.answers[QuestionType.lawnWeeds],
        spreaderSelect: quizModel.answers[QuestionType.lawnSpreader],
      );

      registry<AdobeRepository>().trackAppState(state);
    }
  }

  void adobeAppliedAction(Product product) {
    registry<AdobeRepository>().trackAppActions(
      PDPScreenProductAppliedAdobeAction(
        productName: product.name,
        productId: product.parentSku,
        lawnCarePlanId:
            registry<AuthenticationBloc>().state.user.recommendationId,
      ),
    );
  }

  void adobeSkippedAction(
    Product product,
    String text,
  ) {
    registry<AdobeRepository>().trackAppActions(
      PDPScreenProductSkippedAdobeAction(
        productName: product.name,
        productId: product.parentSku,
        lawnCarePlanId:
            registry<AuthenticationBloc>().state.user.recommendationId,
      ),
    );

    registry<AdobeRepository>().trackAppActions(
      HomeScreenProductSkippedWhyAdobeAction(
        skipReason: text,
        products: product.parentSku,
      ),
    );
  }

  Widget _buildSubscriptionCards(BuildContext ctx) {
    /*
     ListView automatically adds padding so need to wrap in MediaQuery.removePadding with removeTop: true
     https://github.com/flutter/flutter/issues/14842
     */
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        Product previousProduct;

        if (state is PlanSuccessState) {
          adobeStateCall(state.plan.products);
          return Container(
            key: UniqueKey(),
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: MediaQuery.removePadding(
              context: ctx,
              removeTop: true,
              child: Column(
                children: [
                  ...state.plan.products
                      .asMap()
                      .map((index, e) {
                        var hasYearLine = false;
                        if (previousProduct != null) {
                          final previousYear =
                              previousProduct.applicationWindow.startDate.year;
                          final currentYear =
                              e.applicationWindow.startDate.year;

                          if (currentYear > previousYear) {
                            hasYearLine = true;
                          }
                        }
                        previousProduct = e;
                        return MapEntry(
                            index,
                            Column(
                              key: Key(
                                  'sub_card_column_el_' + (index).toString()),
                              children: <Widget>[
                                if (hasYearLine)
                                  _buildYearLine(
                                      e.applicationWindow.startDate.year),
                                if (!e.isArchived)
                                  SubscriptionCard(
                                    key:
                                        Key('view_details_${index.toString()}'),
                                    product: e,
                                    isCollapsed: state.plan.products.first == e,
                                    onArchivedTapped: (archived) {
                                      setState(() {
                                        e = e.copyWith(isArchived: archived);
                                      });
                                    },
                                    onAppliedTapped: (archived) {
                                      showAppliedDialog(
                                        context: ctx,
                                        activityId: e.activityId,
                                        onAppliedSaved: (dateTime) {
                                          _tagAppliedEvent(e);

                                          adobeAppliedAction(e);
                                        },
                                        onComplete: () {
                                          registry<Logger>().d('onComplete');
                                        },
                                        bloc: registry<ActivityBloc>(),
                                      );
                                    },
                                    onSkippedTapped: (skipped) {
                                      showSkippedDialog(
                                        context: ctx,
                                        onSkippedSubmit: (reason, reasonText) {
                                          _tagSkipEvent(e, reason);

                                          adobeSkippedAction(e, reasonText);

                                          // TODO: busPublish reason
                                          registry<Logger>().d(
                                              'onSkippedSubmit: $reason $reasonText');
                                        },
                                        onComplete: () {
                                          registry<Logger>().d('onComplete');
                                        },
                                        activityId: e.activityId,
                                        bloc: registry<ActivityBloc>(),
                                      );
                                    },
                                  ),
                              ],
                            ));
                      })
                      .values
                      .toList()
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCarePlanImageRow(double height, double width) {
    final spacing = width / 4.8;
    final bagWidth = width - (spacing * 3);

    return BlocBuilder<PlanBloc, PlanState>(builder: (context, state) {
      var position = 3;
      if (state is PlanSuccessState) {
        return Stack(
          children: <Widget>[
            ...state.recommendationImages
                .map(
                  (imageUrl) => Positioned(
                    left: spacing * position--,
                    child: ProductImage(
                      width: bagWidth,
                      height: height,
                      productImageUrl: imageUrl,
                    ),
                  ),
                )
                .toList()
          ],
        );
      } else {
        return Container();
      }
    });
  }

  Widget _buildSubscribeTodayLarge() {
    return BlocBuilder<PlanBloc, PlanState>(builder: (context, state) {
      if (state is PlanSuccessState &&
          (state.subscription.subscriptionStatus == SubscriptionStatus.active ||
              state.subscription.subscriptionStatus ==
                  SubscriptionStatus.pending)) {
        return Container();
      } else {
        return Container(
          margin: EdgeInsets.fromLTRB(16, 40, 16, 8),
          child: Column(
            children: <Widget>[
              Text(
                'Subscribe to your plan today',
                style: _theme.textTheme.headline4,
              ),
              GestureDetector(
                child: Container(
                  height: 104,
                  width: 192,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: _buildCarePlanImageRow(104, 192),
                ),
                onTap: () => _onSubscriptionTapped(_user.recommendationId),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(36, 0, 36, 27),
                child: Text(
                  'Get your personalized lawn care plan delivered straight to your door. It\'s that easy!',
                  style: _theme.textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: FullTextButton(
                  backgroundColor: _theme.primaryColor,
                  color: Styleguide.color_gray_0,
                  text: 'SUBSCRIBE NOW',
                  onTap: () {
                    registry<AppsFlyerService>().tagEvent(SubscribeNowEvent());
                    _tagDetailsEvent<SubscribeEvent>();
                    _onSubscriptionTapped(_user.recommendationId);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: FullTextButton(
                    backgroundColor: Styleguide.color_gray_0,
                    color: _theme.primaryColor,
                    text: 'REMIND ME NEXT YEAR',
                    border: null,
                    onTap: () {
                      _tagDetailsEvent<RemindMeEvent>();
                      setState(() {
                        _remindMeNextYear = true;
                      });
                    }),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _buildSubscribeTodaySmall() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16, 20, 16, 20),
            height: 56,
            width: 136,
            child: _buildCarePlanImageRow(56, 136),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Get your plan delivered straight to your door',
                      style: _theme.textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                      )),
                  TappableText(
                    child: Text(
                      'LEARN MORE',
                      key: Key('learn_more'),
                      style: _theme.textTheme.bodyText1.copyWith(
                        color: _theme.primaryColor,
                        height: 1.66,
                      ),
                    ),
                    onTap: () {
                      _tagDetailsEvent<LearnMoreEvent>();
                      registry<Navigation>().push('/subscription/options',
                          arguments: _user.recommendationId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: _theme.backgroundColor,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDismissibleInfoSection(),
            _buildSubscriptionCards(context),
            _remindMeNextYear
                ? _buildSubscribeTodaySmall()
                : _buildSubscribeTodayLarge(),
            RainfallTrackWidget(),
            Container(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String lawnName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: Text(
              '$lawnName',
              style: _theme.textTheme.headline2.copyWith(
                color: _theme.colorScheme.background,
              ),
            ),
            onTap: () {
              _lawnNameController.text = lawnName;
              _showLawnNameDialog(() {
                buildLoginBottomCard(context);
              });
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  BlocListener<LoginBloc, LoginState>(
      cubit: registry<LoginBloc>(),
      listener: (context, state) {
        if (state is PendingRegistrationState) {
          registry<Navigation>().push(
            '/auth/pendingregistration',
            arguments: {'email': state.email, 'regToken': state.regToken},
          );
        }
      },

      child: BlocProvider.value(
        value: registry<PlanBloc>(),
        child: _buildScreen(),
      ),
    );
  }

  Widget _buildScreen() {
    return BasicScaffold(
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listenWhen: (prev, current) => prev.isGuest && current.isLogggedIn,
          listener: (context, state) {
            // When user successfully signed-up when updating their "Lawn Name"
            // we need to do following:
            // 1. Update their "Lawn Name" they intend to update before signing up.
            // 2. Relaunch "Home screen" as "root"
            if (_lawnNameController.text.isNotEmpty &&
                _lawnNameController.text != 'My Lawn') {
              registry<AuthenticationBloc>()
                  .add(UpdateLawnNameRequested(_lawnNameController.text));
              registry<Navigation>().setRoot('/home');
            }
            registry<PlanBloc>().add(PlanUpdate());
          },
          cubit: registry<AuthenticationBloc>(),
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      snap: false,
                      backgroundColor: _theme.primaryColor,
                      brightness: Brightness.dark,
                      expandedHeight: 80,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        key: Key('plan_screen_profile_icon_button'),
                        icon: CustomIcon(
                          'profile',
                          height: 24,
                          width: 24,
                        ),
                        onPressed: _didPressProfileButton,
                      ),
                      flexibleSpace: AppBar(
                        brightness: Brightness.dark,
                        backgroundColor: _theme.primaryColor,
                        flexibleSpace: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/grass_background.png'),
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 16),
                                child: _buildTitle(
                                  state.lawnData?.lawnName ?? 'My Lawn',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                          key: Key('plan_screen_more_icon_button'),
                          icon: CustomIcon('more', height: 24),
                          onPressed: () {
                            _lawnNameController.text =
                                state.lawnData?.lawnName ?? 'My Lawn';
                            _showLawnNameDialog(() {
                              buildLoginBottomCard(context);
                            });
                          },
                        ),
                      ],
                    ),
                    BlocConsumer<SingleProductBloc, SingleProductState>(
                      cubit: _singleProductBloc,
                      listener: (context, singleProductState) {
                        if (_deepLinkPath != null &&
                            _deepLinkPath.isNotEmpty &&
                            singleProductState is SingleProductSuccess) {
                          registry<Navigation>().push('/product/detail',
                              arguments: singleProductState.product);
                          _singleProductBloc.add(SingleProductOpened());
                        }
                      },
                      builder: (context, state) {
                        return BlocBuilder<PlanBloc, PlanState>(
                          builder: (context, state) {
                            return state is PlanSuccessState
                                ? SliverToBoxAdapter(
                                    child: _buildContent(context))
                                : state is PlanErrorState
                                    ? SliverFillRemaining(
                                        child: Center(
                                        child: ErrorMessage(
                                          errorMessage: '${state.errorMessage}',
                                          retryRequest: () =>
                                              context.read<PlanBloc>()
                                                ..add(PlanRetryButtonPressed()),
                                        ),
                                      ))
                                    : SliverToBoxAdapter(
                                        child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            _buildDismissibleInfoSection(),
                                            PlanSkeletonLoader(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: RainfallTrackWidget(),
                                            ),
                                            Container(
                                              height: 70,
                                            )
                                          ],
                                        ),
                                      ));
                          },
                        );
                      },
                    ),
                  ],
                ),
                CircularFab()
              ],
            );
          }),
      allowBackNavigation: false,
    );
  }
}
