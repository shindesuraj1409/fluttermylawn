import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/home/home_screen.dart';
import 'package:my_lawn/widgets/deeplinks_handler.dart';
import 'package:navigation/navigation.dart';

class RainfallChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RainfallChartWidgetState();
}

class _RainfallChartWidgetState extends State<RainfallChartWidget> {
  int _touchedIndex;
  bool _isWater = false;
  Color barColor = Styleguide.color_accents_blue_1;
  Color selectedColor = Styleguide.color_gray_0;
  Color borderColor = Styleguide.color_gray_1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaterBloc>.value(
      value: registry<WaterBloc>(),
      child: Container(
        height: 245,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BlocBuilder<WaterBloc, WaterState>(
                        builder: (_, state) => BarChart(
                          rainfallData(
                            _isWater
                                ? state.waterData.waterBalance.water
                                : state.waterData.waterBalance.precipitation,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 15),
                    color: Styleguide.color_green_5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isWater = !_isWater),
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: 5, right: 2, left: 2),
                                decoration: BoxDecoration(
                                    border: (!_isWater)
                                        ? Border(
                                            bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              width: 1.0,
                                            ),
                                          )
                                        : null),
                                child: Text(
                                  'RAINFALL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isWater = !_isWater),
                              child: Container(
                                margin: EdgeInsets.only(left: 14),
                                padding: EdgeInsets.only(
                                    bottom: 5, right: 2, left: 2),
                                decoration: BoxDecoration(
                                    border: (_isWater)
                                        ? Border(
                                            bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              width: 1.0,
                                            ),
                                          )
                                        : null),
                                child: Text(
                                  'WATER',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            final args = HomeScreenArguments(
                                HomeScreenTab.ask, 'Rainfall Total');
                            registry<Navigation>()
                                .pushReplacement('/home', arguments: args);
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5, right: 8),
                                  child: Text(
                                    'About this data',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontSize: 10,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/info_transparent.png',
                                  width: 12,
                                  height: 13,
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
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 16,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: isTouched ? [selectedColor] : [barColor],
          width: width,
          borderRadius: BorderRadius.zero,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<double> source) => List.generate(
        source.length,
        (i) => makeGroupData(i, source[i], isTouched: i == _touchedIndex),
      );

  BarChartData rainfallData(List<double> source) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: selectedColor,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${rod.y}"',
              TextStyle(color: Styleguide.color_gray_9),
            );
          },
        ),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) =>
              TextStyle(color: selectedColor.withOpacity(0.8), fontSize: 10),
          margin: 3,
          getTitles: (double value) {
            final offset = 6 - value.toInt();
            final day = DateTime.now().add(Duration(days: -offset));
            return DateFormat('dd').format(day);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 0.25,
          margin: 14,
          getTitles: (value) => '${value}',
          getTextStyles: (value) =>
              TextStyle(color: selectedColor.withOpacity(0.8), fontSize: 10),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: borderColor.withOpacity(0.1), width: 1),
        ),
      ),
      minY: 0,
      maxY: source.reduce(max) == 0 ? 1.1 : source.reduce(max) + 0.1,
      barGroups: showingGroups(source),
      alignment: BarChartAlignment.spaceAround,
      gridData: FlGridData(
        horizontalInterval: 0.2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: borderColor.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
    );
  }
}
