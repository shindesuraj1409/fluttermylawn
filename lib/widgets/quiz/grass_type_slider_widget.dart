import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';

/// Custom Slider Widget created for Grass Type selection
///
/// It is created because default `Slider` from Flutter doesn't works for our design.
/// This has been created with combination of Column, Stack, Row and Slider widgets
///                           <Column>
///                        grass-type-label
/// <Row> first-option-label                 last-option-label
/// <SizedBox> w - infinity, h - 48.0
///  |_ <Stack>
///       |_ Option indicators(Row - spacebetween)
///       |_ OptionSelection indicators (Row - spacebetween)
///       |_ Slider - with colors set to transparent so it is invisible but it is actually used to change range of options
class GrassTypeSlider extends StatelessWidget {
  final String label;
  final double currentValue;
  final List<Option> options;
  final Function onOptionSelected;

  GrassTypeSlider({
    @required this.label,
    @required this.currentValue,
    @required this.options,
    @required this.onOptionSelected,
  });

  List<Widget> _buildOptionIndicator(int noOfOptions) {
    final list = <Widget>[];
    for (var i = 0; i < noOfOptions; i++) {
      final firstOrLast = i == 0 || i == noOfOptions - 1;
      list.add(_Option(firstOrLast));
    }
    return list;
  }

  List<Widget> _buildOptionSelectionIndicator(int noOfOptions) {
    final list = <Widget>[];
    for (var i = 0; i < noOfOptions; i++) {
      list.add(_OptionSelector(i == currentValue));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstValueLabel = options.first.label;
    final lastValueLabel = options.last.label;

    /// Values to be defined for Slider widget - divisions, min, max, etc.
    final divisions = options.length - 1;
    final minValue = double.parse(options.first.value);
    final maxValue = double.parse(options.last.value);

    final noOfOptions = options.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.headline5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                firstValueLabel,
                style: theme.textTheme.caption,
              ),
              Text(
                lastValueLabel,
                style: theme.textTheme.caption,
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Divider(thickness: 1.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildOptionIndicator(noOfOptions),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildOptionSelectionIndicator(noOfOptions),
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    showValueIndicator: ShowValueIndicator.never,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 0,
                      disabledThumbRadius: 0,
                    ),
                  ),
                  child: Slider(
                    key: Key('slider_' + label.toLowerCase()),
                    value: currentValue,
                    min: minValue,
                    max: maxValue,
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    divisions: divisions,
                    onChanged: (value) {
                      onOptionSelected(value.toInt());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final bool isFirstOrLastOption;

  _Option(this.isFirstOrLastOption);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isFirstOrLastOption
            ? Styleguide.color_gray_4
            : Styleguide.color_gray_0,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Styleguide.color_gray_4,
        ),
      ),
    );
  }
}

class _OptionSelector extends StatelessWidget {
  final bool isActive;

  _OptionSelector(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: 24.0,
      width: 24.0,
      decoration: BoxDecoration(
        color: isActive ? Styleguide.color_green_4 : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: isActive ? Styleguide.color_gray_0 : Colors.transparent,
          width: isActive ? 2.0 : 0.0,
        ),
        boxShadow: isActive
            ? const [
                BoxShadow(
                  color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: -1.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    3.0, // Move to bottom 10 Vertically
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
                  blurRadius: 18.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    1.0, // Move to bottom 10 Vertically
                  ),
                ),
                BoxShadow(
                  color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
                  blurRadius: 10.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    6.0, // Move to bottom 10 Vertically
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
