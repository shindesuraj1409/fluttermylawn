import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/water_model_data.dart';
import 'package:my_lawn/extensions/double_extension.dart';
import 'package:my_lawn/extensions/nozzle_type_extension.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_action_bar.dart';
import 'package:my_lawn/screens/home/actions/widgets/activity_dialog_content.dart';
import 'package:my_lawn/screens/home/actions/widgets/lawn_utils.dart';
import 'package:my_lawn/screens/home/actions/widgets/picker_widget.dart';
import 'package:my_lawn/services/analytic/actions/localytics/customize_plan_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/widgets/rainfall_track_widget/rainfall_chart_widget.dart';
import 'package:my_lawn/widgets/rainfall_track_widget/watering_widget.dart';
import 'package:navigation/navigation.dart';

import '../progress_spinner_widget.dart';

class RainfallTrackCardWidget extends StatefulWidget {
  final Function getWeatherData;
  final String zipCode;

  RainfallTrackCardWidget({
    Key key,
    this.getWeatherData,
    this.zipCode,
  }) : super(key: key);

  @override
  _RainfallTrackCardWidgetState createState() =>
      _RainfallTrackCardWidgetState();
}

class _RainfallTrackCardWidgetState extends State<RainfallTrackCardWidget> {
  bool _isShowGraph = true;
  bool _isShowGraphContainer = false;
  double graphBadgeMargin = 0;
  double rainContainerHeight = 0;
  bool isInch = true;

  NozzleType selectedNozzleType;
  final dateFormat = DateFormat('MMM dd');
  final isGuest = registry<AuthenticationBloc>().state.isGuest;

  BoxDecoration _radioDecoration(Color color, double radius) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      );

  void _showSprinklerDialog(
      List<NozzleType> nozzleTypes, NozzleType nozzleType) {
    showBottomSheetDialog(
      context: context,
      title: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          '${nozzleType.name} Flow Rate',
          key: Key('weather_data_loaded_widget'),
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(height: 0, color: Styleguide.color_gray_9),
        ),
      ),
      hasDivider: false,
      isFullScreen: false,
      trailingPositioned: Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: Image.asset(
            'assets/icons/cancel.png',
            height: 24,
            width: 24,
            color: Styleguide.color_gray_9,
            key: Key('cancel_button_of_sprinkler_flow_rate'),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'An average applies ${(nozzleType.rate * 30).asFractionInchesString} inch of water every 30 minutes. You can modify this flow rate for your sprinkler nozzle. It\'s recommended to water a total of 1 inch per week',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Styleguide.color_gray_9, height: 1.5),
          ),
          Container(
              margin: EdgeInsets.only(top: 50),
              child: ButtonTheme(
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FlatButton(
                  key: Key('customize_button_of_sprinkler_flow_rate'),
                  color: Styleguide.color_green_4,
                  padding: EdgeInsets.all(16.0),
                  onPressed: () {
                    Future.delayed(Duration(microseconds: 200),
                        () => _showNozzleTypeDialog(nozzleTypes, nozzleType));
                    registry<Navigation>().pop();
                  },
                  child: Text(
                    'CUSTOMIZE',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Styleguide.color_gray_0),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  void _showNozzleTypeDialog(
      List<NozzleType> nozzleTypes, NozzleType nozzleType) {
    Widget SpinklerItemWidget(NozzleType nozzleType) {
      final _theme = Theme.of(context);
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedNozzleType = nozzleType;
          });
          Future.delayed(Duration(microseconds: 200), () {
            _showSprinklerRateDialog(nozzleTypes, nozzleType);
          });
          registry<Navigation>().pop();
        },
        child: Container(
          key: Key('grid_view_item_of_sprinkler_flow_rate_${nozzleType.name}'),
          decoration: _radioDecoration(
              selectedNozzleType.name == nozzleType.name
                  ? Styleguide.color_green_2
                  : _theme.colorScheme.onPrimary,
              8.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Visibility(
                visible: nozzleType == selectedNozzleType,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/icons/un_bookmark.png',
                    width: 30,
                    height: 40,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/${nozzleType.name.toLowerCase()}.png',
                        width: 70,
                        height: 70,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          nozzleType.name,
                          style: _theme.textTheme.subtitle1.copyWith(
                              color: selectedNozzleType == nozzleType
                                  ? _theme.colorScheme.onPrimary
                                  : _theme.colorScheme.primary),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    showScrollableBottomSheetDialog(
      context: context,
      title: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          'What\'s your nozzle type?',
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(height: 0, color: Styleguide.color_gray_9),
        ),
      ),
      hasDivider: false,
      trailingPositioned: Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: Image.asset(
            'assets/icons/cancel.png',
            height: 24,
            width: 24,
            color: Styleguide.color_gray_9,
            key: Key('cancel_button_of_sprinkler_flow_rate_bottom_sheet'),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 34),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                  'Select nozzle type to set your flow rate. It helps more accurate runtime for your sprinkler.',
                  style: Theme.of(context).textTheme.subtitle2),
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                key: Key('grid_view_of_sprinkler_flow_rate'),
                childAspectRatio: MediaQuery.of(context).size.width / 2 / 180,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: EdgeInsets.only(
                  bottom: 4,
                ),
                shrinkWrap: true,
                children: List.generate(
                  nozzleTypes.length,
                  (index) {
                    return SpinklerItemWidget(nozzleTypes[index]);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TappableText(
                child: Text(
                  'BACK',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                ),
                onTap: () {
                  Future.delayed(
                    Duration(microseconds: 200),
                    () => _showSprinklerDialog(nozzleTypes, nozzleType),
                  );
                  registry<Navigation>().pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSprinklerRateDialog(
      List<NozzleType> nozzleTypes, NozzleType selectedNozzleType) {
    final _theme = Theme.of(context);

    showBottomSheetDialog(
      context: context,
      hasDivider: false,
      isFullScreen: false,
      trailingPositioned: Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: Image.asset(
            'assets/icons/cancel.png',
            height: 24,
            width: 24,
            color: Styleguide.color_gray_9,
            key: Key('cancel_button_of_selected_nozzle_type'),
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 24, top: 10, right: 24),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/${selectedNozzleType.name.toLowerCase()}.png',
                      width: 64,
                      height: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${selectedNozzleType.name} Flow Rate',
                            style: _theme.textTheme.subtitle2.copyWith(
                              color: Styleguide.color_gray_9,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: selectedNozzleType.nozzleRateString,
                                style: _theme.textTheme.headline1
                                    .copyWith(letterSpacing: 0),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'mins / inch',
                                    style: _theme.textTheme.bodyText2.copyWith(
                                        height: 1.5, letterSpacing: 0),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(selectedNozzleType.description,
                      style: _theme.textTheme.bodyText2
                          .copyWith(height: 1.5, letterSpacing: 0)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 16),
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FlatButton(
                        key: Key('use_this_flow_rate'),
                        color: Styleguide.color_green_4,
                        padding: EdgeInsets.all(16.0),
                        onPressed: () {
                          registry<LocalyticsService>().tagEvent(
                              UseThisFlowRateEvent(selectedNozzleType));
                          if (isGuest) {
                            buildLoginBottomCard(context);
                          } else {
                            final plot =
                                registry<WaterBloc>().state.waterData.plot;
                            registry<WaterBloc>().add(
                              UpdateNozzleTypeEvent(plot, selectedNozzleType),
                            );
                            registry<Navigation>().pop();
                          }
                        },
                        child: Text(
                          'USE THIS FLOW RATE',
                          style: _theme.textTheme.bodyText1
                              .copyWith(color: Styleguide.color_gray_0),
                        ),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 32),
                  child: TappableText(
                    child: Text(
                      'BACK',
                      key: Key('back_button'),
                      style: _theme.textTheme.subtitle1.copyWith(
                        color: _theme.primaryColor,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    onTap: () {
                      Future.delayed(Duration(microseconds: 200), () {
                        _showNozzleTypeDialog(nozzleTypes, selectedNozzleType);
                      });
                      registry<Navigation>().pop();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = DateTime.now().add(Duration(days: -6));
    final _theme = Theme.of(context);
    selectedNozzleType =
        registry<WaterBloc>().state.waterData.selectedNozzleType;
    var selectedWaterGoal = registry<WaterBloc>().state.waterData.waterGoal;
    return BlocProvider<WaterBloc>.value(
        value: registry<WaterBloc>(),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(16, 8, 16, 10),
          decoration: _radioDecoration(_theme.colorScheme.primary, 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(18, 10, 16, 0),
                child: BlocBuilder<WaterBloc, WaterState>(
                  builder: (context, state) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${dateFormat.format(day)} - ${dateFormat.format(DateTime.now())}',
                        style: _theme.textTheme.headline5.copyWith(
                            color: _theme.colorScheme.onPrimary,
                            letterSpacing: 0),
                      ),
                      Spacer(),
                      state.status == WaterStatus.refreshing
                          ? Row(
                              children: [
                                Text(
                                  'Updating',
                                  style: _theme.textTheme.bodyText2.copyWith(
                                    fontSize: 14,
                                    color: _theme.colorScheme.onPrimary,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                ProgressSpinner(
                                  color: _theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                    '${DateTime.now().difference(state.waterData.dateTime).inMinutes} minutes ago',
                                    style: _theme.textTheme.bodyText2.copyWith(
                                      fontSize: 10,
                                      color: _theme.colorScheme.onPrimary,
                                    )),
                                GestureDetector(
                                  onTap: widget.getWeatherData,
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    margin: EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      color: _theme.colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.refresh,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, bottom: 23, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                        width: 106,
                        child: BlocBuilder<WaterBloc, WaterState>(
                          builder: (context, state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.waterData.waterBalance.totalRain +
                                          state.waterData.waterBalance
                                              .totalWater >
                                      state.waterData.waterGoal
                                  ? Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                      child: Container(
                                        width: 106,
                                        child: Text(
                                          'You\'ve met your goal!',
                                          style: _theme.textTheme.bodyText1
                                              .copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0,
                                                  color: _theme
                                                      .colorScheme.onPrimary),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height:
                                              rainContainerHeight >= 140 * 3 / 4
                                                  ? 0
                                                  : 40,
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 4),
                                                  child: Text(
                                                    'WATER NEEDED',
                                                    style: _theme
                                                        .textTheme.bodyText2
                                                        .copyWith(
                                                            letterSpacing: 0,
                                                            color: _theme
                                                                .colorScheme
                                                                .onPrimary),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    _showSprinklerDialog(
                                                        state.waterData
                                                            .nozzleTypes,
                                                        state.waterData
                                                            .selectedNozzleType),
                                                child: Image.asset(
                                                  'assets/icons/info_transparent.png',
                                                  width: 15,
                                                  height: 15,
                                                  key: Key('info_transparent'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 22.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text(
                                                          '${isInch ? state.waterData.waterBalance.inches : state.waterData.waterBalance.minutes.round()}',
                                                          style: _theme
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: _theme
                                                                      .colorScheme
                                                                      .onPrimary),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: rainContainerHeight <
                                                    (140 * 3) / 4,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() =>
                                                              isInch = true);
                                                        },
                                                        child: Container(
                                                          width: 36,
                                                          height: 16,
                                                          decoration: isInch
                                                              ? _radioDecoration(
                                                                  Styleguide
                                                                      .color_green_5,
                                                                  2)
                                                              : null,
                                                          child: Center(
                                                            child: Text(
                                                              'INCH',
                                                              style: _theme
                                                                  .textTheme
                                                                  .bodyText2
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: _theme
                                                                          .colorScheme
                                                                          .onPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() =>
                                                              isInch = false);
                                                        },
                                                        child: Container(
                                                          width: 36,
                                                          height: 16,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 12),
                                                          decoration: !isInch
                                                              ? _radioDecoration(
                                                                  Styleguide
                                                                      .color_green_5,
                                                                  2)
                                                              : null,
                                                          child: Center(
                                                            child: Text(
                                                              'MIN',
                                                              style: _theme
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .copyWith(
                                                                      color: _theme
                                                                          .colorScheme
                                                                          .onPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('WEEKLY GOAL',
                                        style: _theme.textTheme.bodyText2
                                            .copyWith(
                                                color: _theme
                                                    .colorScheme.onPrimary,
                                                letterSpacing: 0)),
                                    GestureDetector(
                                      onTap: () {
                                        showBottomSheetDialog(
                                          context: context,
                                          hasTopPadding: false,
                                          child: Column(
                                            children: [
                                              ActivityDialogActionBar(
                                                onSelectTap: () {
                                                  if (isGuest) {
                                                    Future.delayed(
                                                        Duration(
                                                            microseconds: 200),
                                                        () {
                                                      buildLoginBottomCard(
                                                          context);
                                                    });
                                                  } else {
                                                    registry<WaterBloc>().add(
                                                      UpdateWaterGoalEvent(
                                                        registry<WaterBloc>()
                                                            .state
                                                            .waterData
                                                            .plot,
                                                        selectedWaterGoal,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              ActivityDialogContent(
                                                child: PickerWidget(
                                                  selectedItem:
                                                      '${waterGoalToStringlMap[selectedWaterGoal]}',
                                                  items: waterGoalList,
                                                  onValueChanged: (newItem) =>
                                                      selectedWaterGoal =
                                                          waterGoalToDoubleMap[
                                                              newItem],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 7),
                                        padding: EdgeInsets.all(8),
                                        width: 124,
                                        decoration: BoxDecoration(
                                          color: Styleguide.color_gray_0
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${state.waterData.waterGoal.toStringAsFixed(1)} INCH',
                                              style: _theme.textTheme.bodyText1
                                                  .copyWith(
                                                      color: _theme.colorScheme
                                                          .onPrimary,
                                                      height: 1.66),
                                            ),
                                            SizedBox(
                                              width: 23,
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: BlocBuilder<WaterBloc, WaterState>(
                      builder: (context, state) => WateringWidget(
                        zipCode: widget.zipCode,
                        waterModel: state.waterData,
                      ),
                    ))
                  ],
                ),
              ),
              AnimatedContainer(
                margin: EdgeInsets.only(top: 10, bottom: 15),
                duration: Duration(milliseconds: 300),
                width: double.infinity,
                height: _isShowGraph ? 0 : 246,
                color: Styleguide.color_green_5,
                child: Visibility(
                  visible: _isShowGraphContainer,
                  child: RainfallChartWidget(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          registry<LocalyticsService>()
                              .tagEvent(WaterLawnEvent());
                          registry<Navigation>().push(
                            '/activity',
                            arguments: ActivityData(
                              activityType: ActivityType.waterLawn,
                            ),
                          );
                        },
                        child: Container(
                          width: 248,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Styleguide.color_gray_0.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'WATER LAWN',
                                  style: _theme.textTheme.bodyText1.copyWith(
                                    color: _theme.colorScheme.onPrimary,
                                    height: 1.66,
                                    letterSpacing: 0,
                                  ),
                                ),
                                Container(
                                    width: 16.0,
                                    height: 16.0,
                                    margin: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      color: _theme.colorScheme.onPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Theme.of(context).primaryColor,
                                    ))
                              ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isShowGraph = !_isShowGraph;
                        });
                        Future.delayed(
                            Duration(
                                milliseconds: _isShowGraphContainer ? 0 : 300),
                            () {
                          setState(() {
                            _isShowGraphContainer = !_isShowGraphContainer;
                          });
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration:
                            _radioDecoration(Styleguide.color_gray_0, 7),
                        child: Icon(
                          _isShowGraph
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: _theme.colorScheme.primary,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // },
        );
  }
}
