import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_state.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_options/subscription_options_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/profile/update_lawn_profile/sticky_bottom.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/collapsed_card.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/plan_skeleton_loader.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class UpdatePlanScreen extends StatefulWidget {
  @override
  _UpdatePlanScreenState createState() => _UpdatePlanScreenState();
}

class _UpdatePlanScreenState extends State<UpdatePlanScreen>
    with RouteMixin<UpdatePlanScreen, Map<String, String>> {
  SubscriptionBloc _bloc;
  User _user;

  String _title = '';
  String _description = '';

  @override
  void initState() {
    _bloc = registry<SubscriptionBloc>();
    _user = registry<AuthenticationBloc>().state.user;
    _bloc.add(FindSubscription(_user.customerId));
    super.initState();
  }

  List<Widget> returnRecommendationItems(List<Product> products) {
    final recommendationItems = <Widget>[];
    for (var i = 0; i < products.length; i++) {
      recommendationItems.add(CollapsedCard(
        color: products[i].color,
        itemName: products[i].name,
        imageUrl: products[i].imageUrl,
        startDate: products[i].applicationWindow.startDate,
        endDate: products[i].applicationWindow.endDate,
        itemPrice: '${products[i].price}',
        isNew: true,
      ));
    }
    registry<AdobeRepository>()
        .trackAppState(UpdateSubscriptionScreenAdobeState(
      recommendationId:
          registry<AuthenticationBloc>().state.user.recommendationId,
      products: registry<AdobeRepository>().buildProductString(
        products,
        sku: true,
      ),
    ));
    return recommendationItems;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _title = routeArguments['title'];
    _description = routeArguments['description'];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      cubit: _bloc,
      listener: (context, state) async {
        if (state.status.isNone) {
          await showSnackbar(
              context: context,
              text: 'You Got No Subscription',
              duration: Duration(
                seconds: 3,
              ));
          return Future.delayed(Duration(seconds: 3), () {
            registry<Navigation>().popTo('/profile');
          });
        }
      },
      builder: (context, state) {
        if (state.status.isNone) {
          return BasicScaffoldWithSliverAppBar(
              titleString: 'My Subscription', child: Container());
        }
        return BasicScaffoldWithSliverAppBar(
          titleString: _title,
          leading: GestureDetector(
            onTap: () => registry<Navigation>().popTo('/profile'),
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 25,
            ),
          ),
          bottom: StickyBottom(
            _title,
            state.data.last.subscriptionType,
            _user.customerId,
            registry<SubscriptionOptionsBloc>().state.plan,
            _user.recommendationId,
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: BlocBuilder<PlanBloc, PlanState>(
                cubit: registry<PlanBloc>(),
                builder: (context, state) {
                  return state is PlanSuccessState
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                _description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 14, height: 1.5),
                              ),
                            ),
                            ...returnRecommendationItems(state.plan.products),
                          ],
                        )
                      : state is PlanErrorState
                          ? SliverFillRemaining(
                              child: Center(
                              child: ErrorMessage(
                                errorMessage: '${state.errorMessage}',
                              ),
                            ))
                          : SliverToBoxAdapter(
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    PlanSkeletonLoader(),
                                  ],
                                ),
                              ),
                            );
                }),
          ),
        );
      },
    );
  }
}
