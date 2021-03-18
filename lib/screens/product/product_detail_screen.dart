// ML.SC.014: Product Detail Screen
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/product/product_bloc.dart';
import 'package:my_lawn/blocs/product/product_state.dart';
import 'package:my_lawn/blocs/product/produt_event.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/pdp/store_locator/local_store_locator_screen.dart';
import 'package:my_lawn/screens/product/widgets/product_additional_info.dart';
import 'package:my_lawn/screens/product/widgets/product_header.dart';
import 'package:my_lawn/screens/product/widgets/product_how_to_apply_category.dart';
import 'package:my_lawn/screens/product/widgets/product_info_html_wrapper.dart';
import 'package:my_lawn/screens/product/widgets/product_mini_claim.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_youtube_player.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/product_applied_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/product_events.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PDP_screen/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PDP_screen/state.dart';
import 'package:my_lawn/services/analytic/screen_state_action/home_screen/action.dart';
import 'package:my_lawn/widgets/bag_widget.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/counter_widget.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/expansion_tile_widget.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key key}) : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin, RouteMixin<ProductDetailScreen, Product> {
  Product product;
  ThemeData _theme;

  LawnData lawnData;
  String title = '';

  ScrollController _scrollController;
  TabController _tabController;
  int _selectedTab = 0;

  Map<Product, int> bagQuantityList = {};
  final badgeHeight = 16;
  double expandedHeight;

  ProductBloc _bloc;
  bool isGuest;
  @override
  void initState() {
    super.initState();
    _bloc = registry<ProductBloc>();
    _bloc.listen((state) {
      if (state is BlocReadyState) {
        _bloc.add(ProductFetchEvent(product: product));
      }
      if (state is ProductFetchedState) {
        setState(() {
          product = state.product;
        });
      }
    });
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset < (expandedHeight - 24)) {
          setState(() {
            title = '';
          });
        } else if (_scrollController.offset >= (expandedHeight - 24)) {
          setState(() {
            title = product.name;
          });
        }
      });
    _tabController =
        TabController(initialIndex: _selectedTab, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    expandedHeight = 256 - MediaQuery.of(context).padding.top;
    isGuest = registry<AuthenticationBloc>().state.isGuest;
    lawnData = await registry<AuthenticationBloc>().state.lawnData;
    if (product == null && routeArguments != null) {
      product = routeArguments;
      _bloc.add(InitialProductEvent());

      registry<AdobeRepository>().trackAppState(
        PDPScreenAdobeState(
          productId: product.parentSku,
          productName: product.name,
        ),
      );
    }
  }

  bool isProductActiveInApplicationWindow() {
    final today = DateTime.now();

    return product.isAddedByMe
        ? (product.applicationWindow.startDate.day == today.day &&
            product.applicationWindow.startDate.month == today.month &&
            product.applicationWindow.startDate.year == today.year)
        : (today.isAfter(product.applicationWindow.startDate) &&
            (product.applicationWindow.endDate == null ||
                today.isBefore(product.applicationWindow.endDate)));
  }

  void _didSelectTab(int index) {
    setState(() => _selectedTab = index);
  }

  Widget _buildCoverageCalculatorSection() {
    final _button = Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 33),
      child: FullTextButton(
        text: 'BUY NOW',
        color: _theme.colorScheme.primary,
        onTap: () {
          showBottomSheetDialog(
            context: context,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  FullTextButton(
                    backgroundColor: _theme.primaryColor,
                    color: Styleguide.color_gray_0,
                    text: 'BUY ONLINE',
                    onTap: () {
                      registry<Navigation>().pop();
                      registry<Navigation>().push('/pdp/storelocator/online',
                          arguments: product.parentSku);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FullTextButton(
                    key: Key('find_local_store'),
                    text: 'FIND LOCAL STORE',
                    color: _theme.colorScheme.primary,
                    onTap: () {
                      registry<Navigation>().pop();
                      registry<Navigation>().push('/pdp/storelocator/local',
                          arguments: LocalStoreLocatorScreenArguments(
                              productId: product.parentSku,
                              zipCode: lawnData?.lawnAddress?.zip));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: FullTextButton(
                      text: 'CANCEL',
                      onTap: () => registry<Navigation>().pop(),
                      border: null,
                      backgroundColor: Styleguide.color_gray_0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );

    Widget _bagRow(bool isSmall, Product _product, int quantityIndex) {
      if (_product.coverageArea == null) return Container();

      final quantity = bagQuantityList[_product];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          key: Key('${isSmall ? 'small' : 'large'}_bag_container'),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            Bag(
              bagSize: isSmall ? BagSize.Small : BagSize.Large,
              text: NumberFormat.compact().format(_product.coverageArea) +
                  ' sqft',
              margin: EdgeInsets.only(right: 8),
            ),
            Counter(
              (qty) {
                setState(() {
                  bagQuantityList[_product] = qty;
                });
              },
              quantity,
              _product.coverageArea,
            ),
          ],
        ),
      );
    }

    final _bagQty = Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ...product.childProducts
                .map((e) => _bagRow((product.childProducts.first == e), e,
                    product.childProducts.indexOf(e)))
                .toList(),
          ],
        ));

    final _text = (product.childProducts != null &&
                product.childProducts
                    .map((element) => element.coverageArea)
                    .isNotEmpty) ||
            product.coverageArea != null
        ? Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Calculate Bag Size',
                  style: _theme.textTheme.headline5,
                ),
                Row(
                  children: [
                    Text('Coverage area '),
                    Text(
                      bagQuantityList.entries
                          .fold(
                              0,
                              (previousValue, element) =>
                                  previousValue +
                                  element.key.coverageArea * element.value)
                          .toString(),
                      style: _theme.textTheme.subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      ' sqft',
                      style: _theme.textTheme.subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    IconButton(
                      key: Key('info_icon_product_detail'),
                      padding: EdgeInsets.zero,
                      iconSize: 12,
                      splashRadius: 12,
                      constraints: BoxConstraints.tight(Size(12, 12)),
                      icon: Image.asset(
                        'assets/icons/info_black.png',
                        width: 12,
                        height: 12,
                      ),
                      onPressed: () => showBottomSheetDialog(
                        context: context,
                        title: Expanded(
                          child: Text(
                              'We\'ve calculated the coverage amount based on your lawn size.',
                              style: _theme.textTheme.headline2),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Text(
                                'No more guesswork! We\'ve eliminated all the guesswork when it comes to knowing how much you should apply.',
                                style: _theme.textTheme.bodyText2
                                    .copyWith(height: 1.22),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              FullTextButton(
                                key: Key('got_it_button_product_detail'),
                                text: 'GOT IT!',
                                color: _theme.colorScheme.primary,
                                border: Border.all(
                                  color: _theme.colorScheme.primary,
                                  width: 1,
                                ),
                                onTap: () => registry<Navigation>().pop(),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        : Container();

    return Container(
      color: _theme.colorScheme.background,
      child: Column(
        children: <Widget>[
          _text,
          _bagQty,
          _button,
        ],
      ),
    );
  }

  Widget _buildTabController() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        controller: _tabController,
        labelPadding: EdgeInsets.only(bottom: 12),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: _theme.colorScheme.primary,
            width: 2.0,
          ),
        ),
        tabs: [
          Column(
            children: <Widget>[
              Text(
                'OVERVIEW',
                style: _theme.textTheme.bodyText1.copyWith(
                  color: _selectedTab == 0
                      ? Styleguide.color_green_4
                      : Styleguide.color_gray_9,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'HOW TO APPLY',
                style: _theme.textTheme.bodyText1.copyWith(
                  color: _selectedTab == 1
                      ? Styleguide.color_green_4
                      : Styleguide.color_gray_9,
                ),
              ),
            ],
          ),
        ],
        onTap: (index) => _didSelectTab(index),
      ),
    );
  }

  Widget _buildTabContent() {
    Widget _howToApplyRegularDescription(String text) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle2.copyWith(height: 1.43),
        ),
      );
    }

    Widget _buildHowToApplyTab() {
      return Container(
        width: double.infinity,
        color: Styleguide.color_gray_0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.youtubeUrl != null && product.youtubeUrl.isNotEmpty)
              ContentfulYoutube(
                key: Key('youtube_video_url'),
                url: product.youtubeUrl,
              ),
            SizedBox(
              height: 17,
            ),
            if (product.howToApply != null)
              HowToUseCategory(
                  header: Text(
                    'How to Use ${product.name}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  description: ProductHtmlWrapper(
                    text: product.howToApply,
                  )),
            if (product.whenToApply != null)
              HowToUseCategory(
                  header: Text(
                    'When to Apply',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  description: ProductHtmlWrapper(
                    text: product.whenToApply,
                  )),
            if (product.howOftenToApply != null)
              HowToUseCategory(
                header: Text(
                  'How Often to Apply',
                  style: Theme.of(context).textTheme.headline5,
                ),
                description: _howToApplyRegularDescription(
                  '${product.howOftenToApply}',
                ),
              ),
            if (product.lawnCondition
                    .substring(1, product.lawnCondition.length - 1)
                    .isNotEmpty ||
                (product.minTemp != null && product.maxTemp != null) ||
                product.afterSeed != null)
              HowToUseCategory(
                header: Text(
                  'Additional Information',
                  style: Theme.of(context).textTheme.headline5,
                ),
                description: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make sure your lawn matches these conditions\n${product.name}\n',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(height: 1.43),
                      ),
                      if (product.lawnCondition
                          .substring(1, product.lawnCondition.length - 1)
                          .isNotEmpty)
                        AdditionalInformationBullet(
                          text: Text(
                              'For best results, apply to a ' +
                                  product.lawnCondition.substring(
                                      1, product.lawnCondition.length - 1) +
                                  ' lawn',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(height: 1.43)),
                        ),
                      if (product.minTemp != null && product.maxTemp != null)
                        AdditionalInformationBullet(
                          text: Text(
                              'Apply when temperatures are regularly in the ${product.minTemp}-${product.maxTemp}F range',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(height: 1.43)),
                        ),
                      if (product.afterSeed != null)
                        AdditionalInformationBullet(
                          text: Text('${product.afterSeed}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(height: 1.43)),
                        )
                    ],
                  ),
                ),
              ),
            if (product.spreaderSetting != null)
              HowToUseCategory(
                hasDivider: false,
                header: Text(
                  'Spreader Settings',
                  style: Theme.of(context).textTheme.headline5,
                ),
                description: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ProductHtmlWrapper(
                      text: product.spreaderSetting,
                    )),
              ),
            LocalOrdinances(),
          ],
        ),
      );
    }

    Widget _buildOverviewTab() {
      Widget _customExpansionText(String text) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text,
              style: _theme.textTheme.bodyText2.copyWith(height: 1.3)),
        );
      }

      return Container(
        color: _theme.colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (product.overviewBenefits != null)
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                child: Text(
                  'Benefits',
                  style: _theme.textTheme.headline5,
                ),
              ),
            if (product.overviewBenefits != null)
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ProductHtmlWrapper(
                    text: product.overviewBenefits,
                  )),
            Divider(thickness: 1),
            if (product.killsWeedList?.isNotEmpty)
              CustomExpansionTile(
                title: 'Weeds',
                child: _customExpansionText(
                    'Kills ' + product.killsWeedList.join(', ')),
              ),
            if (product.analysis != null)
              CustomExpansionTile(
                title: 'Fertilizer Analysis',
                child: _customExpansionText(product.analysis),
              ),
            if (product.disposalMethods != null)
              CustomExpansionTile(
                title: 'Disposal Methods',
                child: _customExpansionText(product.disposalMethods),
              ),
            if (product.kidsAndPets != null)
              CustomExpansionTile(
                title: 'Kids & Pets',
                child: _customExpansionText(product.kidsAndPets),
              ),
            if (product.cautions != null)
              CustomExpansionTile(
                title: 'Cautions',
                child: _customExpansionText(product.cautions),
              ),
            // CustomExpansionTile(
            //   title: 'View Product Label',
            //   child: Text(
            //     'something something',
            //     style: _theme.textTheme.bodyText2.copyWith(height: 1.5),
            //   ),
            // ),
            LocalOrdinances(),
          ],
        ),
      );
    }

    return _selectedTab == 0 ? _buildOverviewTab() : _buildHowToApplyTab();
  }

  Widget _buildTabbedDetailRow() {
    return Container(
      color: Styleguide.color_gray_1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 32,
            ),
            child: _buildTabController(),
          ),
          Container(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  void productApplied() {
    final isGuest = registry<AuthenticationBloc>().state.isGuest;
    if (isGuest) {
      buildLoginBottomCard(context);
    } else {
      showAppliedDialog(
        context: context,
        activityId: product.activityId,
        onAppliedSaved: (dateTime) {
          _tagAppliedEvent(product);

          adobeAppliedAction(product);
        },
        onComplete: () {
          registry<Logger>().d('onComplete');
        },
        bloc: registry<ActivityBloc>(),
      );

      //TODO: Eugene add needed fields from model when it will be added
      registry<AdobeRepository>().trackAppActions(
        PDPScreenProductAppliedAdobeAction(
          lawnCarePlanId: 'lawnCarePlanId',
          productName: 'productName',
          productId: 'productId',
        ),
      );
    }
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

  void productSkipped() {
    final isGuest = registry<AuthenticationBloc>().state.isGuest;
    if (isGuest) {
      buildLoginBottomCard(context);
    } else {
      showSkippedDialog(
        context: context,
        onSkippedSubmit: (reason, reasonText) {
          _tagSkipEvent(product, reason);

          adobeSkippedAction(product, reasonText);

          registry<Logger>().d('onSkippedSubmit: $reason $reasonText');
        },
        onComplete: () {
          registry<Logger>().d('onComplete');
        },
        activityId: product.activityId,
        bloc: registry<ActivityBloc>(),
      );

      registry<AdobeRepository>().trackAppActions(
        PDPScreenProductSkippedAdobeAction(
          lawnCarePlanId: 'lawnCarePlanId',
          productName: 'productName',
          productId: 'productId',
        ),
      );
    }
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

  void useProduct() {
    registry<Navigation>().push('/addproduct', arguments: product);
  }

  Widget _buildBottom(Product product) {
    final decoration = BoxDecoration(
      color: Styleguide.color_gray_0,
      boxShadow: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 1),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    );
    return Container(
      decoration: decoration,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if ((product.isSubscribed || product.isAddedByMe) &&
              isProductActiveInApplicationWindow() &&
              (!product.applied && !product.skipped))
            Container(
              margin: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: FullTextButton(
                key: Key('applied_button'),
                backgroundColor: _theme.primaryColor,
                color: Styleguide.color_gray_0,
                text: 'APPLIED',
                onTap: productApplied,
              ),
            ),
          if ((product.isSubscribed || product.isAddedByMe) &&
              isProductActiveInApplicationWindow() &&
              (!product.applied && !product.skipped))
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: FullTextButton(
                  backgroundColor: Styleguide.color_gray_0,
                  color: _theme.primaryColor,
                  text: 'SKIPPED',
                  onTap: productSkipped),
            ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: FullTextButton(
                backgroundColor: _theme.primaryColor,
                color: Styleguide.color_gray_0,
                text: 'USE THIS PRODUCT',
                onTap: useProduct),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButtonAction({
    BuildContext context,
    Product product,
  }) {
    final _theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(8),
      child: GestureDetector(
        child: Icon(
          Icons.more_vert,
          key: Key('info_more'),
          color: Styleguide.color_gray_9,
          size: 24,
        ),
        onTap: () async {
          var _isSuccess = false;
          return showBottomSheetDialog(
            color: Styleguide.color_gray_0,
            context: context,
            hasTopPadding: false,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              if (_isSuccess) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => registry<Navigation>().pop(),
                            child: Image.asset(
                              'assets/icons/cancel.png',
                              key: Key(
                                  'cancel_button_of_product_removed_bottom_sheet'),
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 16),
                        child: Center(
                          child: Container(
                            child: Image.asset(
                              'assets/icons/completed_outline.png',
                              height: 64,
                              width: 64,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Product Removed!',
                        style: _theme.textTheme.headline2,
                      ),
                      SizedBox(height: 52)
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            product.isSubscribed
                                ? 'Product can’t be removed from your plan!'
                                : 'Remove this product from your lawn plan?',
                            style: _theme.textTheme.headline2),
                      ),
                      SizedBox(height: 16),
                      Text(product.isSubscribed
                          ? 'As it is part of your active subscription. If you wish to make any changes to your subscription, please go to My Subscription Screen.'
                          : 'You cannot undo this action'),
                      if (!product.isSubscribed) SizedBox(height: 30),
                      if (!product.isSubscribed)
                        FullTextButton(
                          key: Key('remove_product'),
                          backgroundColor: _theme.primaryColor,
                          color: Styleguide.color_gray_0,
                          text: 'REMOVE',
                          onTap: () {
                            _bloc.add(
                                DeleteProductActivitiesEvent(product: product));
                            setState(() {
                              _isSuccess = true;
                            });
                          },
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: FullTextButton(
                          key: Key('back_button_of_remove_product'),
                          text: 'BACK',
                          color: Styleguide.color_green_4,
                          onTap: () => registry<Navigation>().pop(),
                          border: null,
                          backgroundColor: Styleguide.color_gray_0,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return BlocListener<LoginBloc, LoginState>(
      cubit: registry<LoginBloc>(),
      listener: (context, state) {
        if (state is PendingRegistrationState) {
          registry<Navigation>().push(
            '/auth/pendingregistration',
            arguments: {'email': state.email, 'regToken': state.regToken},
          );
        }
      },
      child: BlocConsumer<ProductBloc, ProductState>(
        cubit: _bloc,
        listenWhen: (previous, current) => (previous is! ProductFetchedState &&
            current is ProductFetchedState),
        listener: (context, state) {
          product.childProducts.forEach((element) {
            bagQuantityList[element] = element.quantity ?? 0;
          });

          if (bagQuantityList.isEmpty) bagQuantityList[product] = 0;

          if (product.isSubscribed == true ||
              product.isAddedByMe == true ||
              (product.isSubscribed && product.isAddOn)) {
            expandedHeight += badgeHeight;
          }
        },
        builder: (context, state) {
          if (state is! ProductFetchedState) {
            return BasicScaffoldWithAppBar(
                appBarElevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is ErrorProductState)
                      ErrorMessage(
                          errorMessage: '${state.errorMessage}',
                          retryRequest: () =>
                              _bloc.add(ProductFetchEvent(product: product))),
                    if (state is LoadingProductState)
                      Center(
                        child: Container(
                            height: 32, width: 32, child: ProgressSpinner()),
                      ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ));
          } else {
            return Scaffold(
              bottomNavigationBar: _buildBottom(product),
              body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    titleSpacing: 0,
                    actions: [
                      if ((state is ProductFetchedState &&
                              !state.isFakeActivity) &&
                          isGuest == false &&
                          (product.isRecommended ||
                              product.isAddedByMe ||
                              product.isSubscribed))
                        _buildMoreButtonAction(
                          product: product,
                          context: context,
                        ),
                    ],
                    leading: BackButton(
                      key: Key('back_button'),
                      color: _theme.colorScheme.onBackground,
                      onPressed: registry<Navigation>().pop,
                    ),
                    floating: false,
                    pinned: true,
                    expandedHeight: expandedHeight,
                    title: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.headline4,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProductHeader(product: product),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 24),
                          color: Styleguide.color_gray_0,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (product.categoryList.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 9.0),
                                  key: Key('product_details_category_label'),
                                  child: Text(
                                    product.categoryList
                                        .map((e) => e.toUpperCase())
                                        .toList()
                                        .join(' - '),
                                    style: _theme.textTheme.bodyText2,
                                    key: Key('product_category_text'),
                                  ),
                                ),
                              Text(
                                product.name,
                                style: _theme.textTheme.headline3.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.22,
                                ),
                                key: Key('product_name'),
                              ),
                              MiniClaims(product: product)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(thickness: 1),
                        ),
                        _buildCoverageCalculatorSection(),
                        _buildTabbedDetailRow(),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class LocalOrdinances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      color: Styleguide.color_gray_1,
      padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
      child: Text(
        'Check your local ordinances for product & water application restrictions. Always read and follow label instructions.',
        style:
            _theme.textTheme.bodyText2.copyWith(fontSize: 11, height: 1.3636),
        textAlign: TextAlign.center,
      ),
    );
  }
}
