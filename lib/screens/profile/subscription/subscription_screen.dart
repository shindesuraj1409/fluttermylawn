import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_state.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:navigation/navigation.dart';

import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_event.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_state.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/skipping_reasons_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/home/home_screen.dart';
import 'package:my_lawn/screens/profile/subscription/add_more_products_widget.dart';
import 'package:my_lawn/screens/profile/subscription/button_section_widget.dart';
import 'package:my_lawn/screens/profile/subscription/section_widget.dart';
import 'package:my_lawn/screens/profile/subscription/subscription_item_listview_widget.dart';
import 'package:my_lawn/services/analytic/actions/localytics/subscription_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/deeplinks_handler.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/have_moved_bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionBloc _bloc;
  User _user;

  final _orderDetailsBloc = registry<OrderDetailsBloc>();
  final SkippingReasonsBloc _skippingReasonsBloc =
      registry<SkippingReasonsBloc>();

  List<SkippingReasons> skippingReasons;
  List<SkippingReasons> selectedSkippingReasons;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    registry<AdobeRepository>().trackAppState(MySubscriptionScreenAdobeState());
    _user = registry<AuthenticationBloc>().state.user;
    _bloc = registry<SubscriptionBloc>();
    _bloc.add(FindSubscription(_user.customerId));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    selectedSkippingReasons = [];

    _skippingReasonsBloc.add(FetchSkippingReasonsEvent());
    _skippingReasonsBloc.listen((state) {
      if (state is SkippingReasonsSuccessState) {
        setState(() {
          skippingReasons = state.skippingReasonsList;
        });
      } else {
        setState(() {
          skippingReasons = [];
        });
      }
    });
  }

  String _formatAddress(SubscriptionData data) =>
      '${data.firstName} ${data.lastName}\n'
      '${data.shippingAddress.address1}\n'
      '${data.shippingAddress.city}, ${data.shippingAddress.state} ${data.shippingAddress.zip}';

  String _formatDate(
    DateTime dateTime, {
    bool forceYear = false,
  }) =>
      forceYear || dateTime.year != DateTime.now().year
          ? DateFormat('EEE MMM d, yyyy').format(dateTime)
          : DateFormat('EEE MMM d').format(dateTime);

  void updateOrderDetails() {
    _orderDetailsBloc.add(GetOrderDetails(_bloc.state.data.last.shipments));
  }

  Widget _buildHorizontalDivider(BuildContext context) => Divider(
        color: Theme.of(context).textTheme.bodyText1.color,
        thickness: 0.25,
        height: 1,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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

        if (state.status.isError) {
          return BasicScaffoldWithSliverAppBar(
            titleString: 'My Subscription',
            child: ErrorMessage(
              errorMessage: 'Something went wrong, please try again.',
              retryRequest: () => _bloc.add(
                FindSubscription(_user.customerId),
              ),
            ),
          );
        }

        if (state.status.hasSubscriptionData) {
          var addOns = <Product>[];
          if (registry<PlanBloc>().state is PlanSuccessState) {
            addOns = (registry<PlanBloc>().state as PlanSuccessState)
                .plan
                .getUpdatedPlanWithPricesCalculated()
                .addOnProducts;
          }

          return BasicScaffoldWithSliverAppBar(
            titleString: 'My Subscription',
            trailing: state.status.isActive
                ? Text(
                    '${state.data.last.shipments.length} '
                    'item${state.data.last.shipments.length == 1 ? '' : 's'}',
                    style: textTheme.subtitle1,
              key: Key('number_of_items'),
                  )
                : Text(''),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isActive)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16)
                            .add(EdgeInsets.only(bottom: 8)),
                        child: SizedBox(
                          height: 160,
                          child:
                              BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
                            cubit: _orderDetailsBloc,
                            builder: (context, orderDetailsState) {
                              if (orderDetailsState is OrderDetailsInitial) {
                                _orderDetailsBloc.add(
                                    GetOrderDetails(state.data.last.shipments));
                              }

                              return SubscriptionItemsListViewWidget(
                                skippingReasons: skippingReasons,
                                selectedSkippingReasons:
                                    selectedSkippingReasons,
                                formatDate: _formatDate,
                                state: state,
                                orderDetailsBloc: _orderDetailsBloc,
                                updateOrderDetails: updateOrderDetails,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: AddMoreProductsWidget(
                          subscriptionData: state.data.last,
                          addons: addOns,
                        ),
                      ),
                    ],
                  ),
                SectionWidget(
                  title: 'Subscription Type',
                  text: state.data.last.subscriptionType.string,
                  trailing: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: Text(
                          state.data.last.subscriptionStatus.string,
                          style: textTheme.button.copyWith(
                            color: theme.primaryColor,
                          ),
                          key: Key('subscription_status_label'),
                        )),
                  ),
                  key: Key('subscription_type_section'),
                ),
                if (!state.status.isPending &&
                    state.data.last.startedAt != null)
                  Column(
                    children: [
                      _buildHorizontalDivider(context),
                      SectionWidget(
                        title: 'Start Date',
                        text: _formatDate(
                          DateTime.tryParse(state.data.last.startedAt) ?? '',
                          forceYear: true,
                        ),
                        key: Key('start_date_section'),
                      ),
                      _buildHorizontalDivider(context),
                      SectionWidget(
                        title:
                            state.status.isActive ? 'Renewal Date' : 'End Date',
                        text: _formatDate(
                          DateTime.tryParse(
                                state.status.isActive
                                    ? state.data.last.renewalAt
                                    : state.data.last.canceledAt,
                              ) ??
                              '',
                          forceYear: true,
                        ),
                        key: Key('renewal_date_section'),
                      )
                    ],
                  ),
                _buildHorizontalDivider(context),
                if (state.data?.last?.ccLastFour != null)
                  ButtonSectionWidget(
                    title: 'Billing Info',
                    text: '•••• ${state.data.last.ccLastFour}',
                    leadingImageName: state.data.last.ccType.iconPath,
                    onTap: () async {
                      final billingInfoUpdated =
                          await registry<Navigation>().push(
                        '/profile/subscription/update_billing_info',
                      );
                      if (billingInfoUpdated != null &&
                          billingInfoUpdated is bool &&
                          billingInfoUpdated) {
                        _bloc.add(FindSubscription(_user.customerId));
                      }
                    },
                    width: 38,
                    height: 24,
                    key: Key('billing_info_section'),
                  ),
                _buildHorizontalDivider(context),
                SectionWidget(
                  title: 'Shipping Address',
                  text: _formatAddress(state.data.last),
                  trailing: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('I have moved'),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 1),
                            child: Image.asset(
                              'assets/icons/info.png',
                              color: textTheme.bodyText1.color,
                              width: 18,
                              height: 18,
                              key: Key('i_have_moved_icon'),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => buildIHaveMovedBottomDialog(context, theme),
                    ),
                  ),
                  key: Key('shipping_address_section'),
                ),
                _buildHorizontalDivider(context),
                if (!state.status.isPending)
                  Column(
                    children: [
                      GreyArea(height: 15.5),
                      FlatButton(
                        onPressed: () {
                          if (state.status.isActive) {
                            registry<LocalyticsService>()
                                .tagEvent(CancelSubscriptionLocalyticsEvent());
                          }
                          registry<Navigation>().push(
                            state.status.isActive
                                ? '/profile/subscription/cancel'
                                : '/quiz',
                          );
                        },
                        child: Center(
                          child: Text(
                            state.status.isActive
                                ? 'CANCEL SUBSCRIPTION'
                                : 'GET A NEW PLAN',
                          ),
                        ),
                      ),
                    ],
                  ),
                _buildHorizontalDivider(context),
                GreyArea(height: 17.1),
                // _buildButtonSection( /* Hide this section until update from backend*/
                //   context,
                //   text: 'Order History',
                //   leadingImageName: 'assets/icons/order_history.png',
                //   onTap: () => registry<Navigation>().push(
                //     '/profile/subscription/order_history',
                //   ),
                // ),
                // _buildHorizontalDivider(context),
                ButtonSectionWidget(
                  key: Key('faqs'),
                  text: 'FAQs',
                  leadingImageName: 'assets/icons/question.png',
                  onTap: () => registry<Navigation>().push(
                    '/profile/subscription/faqs',
                  ),
                ),
                _buildHorizontalDivider(context),
                ButtonSectionWidget(
                  key: Key('customer_support'),
                  text: 'Customer Support',
                  leadingImageName: 'assets/icons/customer_support.png',
                  onTap: () {
                    registry<Navigation>().popToRoot();
                    return registry<Navigation>().pushReplacement('/home',
                        arguments: HomeScreenArguments(HomeScreenTab.ask, ''));
                  },
                ),
                _buildHorizontalDivider(context),
                Expanded(child: GreyArea(height: 48))
              ],
            ),
          );
        }
        return BasicScaffoldWithSliverAppBar(
            titleString: 'My Subscription',
            child: Center(child: ProgressSpinner()));
      },
    );
  }
}

class GreyArea extends StatelessWidget {
  const GreyArea({
    Key key,
    this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styleguide.color_gray_1,
      height: height,
    );
  }
}
