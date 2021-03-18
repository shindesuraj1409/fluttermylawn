import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancel_subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/refund_preview_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/call_and_mail_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class CancelingScreen extends StatefulWidget {
  @override
  _CancelingScreenState createState() => _CancelingScreenState();
}

class _CancelingScreenState extends State<CancelingScreen> {
  CancelSubscriptionBloc _bloc;
  SubscriptionData _subscriptionData;

  final list = <BulletListTextWidget>[];

  @override
  void initState() {
    super.initState();
    _bloc = registry<CancelSubscriptionBloc>();
    _subscriptionData = registry<SubscriptionBloc>()?.state?.data?.last;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(PreviewSubscriptionRefundEvent(_subscriptionData.orderId));
  }

  final _radioDecoration = BoxDecoration(
    color: Styleguide.color_gray_0,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ],
  );

  List _createRefundedProductsList(RefundData data, ThemeData theme) {
    list.clear();
    if (data.products.isNotEmpty) {
      for (var product in data.products) {
        list.add(BulletListTextWidget(
          context: context,
          textTheme: theme.textTheme,
          text: product.productName,
          qty: product.qty,
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithSliverAppBar(
      titleString: 'Confirm Cancelation',
      leading: GestureDetector(
        onTap: () => registry<Navigation>().pop(),
        child: Icon(
          Icons.close,
          size: 32,
          key: Key('close_icon'),
        ),
      ),
      appBarForegroundColor: theme.colorScheme.onPrimary,
      appBarBackgroundColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary,
      slivers: [
        BlocConsumer<CancelSubscriptionBloc, CancelSubscriptionState>(
          cubit: _bloc,
          listener: (context, state) async {
            if (state is CancelSubscriptionStateError) {
              await showSnackbar(
                  context: context,
                  text: 'Something went wrong, please try again later.',
                  duration: Duration(
                    seconds: 3,
                  ));
              return Future.delayed(Duration(seconds: 3), () {
                registry<Navigation>().popTo('/profile/subscription');
              });
            }
            if (state is PreviewSubscriptionStateSuccess) {
              if (state.refundData.canBeCanceled) {
                _createRefundedProductsList(state.refundData, theme);
              } else {
                await showSnackbar(
                    context: context,
                    text: 'Subscription can\'t be cancelled',
                    duration: Duration(
                      seconds: 3,
                    ));
                return Future.delayed(Duration(seconds: 3), () {
                  registry<Navigation>().popTo('/profile/subscription');
                });
              }
            }
          },
          builder: (context, state) {
            if (state is CancelSubscriptionStateError) {
              return SliverFillRemaining();
            }
            if (state is PreviewSubscriptionStateSuccess) {
              return SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                            'By canceling your subscription, the following will happen:',
                            style: theme.textTheme.subtitle1.copyWith(
                              color: theme.colorScheme.onPrimary,
                            )),
                      ),
                      Container(
                        decoration: _radioDecoration,
                        margin: EdgeInsets.fromLTRB(4, 24, 4, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: Column(
                          children: [
                            if (_subscriptionData.subscriptionType.isAnnual &&
                                list.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.done,
                                    size: 20,
                                    color: theme.colorScheme.primary,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'You will be refunded ',
                                                style:
                                                    theme.textTheme.subtitle1),
                                            TextSpan(
                                              text:
                                                  '\$${state.refundData.estimatedRefund.toStringAsFixed(2)} ',
                                              style: theme.textTheme.subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text: 'for the products:',
                                              style: theme.textTheme.subtitle1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (_subscriptionData.subscriptionType.isAnnual)
                              ...list,
                            if (list.isNotEmpty)
                              if (_subscriptionData.subscriptionType.isAnnual)
                                TextWithIconWidget(
                                    theme: theme,
                                    textTheme: theme.textTheme,
                                    data:
                                        'The refund will appear in your original payment method within 7 days.',
                                    isShowIcon: false),
                            TextWithIconWidget(
                                theme: theme,
                                textTheme: theme.textTheme,
                                data: 'You will no longer be billed.',
                                isShowIcon: true),
                            TextWithIconWidget(
                                theme: theme,
                                textTheme: theme.textTheme,
                                data:
                                    'You will no longer receive product shipments.',
                                isShowIcon: true),
                            TextWithIconWidget(
                                theme: theme,
                                textTheme: theme.textTheme,
                                data:
                                    'You will still have an online account with Scotts.',
                                isShowIcon: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverFillRemaining(
                child: Center(
              child: ProgressSpinner(
                color: theme.colorScheme.onPrimary,
              ),
            ));
          },
        ),
      ],
      bottom: Container(
        color: theme.colorScheme.onPrimary,
        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CallAndMailWidget(EdgeInsets.fromLTRB(40, 24, 40, 12),
                '1-877-220-3091', 'orders@scotts.com'),
            Container(
              margin: EdgeInsets.fromLTRB(24, 20, 24, 20),
              width: double.infinity,
              child: RaisedButton(
                  child: Text('CONTINUE'),
                  onPressed: () {
                    registry<AdobeRepository>().trackAppState(
                      CancelConfirmationScreenAdobeState(
                        canceledOrderId: _subscriptionData?.orderId,
                        cancelRefundAmount: _subscriptionData?.refundAmount,
                      ),
                    );

                    registry<Navigation>().pushReplacement(
                        '/profile/subscription/cancellation_completed_screen');
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class TextWithIconWidget extends StatelessWidget {
  const TextWithIconWidget({
    Key key,
    @required this.theme,
    @required this.textTheme,
    @required String data,
    @required this.isShowIcon,
  })  : _data = data,
        super(key: key);

  final ThemeData theme;
  final TextTheme textTheme;
  final String _data;
  final bool isShowIcon;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (isShowIcon)
            Icon(
              Icons.done,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(isShowIcon ? 10 : 30, 5, 0, 5),
              child: Text(
                _data,
                style: textTheme.subtitle1,
              ),
            ),
          ),
        ],
      );
}

class BulletListTextWidget extends StatelessWidget {
  const BulletListTextWidget({
    Key key,
    @required this.textTheme,
    @required this.context,
    @required this.text,
    @required this.qty,
  }) : super(key: key);

  final TextTheme textTheme;
  final BuildContext context;
  final String text;
  final int qty;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(36, 5, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('•  ', style: textTheme.headline5),
            Expanded(
              child: Text(
                '$text, QTY: $qty',
                style: textTheme.overline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}
