import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/settings_screen/action.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';

class AppFeedbackScreen extends StatefulWidget {
  @override
  _AppFeedbackScreenState createState() => _AppFeedbackScreenState();
}

class _AppFeedbackScreenState extends State<AppFeedbackScreen> {
  final _feedbackFocus = FocusNode();

  var _rating = 0;
  var feedback = '';
  var _share = true;

  @override
  void dispose() {
    _feedbackFocus.dispose();

    super.dispose();
  }

  void _adobeAnalyticAction(int rating) {
    registry<AdobeRepository>().trackAppActions(
      AppFeedbackScreenAction(rating: rating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithSliverAppBar(
      child: GestureDetector(
        onTap: () => _feedbackFocus.unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                "Tell us what's working,\nand what's not",
                textAlign: TextAlign.center,
                style: theme.textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: GestureDetector(
                      child: Container(
                        color: theme.backgroundColor,
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        child: index == 0 || index == 6
                            ? null
                            : Image.asset(
                                'assets/icons/rating_star_'
                                '${index <= _rating ? 'selected' : 'unselected'}'
                                '.png',
                                width: 64,
                                height: 64,
                                key: Key('rating_star_' + index.toString()),
                              ),
                      ),
                      onTap: () {
                        _feedbackFocus.unfocus();
                        setState(() => _rating = min(index, 5));
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 32, 8),
              child: Text(
                'Your Feedback',
                style: theme.textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                focusNode: _feedbackFocus,
                key: Key('feedback_text_field'),
                onChanged: (value) => feedback = value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Styleguide.nearBackground(theme),
                  hintText: "We're always looking for ways to improve "
                      'and want to make your experience with the '
                      'My Lawn app the best it can be.',
                ),
                minLines: 6,
                maxLines: 6,
                maxLength: 280,
                maxLengthEnforced: true,
                textCapitalization: TextCapitalization.sentences,
                buildCounter: (context,
                        {currentLength, isFocused, maxLength}) =>
                    Text('$currentLength/$maxLength'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "Share Today's Data",
                              style: theme.textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'You can share basic information about '
                            'your hardware and software specs with '
                            'us to helps us diagnose bugs.',
                            style: theme.textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Switch(
                        value: _share,
                        onChanged: (value) {
                          _feedbackFocus.unfocus();
                          setState(() => _share = value);
                        },
                        key: Key('share_todays_data_switch'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: RaisedButton(
                key: Key('feedback_send_button'),
                child: Text('SEND'),
                onPressed: _rating == 0
                    ? null
                    : () {
                        _feedbackFocus.unfocus();
                        // TODO: Send rating, feedback, and sharing somewhere.

                        try {
                        _adobeAnalyticAction(_rating);

                        registry<Navigation>()
                            .pushReplacement(
                              '/profile/settings/feedback/'
                              '${_rating >= 4 ? 'positive' : 'negative'}',
                            )
                            .catchError((e) => registry<Logger>()
                                .d((e as Error).stackTrace.toString()));
                        } catch (e) {
                          registry<Logger>().d(e);
                          unawaited(FirebaseCrashlytics.instance
                              .recordError(e, StackTrace.current));
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
