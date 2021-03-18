// ML.SC.029: Subscription Options Screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_options/subscription_options_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/cart/cart_screen.dart';
import 'package:my_lawn/screens/subscription/widgets/carousel_section_widgets.dart';
import 'package:my_lawn/screens/subscription/widgets/choose_subscription_section_widget.dart';
import 'package:my_lawn/screens/subscription/widgets/faq_section_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/state.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class SubscriptionOptionsScreen extends StatefulWidget {
  @override
  _SubscriptionOptionsScreenState createState() =>
      _SubscriptionOptionsScreenState();
}

class _SubscriptionOptionsScreenState extends State<SubscriptionOptionsScreen>
    with
        TickerProviderStateMixin,
        RouteMixin<SubscriptionOptionsScreen, String> {
  SubscriptionOptionsBloc _bloc;
  String _recommendationId;

  SubscriptionType _selectedSubscriptionType = SubscriptionType.annual;

  @override
  void initState() {
    super.initState();
    _bloc = registry<SubscriptionOptionsBloc>();

    registry<AdobeRepository>().trackAppState(
      SubscriptionOptionScreenAdobeState(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_recommendationId == null || _recommendationId != routeArguments) {
      _recommendationId = routeArguments;
      _bloc.fetchRecommendation(_recommendationId);
    }
  }

  void _retryFetchRecommendation() {
    _bloc.fetchRecommendation(_recommendationId);
  }

  void _retryRegenerateRecommendation() {
    _bloc.regenerateRecommendation(_recommendationId);
  }

  void onSubscriptionOptionSelected(SubscriptionType option) {
    _selectedSubscriptionType = option;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = registry<AuthenticationBloc>().state.user;
    final isGuest = registry<AuthenticationBloc>().state.isGuest;

    return BlocConsumer<SubscriptionOptionsBloc, SubscriptionOptionsState>(
      cubit: _bloc,
      listener: (context, state) {
        if (state.status ==
            SubscriptionOptionsStatus.regenerateRecommendationSuccess) {
          showSnackbar(
            context: context,
            text: 'Your recommendation has been updated',
            duration: Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          cubit: registry<AuthenticationBloc>(),
          listener: (context, state) {
            if (state.authStatus != AuthStatus.guest) {
              registry<Navigation>().setRoot(
                '/cart',
                arguments: CartScreenArguments(
                  recommendationId: _recommendationId,
                  plan: _bloc.state.plan,
                  selectedSubscriptionType: _selectedSubscriptionType,
                  customerId: state.user.customerId,
                ),
                rootName: '/home',
              );
            }
          },
          child: BasicScaffoldWithSliverAppBar(
            isNotUsingWillPop: true,
            childFillsRemainingSpace: (state.status ==
                        SubscriptionOptionsStatus.fetchRecommendationSuccess ||
                    state.status ==
                        SubscriptionOptionsStatus
                            .regenerateRecommendationSuccess)
                ? false
                : true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onBackground,
              ),
              onPressed: () {
                registry<Navigation>().pop();
              },
              key: Key('close_icon_button'),
            ),
            child: Builder(
              builder: (BuildContext context) {
                switch (state.status) {
                  case SubscriptionOptionsStatus.initial:
                  case SubscriptionOptionsStatus.fetchingRecommendation:
                    return Center(
                      child: ProgressSpinner(),
                    );
                  case SubscriptionOptionsStatus.regeneratingRecommendation:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProgressSpinner(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Updating your Recommendation..',
                            style: theme.textTheme.headline4,
                          ),
                        ),
                      ],
                    );
                  case SubscriptionOptionsStatus.fetchRecommendationSuccess:
                  case SubscriptionOptionsStatus
                      .regenerateRecommendationSuccess:
                    return Column(
                      children: [
                        _HeaderSection(),
                        CarouselSection(state.plan.products),
                        ChooseSubscriptionSection(
                          plan: state.plan,
                          onSelected: onSubscriptionOptionSelected,
                        ),
                        FaqSection(),
                      ],
                    );
                  case SubscriptionOptionsStatus.fetchRecommendationError:
                    return _ErrorMessage(
                      errorMessage: state.errorMessage,
                      retryRequest: _retryFetchRecommendation,
                    );
                  case SubscriptionOptionsStatus.regenerateRecommendationError:
                    return _ErrorMessage(
                      errorMessage: state.errorMessage,
                      retryRequest: _retryRegenerateRecommendation,
                    );
                  default:
                    throw UnimplementedError(
                        'Incorrect state reached in subscription option screen : ');
                }
              },
            ),
            bottom: _ContinueButton(
              state: state,
              onContinueClicked: () async {
                if (isGuest) {
                  buildLoginBottomCard(context);
                } else {
                  unawaited(registry<Navigation>().push(
                    '/cart',
                    arguments: CartScreenArguments(
                      recommendationId: _recommendationId,
                      plan: state.plan,
                      selectedSubscriptionType: _selectedSubscriptionType,
                      customerId: user.customerId,
                    ),
                  ));
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final SubscriptionOptionsState state;
  final Function onContinueClicked;

  _ContinueButton({this.state, this.onContinueClicked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return state.status ==
                SubscriptionOptionsStatus.fetchRecommendationSuccess ||
            state.status ==
                SubscriptionOptionsStatus.regenerateRecommendationSuccess
        ? Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
                  blurRadius: 5.0,
                  spreadRadius: -1.0,
                  offset: Offset(
                    0.0,
                    3.0,
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
                  blurRadius: 18.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    6.0,
                  ),
                ),
              ],
            ),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: RaisedButton(
                  onPressed: onContinueClicked,
                  child: Text(
                    'CONTINUE',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            'We deliver what you need when you need it',
            style: theme.textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            'When your lawn needs something, you\'ll receive a shipment. When you get it, simply apply the product(s) to your lawn. Seriously, it\'s as simple as that.',
            style: theme.textTheme.bodyText2.copyWith(height: 1.66),
          ),
        ),
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String errorMessage;
  final Function retryRequest;

  _ErrorMessage({
    this.errorMessage,
    this.retryRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Text(
            '$errorMessage',
            textAlign: TextAlign.center,
            style:
                theme.textTheme.headline4.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        FlatButton(
          child: Text(
            'Try Again',
            style: theme.textTheme.headline4,
          ),
          onPressed: retryRequest,
        ),
      ],
    );
  }
}
