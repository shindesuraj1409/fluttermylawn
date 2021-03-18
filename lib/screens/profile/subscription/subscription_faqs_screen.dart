import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_bloc.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_event.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/faq_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/profile/subscription/widgets/contentful_faq_widget_config.dart';
import 'package:my_lawn/screens/tips/contentful_rich.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class SubscriptionFaqsScreen extends StatefulWidget {
  @override
  _SubscriptionFaqsScreenState createState() => _SubscriptionFaqsScreenState();
}

class _SubscriptionFaqsScreenState extends State<SubscriptionFaqsScreen>
    with RouteMixin<SubscriptionFaqsScreen, String> {
  var _faqCategory = FaqCategory.subscription;
  String _deepLink;
  final _scrollController = ScrollController();
  int _deepLinkIndex;
  int _faqListlength;

  @override
  void initState() {
    super.initState();
    registry<FaqBloc>().add(FetchFaqEvent());
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _scrollToArticle(context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deepLink = routeArguments;
  }

  void _scrollToArticle(BuildContext context) async {
    if (_deepLink != null) {
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (registry<FaqBloc>().state is FaqSuccessState) {
          _scrollController.animateTo(
              (_deepLinkIndex + 1) /
                  _faqListlength *
                  _scrollController.position.maxScrollExtent,
              curve: Curves.ease,
              duration: Duration(milliseconds: 500));
          timer.cancel();
        }
      });
    }
  }

  Widget _buildCard({
    Key key,
    BuildContext context,
    String iconPath,
    String title,
    bool isSelected,
    VoidCallback onTap,
  }) =>
      SizedBox(
        key: key,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
          child: Card(
            elevation: isSelected ? 8 : 2,
            shape: isSelected
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2))
                : Theme.of(context).cardTheme.shape,
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(iconPath, width: 64, height: 64),
                  SizedBox(height: 8),
                  Text(title),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildFaqs(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<FaqBloc, FaqState>(
      cubit: registry<FaqBloc>(),
      listenWhen: (previous, current) =>
          _deepLink != null &&
          previous is FaqLoadingState &&
          current is FaqSuccessState,
      listener: (context, state) {
        if (state is FaqSuccessState) {
          final billingList = state.faqList
              .firstWhere((element) =>
                  element.category == FaqCategory.billingAndShipping)
              .faqItems;
          _deepLinkIndex =
              billingList.indexWhere((item) => item.id == _deepLink);

          if (_deepLinkIndex >= 0) {
            _faqListlength = billingList.length;
            setState(() => _faqCategory = FaqCategory.billingAndShipping);
          } else {
            final subscriptionList = state.faqList
                .firstWhere(
                    (element) => element.category == FaqCategory.subscription)
                .faqItems;
            _deepLinkIndex =
                subscriptionList.indexWhere((item) => item.id == _deepLink);
            _faqListlength = subscriptionList.length;
          }
        }
      },
      builder: (context, state) => state is FaqSuccessState
          ? Column(
              key: Key('$_faqCategory'),
              children: [
                ...intersperse(
                  Divider(),
                  state.faqList
                      .firstWhere((element) => element.category == _faqCategory)
                      .faqItems
                      .map(
                        (item) => Theme(
                          data: theme.copyWith(
                            // down arrow
                            unselectedWidgetColor:
                                theme.textTheme.bodyText1.color,
                            // up arrow
                            accentColor: theme.textTheme.bodyText1.color,
                            // dividers above and below
                            dividerColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ExpansionTile(
                              initiallyExpanded: _deepLink == item.id,
                              title: Text(
                                item.question,
                                style: theme.textTheme.subtitle2
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: ContentfulRichText(item.answer,
                                          options:
                                              contentfulSubscriptionOptions(
                                                  context))
                                      .documentToWidgetTree,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            )
          : SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithSliverAppBar(
      titleString: 'FAQs',
      backgroundColor: Styleguide.nearBackground(theme),
      scrollController: _scrollController,
      child: Container(
        color: theme.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildCard(
                      key: Key('subscription'),
                      context: context,
                      iconPath: 'assets/icons/subscription.png',
                      title: 'Subscription',
                      isSelected: _faqCategory == FaqCategory.subscription,
                      onTap: () => setState(
                        () => _faqCategory = FaqCategory.subscription,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildCard(
                      key: Key('billing_and_shipping'),
                      context: context,
                      iconPath: 'assets/icons/billing.png',
                      title: 'Billing & Shipping',
                      isSelected:
                          _faqCategory == FaqCategory.billingAndShipping,
                      onTap: () => setState(
                        () => _faqCategory = FaqCategory.billingAndShipping,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildFaqs(context),
          ],
        ),
      ),
    );
  }
}
