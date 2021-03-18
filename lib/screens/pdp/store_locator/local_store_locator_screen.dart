import 'package:app_settings/app_settings.dart';
import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/pdp/local_store_locator_model.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_list_view.dart';
import 'package:my_lawn/screens/pdp/store_locator/widgets/store_map_view.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:navigation/navigation.dart';

class LocalStoreLocatorScreenArguments extends Data {
  final String zipCode;
  final String productId;

  LocalStoreLocatorScreenArguments({this.zipCode, this.productId});

  @override
  List<Object> get props => [zipCode, productId];
}

class LocalStoreLocatorScreen extends StatefulWidget {
  @override
  _LocalStoreLocatorScreenState createState() =>
      _LocalStoreLocatorScreenState();
}

class _LocalStoreLocatorScreenState extends State<LocalStoreLocatorScreen>
    with RouteMixin<LocalStoreLocatorScreen, LocalStoreLocatorScreenArguments> {
  TextEditingController _searchController;

  LocalStoreLocatorModel _model;
  BitmapDescriptor selectedStoreMarker;
  BitmapDescriptor unselectedStoreMarker;

  @override
  void initState() {
    super.initState();
    _model = LocalStoreLocatorModel();

    // This is because we need access to devicePixelRatio using MediaQuery
    // And, this needs to be done over here instead of inside `StoreMapView` widget
    // because StoreMapView build method is not fired until user goes to MapView and by then
    // if data loading is complete we might have already initialized all the markers icons
    // referring to uninitialized `unselectedStoreMarker` and `selectedStoreMarker` values in there
    // if we move this marker initialization logic to `initState()` of `StoreMapView` widget.
    // That is reason we need to do this initialization over here and pass on marker icons
    // to StoreMapView from here.
    Future.delayed(
      Duration.zero,
      () async {
        final mediaQueryData = MediaQuery.of(context);

        // unselected store marker
        unselectedStoreMarker = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            devicePixelRatio: mediaQueryData.devicePixelRatio,
            size: Size(32, 32),
          ),
          'assets/icons/unselected_store_marker.png',
        );

        // selected store marker
        selectedStoreMarker = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            devicePixelRatio: mediaQueryData.devicePixelRatio,
            size: Size(32, 32),
          ),
          'assets/icons/selected_store_marker.png',
        );
      },
    );

    // Listen to current location's zip code when user tries to search "stores"
    // by current location. In that case we need to update our search text field
    // with current location's "zip code" we get from `geolocator` plugin in our model.
    _model
        .stream<String>(name: 'currentLocationZipCode')
        .takeWhile((_) => mounted)
        .listen((zipCode) {
      _searchController.text = zipCode;
    });

    // Listen to permission error state and show dialog asking user to enable
    // "location permission" in order to use "search stores by location" feature.
    _model.stream<LocalStoresData>().takeWhile((_) => mounted).listen(
      (data) {
        if (data.state == LocalStoreState.permissionError) {
          showDialog(
            context: context,
            builder: (context) {
              return PlatformAwareAlertDialog(
                title: Text('Permission Denied'),
                content: Text(data.state.errorMessage),
                actions: [
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text('Open Settings'),
                    onPressed: () {
                      Navigator.pop(context);
                      AppSettings.openAppSettings();
                    },
                  )
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null &&
        routeArguments.zipCode != null &&
        routeArguments.productId != null) {
      _model.productId = routeArguments.productId;

      if (_searchController == null) {
        _searchController = TextEditingController();
        _model.onZipCodeChanged(routeArguments.zipCode);
        _searchController.text = routeArguments.zipCode;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          leading: BackButton(
            color: theme.colorScheme.onBackground,
            onPressed: () => registry<Navigation>().pop(),
          ),
          centerTitle: true,
          title: FractionallySizedBox(
            widthFactor: 0.6,
            child: TabBar(
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.primaryColor, width: 2),
                ),
              ),
              labelColor: theme.primaryColor,
              unselectedLabelColor: theme.colorScheme.onBackground,
              labelStyle: theme.textTheme.bodyText1,
              unselectedLabelStyle: theme.textTheme.bodyText1,
              tabs: <Widget>[
                Tab(child: Text('LIST')),
                Tab(child: Text('MAP')),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'assets/icons/enable_location.png',
                key: Key('enable_location'),
                width: 24,
                height: 24,
              ),
              onPressed: () => _model.searchByLocation(),
            ),
          ],
        ),
        body: busStreamBuilder<LocalStoreLocatorModel, LocalStoresData>(
          busInstance: _model,
          builder: (context, model, data) {
            return Stack(
              children: <Widget>[
                TabBarView(
                  // This is because we have `GoogleMap` as one of our TabBarView
                  // and we don't want TabBarView gestures to intefere with
                  // GoogleMap gestures so better not have default gesture of  TabBarView
                  // of scrolling left-right swiping for changing tabs enabled by
                  // setting `physics` to be `NeverScrollableScrollPhysics`
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    StoreListView(data: data),
                    StoreMapView(
                      data: data,
                      selectedStoreMarker: selectedStoreMarker,
                      unselectedStoreMarker: unselectedStoreMarker,
                    ),
                  ],
                ),
                _buildSearchTextField(theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchTextField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Container(
        color: theme.colorScheme.surface,
        child: TextField(
          key: Key('enter_zipcode'),
          keyboardType: TextInputType.number,
          controller: _searchController,
          onChanged: _model.onZipCodeChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface,
            ),
            suffixIcon: _searchController.text != null &&
                    _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Image.asset(
                      'assets/icons/cancel.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () => setState(() {
                      _searchController.text = '';
                    }),
                  )
                : null,
            hintText: 'Enter zipcode',
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
