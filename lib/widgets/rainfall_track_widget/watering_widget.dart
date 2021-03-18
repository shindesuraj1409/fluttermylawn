import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/water_model_data.dart';

class WateringWidget extends StatefulWidget {
  const WateringWidget({
    Key key,
    this.zipCode,
    this.waterModel,
  }) : super(key: key);

  final String zipCode;
  final WaterModel waterModel;

  @override
  _WateringWidgetState createState() => _WateringWidgetState();
}

class _WateringWidgetState extends State<WateringWidget> {
  bool _showRainBadge = false;
  bool _showWaterBadge = false;

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

  double getContainerHeight(WaterModel waterModel, String option) {
    final maxHeight = 132.0;

    final totalWater =
        waterModel.waterBalance.totalWater + waterModel.waterBalance.totalRain;

    var height = totalWater / waterModel.waterGoal * maxHeight;

    if (totalWater > waterModel.waterGoal) {
      height = maxHeight;
    }

    final rainedHeight = waterModel.waterBalance.totalRain == 0
        ? 0.0
        : (waterModel.waterBalance.totalRain / totalWater) * height;
    final wateredHeight = waterModel.waterBalance.totalWater == 0
        ? 0.0
        : (waterModel.waterBalance.totalWater / totalWater) * height;

    if (option == 'rained') {
      return rainedHeight;
    } else if (option == 'rainedLabel') {
      if (rainedHeight < 8 && rainedHeight > 0) {
        return 9.0;
      }
      return rainedHeight > 1 ? rainedHeight - 1 : rainedHeight;
    } else if (option == 'wateredLabel') {
      if (wateredHeight < 8 && wateredHeight > 0) {
        return 9.0;
      }
      return wateredHeight > 1 ? wateredHeight - 1 : wateredHeight;
    }

    return wateredHeight;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth - 71.6,
                  top: 14,
                  bottom: 3,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/location_pin.png',
                      width: 16,
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        '${widget.zipCode}',
                        style: _theme.textTheme.bodyText2.copyWith(
                            color: _theme.colorScheme.onPrimary, fontSize: 10),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/water_container.png',
                        width: constraints.maxWidth - 62,
                        height: 138,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 1.2 * constraints.maxWidth / 16,
                        right: 1 * constraints.maxWidth / 16,
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showRainBadge = !_showRainBadge;
                                    });
                                  },
                                  child: Container(
                                    height: getContainerHeight(
                                        widget.waterModel, 'rained'),
                                    width: 14.8 * constraints.maxWidth / 16,
                                    decoration: _radioDecoration(
                                        Styleguide.color_accents_blue_1, 2),
                                    child: Visibility(
                                      visible: _showRainBadge,
                                      child: Center(
                                        child: Container(
                                          width: 54,
                                          height: 20,
                                          decoration: _radioDecoration(
                                              Styleguide.color_gray_0, 2),
                                          child: Center(
                                            child: Text(
                                              '${widget.waterModel.waterBalance.totalRain}"'
                                              '',
                                              style: _theme.textTheme.bodyText1
                                                  .copyWith(
                                                      height: 1.66,
                                                      letterSpacing: 0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showWaterBadge = !_showWaterBadge;
                                });
                              },
                              child: Container(
                                height: getContainerHeight(
                                    widget.waterModel, 'watered'),
                                width: 14.8 * constraints.maxWidth / 16,
                                decoration: _radioDecoration(
                                    Styleguide.color_accents_blue_3, 2),
                                child: Visibility(
                                  visible: _showWaterBadge,
                                  child: Center(
                                    child: Container(
                                      width: 54,
                                      height: 20,
                                      decoration: _radioDecoration(
                                          Styleguide.color_gray_0, 2),
                                      child: Center(
                                        child: Text(
                                          '${widget.waterModel.waterBalance.totalWater}"'
                                          '',
                                          style: _theme.textTheme.bodyText1
                                              .copyWith(
                                                  height: 1.66,
                                                  letterSpacing: 0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 9),
                      height: 138,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: getContainerHeight(
                                widget.waterModel, 'rainedLabel'),
                            child: Center(
                              child: Text(
                                getContainerHeight(
                                            widget.waterModel, 'rainedLabel') >
                                        0
                                    ? 'Rained'
                                    : '',
                                style: _theme.textTheme.bodyText2.copyWith(
                                  color: _theme.colorScheme.onPrimary,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5, top: 2),
                            height: getContainerHeight(
                                widget.waterModel, 'wateredLabel'),
                            child: Center(
                              child: Text(
                                getContainerHeight(
                                            widget.waterModel, 'wateredLabel') >
                                        0
                                    ? 'Watered'
                                    : '',
                                style: _theme.textTheme.bodyText2.copyWith(
                                  color: _theme.colorScheme.onPrimary,
                                  fontSize: 10,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
