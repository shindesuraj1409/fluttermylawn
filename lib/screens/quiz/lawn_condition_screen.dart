import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_condition_screen_data.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data_mock/quiz_response.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/widgets/animated_linear_progress_indicator_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/quiz/grass_type_slider_widget.dart';
import 'package:navigation/navigation.dart';

class LawnConditionScreen extends StatefulWidget {
  @override
  _LawnConditionScreenState createState() => _LawnConditionScreenState();
}

class _LawnConditionScreenState extends State<LawnConditionScreen>
    with RouteMixin<LawnConditionScreen, LawnConditionScreenData> {
  int colorRating;
  int thicknessRating;
  int weedsRating;

  List<Option> colorOptions;
  List<Option> thicknessOptions;
  List<Option> weedsOptions;

  QuizModel _quizModel;
  QuizPage _quizPage;

  LawnData _lawnData;
  bool canPop = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lawnData = routeArguments?.lawnData;
    canPop = routeArguments?.canPop ?? true;
    // Edit Lawn Profile flow.
    // Pick up values from LawnData passed on as arguments to this screen.
    if (_lawnData != null) {
      colorRating = _lawnData.color.index;
      thicknessRating = _lawnData.thickness.index;
      weedsRating = _lawnData.weeds.index;

      // Getting static data
      colorOptions = lawnConditionData.questions[0].options;
      thicknessOptions = lawnConditionData.questions[1].options;
      weedsOptions = lawnConditionData.questions[2].options;
    }
    // Quiz flow.
    // Assign default mid-range values. Range is 0-4
    else {
      _quizModel = registry<QuizModel>();
      _quizPage = _quizModel.getQuizPage(QuizPageType.lawnCondition);

      colorRating = 2;
      thicknessRating = 2;
      weedsRating = 2;

      colorOptions = lawnConditionData.questions[0].options;
      thicknessOptions = lawnConditionData.questions[1].options;
      weedsOptions = lawnConditionData.questions[2].options;
    }
  }

  void _submitAnswer() {
    // This screen is opened from Edit Lawn Profile screen to edit "Lawn Condition"
    if (_lawnData != null) {
      final color = LawnGrassColor.values
          .firstWhere((value) => value.index == colorRating);
      final thickness = LawnGrassThickness.values
          .firstWhere((value) => value.index == thicknessRating);
      final weeds =
          LawnWeeds.values.firstWhere((value) => value.index == weedsRating);

      final updatedLawnData = _lawnData.copyWith(
        color: color,
        thickness: thickness,
        weeds: weeds,
      );

      registry<Navigation>().pop<LawnData>(updatedLawnData);
    }
    // This screen is opened in quiz flow
    else {
      _quizModel.saveLawnCondition(
        colorRating,
        thicknessRating,
        weedsRating,
      );

      registry<AdobeRepository>().trackAppState(
        SpreaderScreenState(
          grassColor: colorOptions[colorRating].label,
          grassThickness: thicknessOptions[thicknessRating].label,
          grassWeeds: weedsOptions[weedsRating].label,
        ),
      );

      // Go to next screen in quiz flow which is `SpreaderTypeScreen`
      registry<Navigation>().push('/quiz/spreadertype');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bannerHeight = screenHeight * 0.45;
    final cardHeight = screenHeight * 0.65;
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        // If a user backs out of the quiz screen without having finished a
        // prior quiz we will log them out of the app.
        if (canPop) {
          return true;
        }
        await registry<AuthenticationBloc>().add(LogoutRequested());
        await registry<Navigation>().setRoot('/welcome');
        return false;
      },
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              // We need to add one local asset so while other 3 images load from network
              // this grass acts as a placeholder image for time being
              Image.asset(
                'assets/images/grass_color.webp',
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.cover,
              ),
              CachedNetworkImage(
                imageUrl: colorOptions[colorRating].imageUrl,
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  child: Center(
                    child: ProgressSpinner(
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: thicknessOptions[thicknessRating].imageUrl,
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  child: Center(
                    child: ProgressSpinner(
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: weedsOptions[weedsRating].imageUrl,
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.fitWidth,
                placeholder: (_, __) => Container(
                  child: Center(
                    child: ProgressSpinner(
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // This checks for users who have completed the quiz at least once
                      // Only if they have some LawnData will they be able to back out of the quiz.
                      canPop
                          ? BackButton(
                              color: theme.colorScheme.onPrimary,
                              onPressed: () => registry<Navigation>().pop(),
                              key: Key('back_button'),
                            )
                          : Container(height: 48, width: 48),
                      // This means screen is opened in quiz flow and
                      // we need to show progress percentage of quiz flow
                      if (_quizModel != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: AnimatedLinearProgressIndicator(
                              initialValue: 0.0,
                              finalValue: 0.25,
                              backgroundColor: theme.colorScheme.background,
                              foregroundColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: cardHeight,
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
                      bottom: 8,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              _quizPage?.title ??
                                  'What does your Lawn look like?',
                              style: theme.textTheme.headline2,
                            ),
                          ),
                          SizedBox(height: 6),
                          GrassTypeSlider(
                            label: 'Color',
                            currentValue: colorRating.toDouble(),
                            options: colorOptions,
                            onOptionSelected: (int value) {
                              setState(() {
                                colorRating = value;
                              });
                            },
                          ),
                          SizedBox(height: 6),
                          GrassTypeSlider(
                            label: 'Thickness',
                            currentValue: thicknessRating.toDouble(),
                            options: thicknessOptions,
                            onOptionSelected: (int value) {
                              setState(() {
                                thicknessRating = value;
                              });
                            },
                          ),
                          SizedBox(height: 6),
                          GrassTypeSlider(
                            label: 'Weeds',
                            currentValue: weedsRating.toDouble(),
                            options: weedsOptions,
                            onOptionSelected: (int value) {
                              setState(() {
                                weedsRating = value;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            child: RaisedButton(
                              key: Key('lawn_condition_screen_save_button'),
                              child: Text('SAVE'),
                              onPressed: _submitAnswer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
