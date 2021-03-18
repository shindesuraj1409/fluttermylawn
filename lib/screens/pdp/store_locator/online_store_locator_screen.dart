// ML.SC.016: Buy Online Screen
import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/pdp/online_store_locator_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PDP_screen/state.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineStoreLocatorScreen extends StatefulWidget {
  @override
  _OnlineStoreLocatorScreenState createState() =>
      _OnlineStoreLocatorScreenState();
}

class _OnlineStoreLocatorScreenState extends State<OnlineStoreLocatorScreen>
    with RouteMixin<OnlineStoreLocatorScreen, String> {
  OnlineStoreLocatorModel _model;

  @override
  void initState() {
    super.initState();
    adobeCallState();

    _model = OnlineStoreLocatorModel();
  }

  void adobeCallState() {
    registry<AdobeRepository>().trackAppState(
      BuyOnlineAdobeState(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      _model.searchSellers(routeArguments);
    }
  }

  void _retrySearch() {
    _model.searchSellers(routeArguments);
  }

  void _openUrl(OnlineSeller seller) async {
    final url = seller.addToCartRedirectUrl ?? seller.redirectUrl;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      isNotUsingWillPop: true,
      titleString: 'Buy Online',
      backgroundColor: Styleguide.nearBackground(theme),
      childFillsRemainingSpace: true,
      hasScrollBody: true,
      child: busStreamBuilder<OnlineStoreLocatorModel, OnlineStoresData>(
        busInstance: _model,
        builder: (context, model, data) {
          switch (data.state) {
            case OnlineStoreState.initial:
            case OnlineStoreState.loading:
              return Center(child: ProgressSpinner());
              break;
            case OnlineStoreState.error:
              return ErrorMessage(
                errorMessage: '${data.errorMessage}',
                retryRequest: _retrySearch,
              );
            case OnlineStoreState.success:
              if (data.sellers.isEmpty) {
                return _NoSellerFound();
              }

              final itemCount = data.sellers.length;

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 32),
                itemCount: itemCount,
                separatorBuilder: (_, index) {
                  if (data.containsScotts && index == 0) {
                    return Container(
                      child: Text(
                        'Partner Retailers',
                        style: theme.textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                    );
                  } else {
                    return Divider();
                  }
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    key: Key('retailer_card_el_$index'),
                    color: theme.colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListTile(
                        onTap: () => _openUrl(data.sellers[index]),
                        contentPadding: const EdgeInsets.all(0),
                        leading: Image.network(
                          'https:${data.sellers[index].smallLogoUrl}',
                          width: 64,
                          height: 64,
                          key: Key(data.sellers[index].name),
                        ),
                        title: Text(
                          data.sellers[index].inStock
                              ? 'In Stock'
                              : 'See Website',
                          style: theme.textTheme.bodyText2,
                          key: Key('in_stock_see_website_$index'),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () => _openUrl(data.sellers[index]),
                          key: Key('trailing_icon_$index'),
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              throw UnimplementedError('Incorrect state reached');
          }
        },
      ),
    );
  }
}

class _NoSellerFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/icons/not_found.png',
            width: 64,
            height: 64,
            key: Key('not_found_icon'),
          ),
          SizedBox(height: 16),
          Text(
            'Product cannot be found online at moment.',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline1,
          ),
          SizedBox(height: 8),
          Text(
            'Try another product or see what’s popular in your area',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
