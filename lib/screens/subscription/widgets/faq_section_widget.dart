import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_bloc.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_event.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/faq_data.dart';
import 'package:my_lawn/screens/profile/subscription/widgets/contentful_faq_widget_config.dart';
import 'package:my_lawn/screens/tips/contentful_rich.dart';

class FaqSection extends StatefulWidget {
  @override
  _FaqSectionWidgetState createState() => _FaqSectionWidgetState();
}

class _FaqSectionWidgetState extends State<FaqSection>
    with TickerProviderStateMixin {
  var _faqCategory = FaqCategory.subscription;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    registry<FaqBloc>().add(FetchFaqEvent());
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _didSelectTab(int index) {
    setState(() {
      switch (index) {
        case 0:
          return _faqCategory = FaqCategory.subscription;
          break;
        case 1:
          return _faqCategory = FaqCategory.billingAndShipping;
          break;
      }
    });
  }

  Widget _buildTabController() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.only(bottom: 12),
        unselectedLabelColor: theme.colorScheme.onBackground,
        labelColor: theme.colorScheme.primary,
        labelStyle: theme.textTheme.bodyText1,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Styleguide.color_green_4,
            width: 2.0,
          ),
        ),
        tabs: [
          Text(
            'SUBSCRIPTION',
          ),
          Text(
            'BILLING & SHIPPING',
            key: Key('billing_and_shipping'),
          ),
        ],
        onTap: (index) => _didSelectTab(index),
      ),
    );
  }

  Widget _buildFaqs(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FaqBloc, FaqState>(
      cubit: registry<FaqBloc>(),
      builder: (context, state) {
        return state is FaqSuccessState
            ? Column(
                key: Key('$_faqCategory'),
                children: [
                  ...intersperse(
                    Divider(),
                    state.faqList
                        .firstWhere(
                            (element) => element.category == _faqCategory)
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ExpansionTile(
                                title: Text(
                                  item.question,
                                  style: theme.textTheme.subtitle2
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
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
            : SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Styleguide.nearBackground(theme),
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'FAQs',
                style: theme.textTheme.headline3,
              ),
            ),
          ),
          _buildTabController(),
          _buildFaqs(context),
        ],
      ),
    );
  }
}
