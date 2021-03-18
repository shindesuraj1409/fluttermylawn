import 'dart:typed_data';
import 'dart:ui';

import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/scotts_latlng.dart';
import 'package:my_lawn/data/quiz/location_data.dart';
import 'package:my_lawn/data/quiz/tracing_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/quiz/tracing_model.dart';
import 'package:my_lawn/screens/quiz/widgets/lawn_size_limit_dialog.dart';
import 'package:navigation/navigation.dart';

import '../../config/colors_config.dart';
import '../../models/theme_model.dart';

const lawnSizeLimitMapError = '''
Unfortunately we don't have plans to support very large lawns above 2,00,000 square feet.

You can outline a smaller lawn size, or get in touch with our team to get help.
''';

class LawnTracingScreen extends StatefulWidget {
  @override
  _LawnTracingScreenState createState() => _LawnTracingScreenState();
}

class _LawnTracingScreenState extends State<LawnTracingScreen>
    with RouteMixin<LawnTracingScreen, LocationData> {
  final theme = busSnapshot<ThemeModel, ThemeData>();
  BitmapDescriptor markerIcon;
  BitmapDescriptor deleteMarkerIcon;

  String _address;
  ScottsLatLng _location;

  EdgeInsets fabPaddingWithoutAreaCard;
  EdgeInsets fabPaddingWithAreaCard;

  CameraPosition _initialCameraPosition;

  TracingModel _tracingModel;

  @override
  void initState() {
    super.initState();

    _tracingModel = TracingModel();

    getMarkerIconData(48, 48).then((markerData) {
      markerIcon = BitmapDescriptor.fromBytes(markerData);
      _tracingModel.setMarkerIcon(markerIcon);
    });

    getDeleteMarkerIconData(140, 80).then((deleteMarkerData) {
      deleteMarkerIcon = BitmapDescriptor.fromBytes(deleteMarkerData);
      _tracingModel.setDeleteMarkerIcon(deleteMarkerIcon);
    });

    fabPaddingWithAreaCard = EdgeInsets.only(right: 24.0, bottom: 220.0);
    fabPaddingWithoutAreaCard = EdgeInsets.only(right: 24.0, bottom: 48.0);

    _showDialog();

    _tracingModel
        .stream<TracingData>()
        .takeWhile((_) => mounted)
        .listen((tracingData) {
      if (tracingData.totalArea > 200000) {
        showLawnSizeLimitErrorDialog(
          context: context,
          errorMessage: lawnSizeLimitMapError,
          onUpdateLawnSize: () => _tracingModel.clearTrace(),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_address == null && _location == null) {
      _address = routeArguments.address;
      _location = routeArguments.latLng;
      _initialCameraPosition = CameraPosition(
        target: LatLng(_location.latitude, _location.longitude),
        zoom: 5,
      );
    }
  }

  void _showDialog() async {
    // As we've single loop for "tracing.gif", if someones opens this screen for 2nd time(going back and forth)
    // the gif doesn't loads if it has completed its one and only loop.
    // So, we need to evict "tracing.gif" from ImageCache before showing instruction dialog.
    try {
      imageCache.evict(AssetBundleImageKey(
        bundle: rootBundle,
        name: 'assets/gifs/tracing.gif',
        scale: 1.0,
      ));
    } catch (e) {
      // Ignoring cache evict error
    }

    // This needs to be added so we've our build method executed at least once
    // before `showDialog()` is called and the `context` is initialized correctly
    // to be used in `showDialog()` method.
    await Future.delayed(Duration.zero);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'To measure your lawn, start by tapping on each corner. This will create a basic outline.',
          style: theme.textTheme.headline6.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              // This is because gif is not correctly centered and is left aligned.
              // Look at assets/gifs/tracing.gif to see what i mean.
              padding: const EdgeInsets.only(left: 48.0),
              child: Image.asset(
                'assets/gifs/tracing.gif',
                key: Key('tracing_gif'),
                height: 144.0,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: RaisedButton(
                key: Key('got_it'),
                onPressed: () {
                  registry<Navigation>().popTo('/quiz/tracing');
                },
                child: Text('GOT IT'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTextField(String address) => Container(
        height: 48.0,
        width: double.infinity,
        color: theme.cardColor,
        child: Row(
          children: <Widget>[
            BackButton(
              onPressed: () {
                registry<Navigation>().pop();
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.subtitle2,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildInstructionCard(String instruction) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Styleguide.color_accents_yellow_1,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            instruction,
            style: theme.textTheme.headline6.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      );

  Widget _buildUndoFAB(bool isVisible, double totalArea, TracingModel model) =>
      Visibility(
        visible: isVisible,
        child: Padding(
          padding: totalArea > 0
              ? fabPaddingWithAreaCard
              : fabPaddingWithoutAreaCard,
          child: FloatingActionButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/undo.png',
                  width: 24.0,
                  height: 24.0,
                ),
                Text(
                  'Undo',
                  style: theme.textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.12,
                  ),
                )
              ],
            ),
            onPressed: model.undo,
            backgroundColor: theme.colorScheme.onPrimary,
          ),
        ),
      );

  Widget _buildLawnAreaEstimateCard(double totalArea) => Visibility(
        visible: totalArea > 0,
        child: Container(
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('EST. LAWN SIZE', style: theme.textTheme.bodyText2),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          '${totalArea.truncate()}',
                          style: theme.textTheme.headline2.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text('sqft', style: theme.textTheme.bodyText2)
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (totalArea > 200000) {
                        showLawnSizeLimitErrorDialog(
                          context: context,
                          errorMessage: lawnSizeLimitMapError,
                        );
                        return;
                      }
                      registry<Navigation>().pop(totalArea);
                    },
                    child: Text('SAVE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: busStreamBuilder<TracingModel, TracingData>(
        busInstance: _tracingModel,
        builder: (context, model, data) {
          final markers = data.markers;
          final polylines = data.polylines;
          final polygons = data.polygons;
          final totalArea = data.totalArea;

          return Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _initialCameraPosition,
                markers: markers,
                polylines: polylines,
                polygons: polygons,
                onMapCreated: (controller) => model.onMapReady(controller,
                    LatLng(_location.latitude, _location.longitude)),
                onTap: model.onMapClicked,
                myLocationButtonEnabled: false,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        _buildAddressTextField(_address),
                        SizedBox(height: 16),
                        if (markers.isNotEmpty &&
                            polylines.isNotEmpty &&
                            markers.length == polylines.length)
                          _buildInstructionCard(
                              'If you have another area to add, simply start the process again.'),
                        if (markers.isNotEmpty && polygons.isEmpty)
                          _buildInstructionCard(
                              'When your outline is all finished, connect the first and last points. This will complete the diagram.'),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: _buildUndoFAB(markers.isNotEmpty, totalArea, model),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildLawnAreaEstimateCard(totalArea),
              )
            ],
          );
        },
      ),
    );
  }
}

// Creates marker icon using Canvas and converts into png data.
Future<Uint8List> getMarkerIconData(double width, double height) async {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(
    pictureRecorder,
    Rect.fromPoints(
      Offset(0.0, 0.0),
      Offset(width, height),
    ),
  );

  final circleRadius = (width - 4) / 2;

  final paintCircle = Paint()
    ..color = Styleguide.color_green_1
    ..style = PaintingStyle.fill;

  final paintBorder = Paint()
    ..color = Styleguide.color_gray_0
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  canvas.drawCircle(Offset(width / 2, height / 2), circleRadius, paintCircle);
  canvas.drawCircle(Offset(width / 2, height / 2), circleRadius, paintBorder);

  final img = await pictureRecorder
      .endRecording()
      .toImage(width.toInt(), height.toInt());
  final data = await img.toByteData(format: ImageByteFormat.png);
  return data.buffer.asUint8List();
}

// Creates delete marker icon using Canvas and converts into png data.
Future<Uint8List> getDeleteMarkerIconData(double width, double height) async {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(
    pictureRecorder,
    Rect.fromPoints(
      Offset(0.0, 0.0),
      Offset(width, height),
    ),
  );

  final paint = Paint()..color = Styleguide.color_accents_red;
  final rectHeight = height * 0.8;

  final path = Path()
    ..moveTo(width, rectHeight)
    ..lineTo(width, 0)
    ..lineTo(0, 0)
    ..lineTo(0, rectHeight)
    ..lineTo(width * 0.4, rectHeight)
    ..lineTo(width * 0.5, height)
    ..lineTo(width * 0.6, rectHeight);
  path.close();

  canvas.drawPath(path, paint);

  final painter = TextPainter(textDirection: TextDirection.ltr);
  painter.text = TextSpan(
    text: 'Delete',
    style: TextStyle(fontSize: 24.0, color: Styleguide.color_gray_0),
  );
  painter.layout();
  painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5,
          (height * 0.5) - painter.height * 0.7));

  final img = await pictureRecorder
      .endRecording()
      .toImage(width.toInt(), height.toInt());
  final data = await img.toByteData(format: ImageByteFormat.png);
  return data.buffer.asUint8List();
}
