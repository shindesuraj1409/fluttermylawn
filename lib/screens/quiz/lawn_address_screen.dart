import 'package:app_settings/app_settings.dart';
import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/location_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/quiz/lawn_address_model.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/services/geo/geo_service_exceptions.dart';
import 'package:my_lawn/widgets/animated_linear_progress_indicator_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class LawnAddressScreen extends StatefulWidget {
  @override
  _LawnAddressScreenState createState() => _LawnAddressScreenState();
}

class _LawnAddressScreenState extends State<LawnAddressScreen>
    with RouteMixin<LawnAddressScreen, LawnData> {
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Image _clearSearchIcon = Image.asset(
    'assets/icons/cancel.png',
    width: 24,
    height: 24,
  );

  final Image _enableLocationIcon = Image.asset(
    'assets/icons/enable_location.png',
    width: 24,
    height: 24,
  );

  LawnAddressModel _model;
  QuizModel _quizModel;
  LawnData _lawnData;

  @override
  void initState() {
    super.initState();
    _model = LawnAddressModel();
    _model.stream<LawnAddressData>().takeWhile((_) => mounted).listen((data) {
      if (data.state == LawnAddressState.permissionError) {
        _showPermissionErrorDialog();
      } else if (data.state == LawnAddressState.placesAutoCompleteError) {
        _showErrorMessage('Cannot find places with the search text entered');
      } else if (data.state == LawnAddressState.locationFetchError) {
        _showErrorMessage(
            'Unable to fetch your current location. Please try again');
      } else if (data.state == LawnAddressState.success &&
          data.locationData != null) {
        _addressController.text = data.locationData.address;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      _lawnData = routeArguments;
    } else {
      _quizModel = registry<QuizModel>();
    }
  }

  @override
  void dispose() {
    _addressController.clear();
    _addressController.dispose();
    super.dispose();
  }

  void _showErrorMessage(String errorMessage) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return PlatformAwareAlertDialog(
          title: Text('Permission Denied'),
          content: Text(
            "To use this feature please allow this app access to the location by changing it in the device's settings.",
          ),
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

  void _onPlaceSelected(LawnAddressModel model, String address) async {
    _addressController.text = address;
    final locationData = await model.fetchPlaceDetails(address);
    final updatedLocationData = locationData.copyWith(address: address);

    if (locationData != null) {
      _navigateToLawnTraceScreen(updatedLocationData);
    }
  }

  void _navigateToLawnTraceScreen(LocationData locationData) async {
    FocusScope.of(context).unfocus();
    final lawnArea = await registry<Navigation>().push(
      '/quiz/tracing',
      arguments: locationData,
    ) as double;

    if (lawnArea != null) {
      // If LawnData is received in arguments it means this screen was opened
      // from EditLawnProfile screen. So, we're just saving info to lawn profile
      // and closing the screen
      if (_lawnData != null) {
        _saveLawnProfile(lawnArea.toInt(), locationData);
      } else {
        _saveAnswer(
            lawnArea: lawnArea.toInt(),
            zipCode: locationData.zipCode,
            locationData: locationData,
            inputType: 'map');

        registry<AdobeRepository>().trackAppState(GrassTypeScreenState(
            lawnSizeCalculated: lawnArea.toString(),
            zip: locationData.zipCode,
            typeOfInput: 'map'));
      }
    }
  }

  void _navigateToManualLawnAreaZipCodeScreen() async {
    // Get data from lawnsizezipcode screen
    final results = await registry<Navigation>().push('/quiz/lawnsizezipcode')
        as List<String>;

    registry<AdobeRepository>().trackAppState(LawnSizeManualState());

    if (results != null && results.isNotEmpty) {
      final lawnArea = results[0];
      final zipCode = results[1];

      if (lawnArea != null) {
        if (_quizModel != null) {
          _saveAnswer(
              lawnArea: int.parse(lawnArea),
              zipCode: zipCode,
              inputType: 'manual');
        } else {
          _saveLawnProfile(int.parse(lawnArea), LocationData(zipCode: zipCode));
        }
        registry<AdobeRepository>().trackAppState(GrassTypeScreenState(
            lawnSizeCalculated: lawnArea, zip: zipCode, typeOfInput: 'manual'));
      }
    }
  }

  void _saveLawnProfile(int totalArea, LocationData locationData) {
    if (totalArea > 0 && locationData.zipCode != null) {
      final currentLawnData = _lawnData;
      final updatedLawnData = currentLawnData.copyWith(
        lawnSqFt: totalArea,
        lawnAddress: AddressData(
          city: locationData.city,
          state: locationData.state,
          address1: locationData.address,
          zip: locationData.zipCode,
        ),
      );

      registry<Navigation>().pop<LawnData>(updatedLawnData);
    }
  }

  void _saveAnswer(
      {int lawnArea,
      String zipCode,
      LocationData locationData,
      String inputType}) async {
    // Get Lawn zone from zipCode
    try {
      final lawnZone = await _model.getLawnZone(zipCode);

      _quizModel.saveAddressInfo(
          lawnArea: lawnArea,
          zipCode: zipCode,
          lawnZone: lawnZone,
          locationData: locationData,
          inputType: inputType);

      // Move to next screen in quiz flow
      unawaited(registry<Navigation>().push('/quiz/grasstype'));
    } on InvalidZipException catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.errorMessage),
        ),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Error! Something went wrong. Please try again.'),
        ),
      );
    }
  }

  List<Widget> _buildBackgroundContainer() {
    return [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/lawn_address_screen_background.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Styleguide.color_gray_9.withOpacity(0.35),
        ),
      ),
    ];
  }

  Widget _buildAreaInput(LawnAddressModel model, LawnAddressData data) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            key: Key('lawn_address_screen_address_input'),
            onChanged: model.onAddressChange,
            controller: _addressController,
            style: theme.textTheme.subtitle2,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 16,
                left: 8,
              ),
              hintText: 'Enter your lawn address',
              hintStyle: theme.textTheme.bodyText2,
              suffixIcon: IconButton(
                key: Key('lawn_size_screen_location_icon_button'),
                icon: _addressController.text.isNotEmpty
                    ? _clearSearchIcon
                    : _enableLocationIcon,
                onPressed: () {
                  if (_addressController.text.isNotEmpty) {
                    _addressController.clear();
                    model.clearSearch();
                  } else {
                    model.searchByLocation();
                  }
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: data.state == LawnAddressState.loading,
          child: SizedBox(
            width: 16,
            height: 16,
            child: ProgressSpinner(
              strokeWidth: 2,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLawnSizeCard(
    BuildContext context,
    double cardHeight,
    LawnAddressModel model,
    LawnAddressData data,
  ) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: cardHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32,
            left: 24,
            right: 24,
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'What size is your lawn?',
                      style: theme.textTheme.headline2.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 32),
                    _buildAreaInput(model, data),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  ListTile.divideTiles(
                    context: context,
                    color: Styleguide.color_gray_2,
                    tiles: data.predictions.map(
                      (prediction) {
                        final address = prediction.description;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => _onPlaceSelected(model, address),
                          title: Text(
                            '${address}',
                            key: Key(address),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.subtitle2,
                          ),
                        );
                      },
                    ).toList(),
                  ).toList(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 40),
                    // We need to show manual zip code and lawn size screen link
                    // only when in quiz flow

                    TappableText(
                      key: Key(
                          'lawn_address_screen_square_footage_manually_link'),
                      onTap: _navigateToManualLawnAreaZipCodeScreen,
                      child: Text(
                        'I ALREADY KNOW THE SQUARE FOOTAGE OF MY LAWN.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText1.copyWith(
                          color: theme.colorScheme.primary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: RaisedButton(
                        onPressed: data.locationData == null
                            ? null
                            : () => _navigateToLawnTraceScreen(
                                    data.locationData.copyWith(
                                  address: _addressController.text,
                                )),
                        child: Text('CONTINUE'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.55;
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          ...(_buildBackgroundContainer()),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: theme.colorScheme.onPrimary,
                    onPressed: () => registry<Navigation>().pop(),
                    key: Key('back_button'),
                  ),
                  if (_quizModel != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: AnimatedLinearProgressIndicator(
                          initialValue: 0.50,
                          finalValue: 0.75,
                          backgroundColor: theme.colorScheme.background,
                          foregroundColor: theme.colorScheme.secondaryVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          busStreamBuilder<LawnAddressModel, LawnAddressData>(
            busInstance: _model,
            builder: (context, model, data) {
              return _buildLawnSizeCard(context, cardHeight, model, data);
            },
          ),
          // This is to add layer on top of screen when we're fetching "lawn zone" from "zip code" value
          // using geo service api and showing loading indicator during on top of it
          busStreamBuilder<LawnAddressModel, LawnZoneState>(
            busInstance: _model,
            builder: (_, __, data) {
              switch (data) {
                case LawnZoneState.initial:
                case LawnZoneState.success:
                case LawnZoneState.error:
                case LawnZoneState.invalidZipCodeError:
                  return SizedBox();
                case LawnZoneState.loading:
                  return Container(
                    decoration: BoxDecoration(
                      color: Styleguide.color_gray_9.withOpacity(0.35),
                    ),
                    child: Center(child: ProgressSpinner()),
                  );
                default:
                  throw UnimplementedError(
                      'Incorrect LawnZoneState reached : ${data}');
              }
            },
          ),
        ],
      ),
    );
  }
}
