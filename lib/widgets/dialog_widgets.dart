import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_event.dart';
import 'package:my_lawn/blocs/activity/activity_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/widgets/icon_widget.dart';

class PlatformAwareAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  PlatformAwareAlertDialog({
    key,
    @required this.title,
    @required this.content,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
          title: title, content: content, actions: actions);
    }
    return AlertDialog(title: title, content: content, actions: actions);
  }
}

class ActivityStatusWidget extends StatelessWidget {
  const ActivityStatusWidget({
    Key key,
    @required this.theme,
    @required this.padding,
    this.image,
    this.headline,
    this.subtitle,
    this.onClose,
  }) : super(key: key);

  final ThemeData theme;
  final EdgeInsets padding;
  final String image;
  final String headline;
  final String subtitle;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Image.asset('assets/icons/cancel.png'),
                onPressed: onClose ??
                    () {
                      Navigator.of(context).pop();
                    },
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 64,
                width: 64,
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(headline, style: theme.textTheme.headline2),
            ],
          ),
          SizedBox(height: 16),
          if (subtitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    subtitle,
                    style: theme.textTheme.subtitle2.copyWith(height: 1.43),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Custom Stateful Bottom Dialog
/// [onAppliedSaved] callback that returns a [DateTime] of the date that product was applied on.
/// [onComplete] callback that triggers when finished Apply step
void showAppliedDialog({
  BuildContext context,
  Function(DateTime) onAppliedSaved,
  Function onComplete,
  String activityId,
  ActivityBloc bloc,
}) {
  final _theme = Theme.of(context);

  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Styleguide.color_gray_2,
        ),
        height: 4,
        width: 40,
      ),
    );
  }

  Widget _buildUnsaved({StateSetter setState}) {
    var appliedAt = DateTime.now();

    final actionBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Date Completed?',
            style: _theme.textTheme.subtitle1.copyWith(
              height: 1.5,
            ),
          ),
          GestureDetector(
            child: Text(
              'CANCEL',
              style: _theme.textTheme.bodyText1.copyWith(
                color: _theme.primaryColor,
                height: 1.66,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    final datePicker = Container(
      height: 200,
      width: double.infinity,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: _theme.textTheme.headline3.copyWith(
              fontSize: 22,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          maximumDate: DateTime.now().add(Duration(days: 1)),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (value) {
            registry<Logger>().d(value);
            appliedAt = value;
          },
        ),
      ),
    );

    final button = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: FlatButton(
          color: _theme.primaryColor,
          child: Text(
            'SAVE',
            style:
                _theme.textTheme.button.copyWith(color: _theme.backgroundColor),
          ),
          onPressed: () {
            onAppliedSaved(appliedAt);
            bloc.add(
              SaveActivityEvent(
                ActivityData(
                  activityId: activityId,
                  applied: true,
                  appliedDate: appliedAt,
                ),
              ),
            );
          },
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(),
        SizedBox(height: 12),
        actionBar,
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Divider(),
        ),
        datePicker,
        button,
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSaved({StateSetter setState}) {
    final actionBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            child: CustomIcon(
              'cancel',
              width: 24,
            ),
            onTap: () {
              onComplete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    final content = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          SizedBox(height: 11),
          CustomIcon('spreader', width: 64),
          SizedBox(height: 16),
          Text(
            'Product Applied',
            style: _theme.textTheme.headline2,
          ),
          SizedBox(height: 16),
          Text(
            'Way to go! You’re on your way to a healthy and gorgeous lawn!',
            style: _theme.textTheme.subtitle2.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTopBar(),
        actionBar,
        content,
        SizedBox(height: 50),
      ],
    );
  }

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext builder) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return WillPopScope(
              onWillPop: () async => true,
              child: BlocBuilder<ActivityBloc, ActivityState>(
                cubit: bloc,
                builder: (context, state) {
                  if (state is LoadingActivityState) {
                    return ActivityStatusWidget(
                      theme: _theme,
                      padding: const EdgeInsets.fromLTRB(24, 41, 24, 95),
                      image: 'assets/icons/order_processing.png',
                      headline: 'Processing',
                    );
                  } else if (state is SuccessActivityState ||
                      state is SuccessUpdateActivityState) {
                    return _buildSaved(setState: setDialogState);
                  } else if (state is ErrorActivityState) {
                    return ActivityStatusWidget(
                      theme: _theme,
                      padding: const EdgeInsets.fromLTRB(24, 41, 24, 89),
                      image: 'assets/icons/question.png',
                      headline: 'Error',
                      subtitle: 'Please, try again later',
                    );
                  }
                  return _buildUnsaved(setState: setDialogState);
                },
              ));
        },
      );
    },
  );
}

enum SkipReason {
  DidNoHaveTime,
  CouldNotFindProduct,
  UsedDifferentProduct,
  WeatherUnfavorable,
  Other,
}

/// Custom Stateful Bottom Dialog
/// [onSkippedSubmit] callback that returns an [] of the reason for skipping
/// [onComplete] callback that triggers when finished Skip step
void showSkippedDialog({
  BuildContext context,
  Function(SkipReason, String) onSkippedSubmit,
  Function onComplete,
  String activityId,
  ActivityBloc bloc,
}) {
  final _list = [
    {
      'enum': SkipReason.DidNoHaveTime,
      'label': 'Did not have time',
    },
    {
      'enum': SkipReason.CouldNotFindProduct,
      'label': 'Could not find the product',
    },
    {
      'enum': SkipReason.UsedDifferentProduct,
      'label': 'I used a different product',
    },
    {
      'enum': SkipReason.WeatherUnfavorable,
      'label': 'Weather was unfavorable',
    },
    {
      'enum': SkipReason.Other,
      'label': 'Other',
    },
  ];

  final _theme = Theme.of(context);
  final _otherController = TextEditingController();
  SkipReason _reasonOption = _list.first['enum'];
  String reasonText = _list.first['label'];
  var showOtherField = false;

  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Styleguide.color_gray_2,
        ),
        height: 4,
        width: 40,
      ),
    );
  }

  Widget _buildUnsubmitted({StateSetter setState}) {
    final actionBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Why did you skip?',
            style: _theme.textTheme.subtitle1.copyWith(
              height: 1.5,
            ),
          ),
          GestureDetector(
            child: Text(
              'CANCEL',
              style: _theme.textTheme.bodyText1.copyWith(
                color: _theme.primaryColor,
                height: 1.66,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    Widget _buildRadioItem(
      SkipReason _reasonType,
      String _label,
    ) {
      return Row(
        children: [
          SizedBox(
            height: 32,
            width: 40,
            child: Radio(
              value: _reasonType,
              groupValue: _reasonOption,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (SkipReason value) {
                setState(() {
                  registry<Logger>().d(value);
                  _reasonOption = value;
                  reasonText = _label;
                  showOtherField = false;
                });
              },
            ),
          ),
          Text(_label, style: _theme.textTheme.bodyText2),
        ],
      );
    }

    Widget _buildOtherRadioItem(
      SkipReason _reasonType,
      String _label,
    ) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 32,
                width: 40,
                child: Radio(
                  value: _reasonType,
                  groupValue: _reasonOption,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (SkipReason value) {
                    setState(() {
                      _reasonOption = value;
                      reasonText = _label;

                      showOtherField = true;
                    });
                  },
                ),
              ),
              Text(_label, style: _theme.textTheme.bodyText2),
            ],
          ),
          if (showOtherField)
            Padding(
              padding: EdgeInsets.only(left: 40, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autofocus: true,
                    controller: _otherController,
                    onChanged: (input) {
                      reasonText = input;

                      if (input.isEmpty) {
                        reasonText = _label;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 8),
                    child: Text('Please specify'),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    final radioGroup = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _list.map((e) {
          if (e['enum'] == SkipReason.Other) {
            return _buildOtherRadioItem(e['enum'], e['label']);
          } else {
            return _buildRadioItem(e['enum'], e['label']);
          }
        }).toList(),
      ),
    );

    final button = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: FlatButton(
          color: _theme.primaryColor,
          child: Text(
            'SUBMIT',
            style:
                _theme.textTheme.button.copyWith(color: _theme.backgroundColor),
          ),
          onPressed: () {
            if (_reasonOption == SkipReason.Other) {
              reasonText = _otherController.text;
            }

            bloc.add(
              SaveActivityEvent(
                ActivityData(
                  activityId: activityId,
                  skipped: true,
                ),
              ),
            );
          },
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(),
        SizedBox(height: 12),
        actionBar,
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 9),
          child: Divider(),
        ),
        radioGroup,
        SizedBox(height: 32),
        button,
        if (showOtherField) SizedBox(height: 256),
      ],
    );
  }

  Widget _buildSubmitted({StateSetter setState}) {
    final actionBar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/cancel.png'),
            onPressed: () {
              onComplete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    Widget _buildContent({
      String iconName,
      String title,
      String description,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            SizedBox(height: 11),
            CustomIcon(
              iconName,
              width: 64,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: _theme.textTheme.headline2,
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: _theme.textTheme.subtitle2.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget _buildSubmittedContent(SkipReason reason) {
      var content;

      switch (reason) {
        case SkipReason.DidNoHaveTime:
          content = _buildContent(
            iconName: 'question_large',
            title: 'Did you know?',
            description:
                'We know you are busy - most yard applications take less than 30 minutes.',
          );
          break;
        case SkipReason.CouldNotFindProduct:
          content = _buildContent(
            iconName: 'question_large',
            title: 'Did you know?',
            description:
                'Use the product locator on the product detail page and see if the product is available online.',
          );
          break;
        case SkipReason.UsedDifferentProduct:
          content = _buildContent(
            iconName: 'forgot',
            title: 'Don\'t Forget',
            description:
                'You can always add other Scotts products to your plan.',
          );
          break;
        case SkipReason.WeatherUnfavorable:
          content = _buildContent(
            iconName: 'question_large',
            title: 'Did you know?',
            description:
                'The dates are suggested times based on typical weather conditions. Contact us if you have questions.',
          );
          break;
        case SkipReason.Other:
          content = _buildContent(
            iconName: 'order_completed',
            title: 'Product Skipped!',
            description:
                'You can always add other Scotts products to your plan.',
          );
          break;
        default:
        // TODO: Error
      }

      return content;
    }

    final button = Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: OutlineButton(
          child: Text('GOT IT!'),
          borderSide: BorderSide(color: _theme.primaryColor),
          onPressed: () {
            Navigator.of(context).pop();

            onSkippedSubmit(_reasonOption, reasonText);
          },
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTopBar(),
        actionBar,
        _buildSubmittedContent(_reasonOption),
        SizedBox(height: 44),
        if (_reasonOption != SkipReason.Other) button,
      ],
    );
  }

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext builder) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return WillPopScope(
              onWillPop: () async => true,
              child: BlocBuilder<ActivityBloc, ActivityState>(
                cubit: bloc,
                builder: (context, state) {
                  if (state is LoadingActivityState) {
                    return ActivityStatusWidget(
                      theme: _theme,
                      padding: const EdgeInsets.fromLTRB(24, 41, 24, 95),
                      image: 'assets/icons/order_processing.png',
                      headline: 'Processing',
                    );
                  } else if (state is SuccessActivityState ||
                      state is SuccessUpdateActivityState) {
                    return _buildSubmitted(setState: setDialogState);
                  } else if (state is ErrorActivityState) {
                    return ActivityStatusWidget(
                      theme: _theme,
                      padding: const EdgeInsets.fromLTRB(24, 41, 24, 89),
                      image: 'assets/icons/question.png',
                      headline: 'Error',
                      subtitle: 'Please, try again later',
                    );
                  }
                  return _buildUnsubmitted(setState: setDialogState);
                },
              ));
        },
      );
    },
  );
}
