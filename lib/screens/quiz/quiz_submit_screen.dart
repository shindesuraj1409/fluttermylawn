import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data/quiz_modify_screen_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/actions/appsflyer/care_plan_created_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/plan_summary_event.dart';
import 'package:my_lawn/services/analytic/actions/localytics/types.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';

class QuizSubmitScreen extends StatefulWidget {
  @override
  _QuizSubmitScreenState createState() => _QuizSubmitScreenState();
}

class _QuizSubmitScreenState extends State<QuizSubmitScreen> {
  QuizModel _quizModel;
  AuthStatus _authStatus;
  User _user;

  @override
  void initState() {
    super.initState();
    _authStatus = registry<AuthenticationBloc>().state.authStatus;
    _user = registry<AuthenticationBloc>().state.user;
    _quizModel = registry<QuizModel>();
    _quizModel.submitQuiz();

    final subscriptionStatus = registry<SubscriptionBloc>().state.status;

    _quizModel.stream<QuizSubmitData>().takeWhile((_) => mounted).listen(
      (event) async {
        if (event.state == QuizSubmitState.success &&
            _user != null &&
            (subscriptionStatus.isPreview || subscriptionStatus.isActive)) {
          final result = await _quizModel.subscriptionPlanUpdateCount(
              event.recommendation.recommendationId);
          await registry<AuthenticationBloc>().add(UserUpdated());
          _goToQuizModifyScreen(result);
        } else if (event.state == QuizSubmitState.success) {
          _tagPlanCreatedEvent(event);
          if (_authStatus == AuthStatus.loggedOut) {
            await registry<Navigation>().setRoot('/auth/signup');
          } else {
            final hasNotCompletedQuizBefore = _user.recommendationId == null;
            await registry<AuthenticationBloc>().add(UserUpdated());
            if (hasNotCompletedQuizBefore) {
              await registry<Navigation>().setRoot('/home');
            } else {
              final result = await _quizModel
                  .recommendationPlanUpdateCount(event.recommendation);
              _goToQuizModifyScreen(result);
            }
          }
        }
      },
    );
    registry<AdobeRepository>().trackAppState(ProfileGeneratingState());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryVariant,
      body: busStreamBuilder<QuizModel, QuizSubmitData>(
        busInstance: _quizModel,
        builder: (_, model, data) {
          switch (data.state) {
            case QuizSubmitState.submitting_quiz:
            case QuizSubmitState.updating_quiz:
            case QuizSubmitState.success:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle),
                          child: Image.asset(
                            'assets/images/lawn_mower_loading.png',
                            width: 84,
                            height: 84,
                            key: Key('quiz_submit_screen_loading_image'),
                          ),
                        ),
                        ProgressSpinner(
                          size: 128,
                          strokeWidth: 8,
                          color: Styleguide.color_green_4,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'HANG TIGHT',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText2
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Creating Your New Lawn Plan',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline2
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              );
            case QuizSubmitState.error:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      data.errorMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.subtitle1.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Try again',
                        style: theme.textTheme.headline4.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () => model.submitQuiz(),
                    ),
                  ],
                ),
              );
            default:
              throw UnimplementedError(
                  'Incorrect quiz submit state reached : ${data.state}');
          }
        },
      ),
    );
  }

  void _goToQuizModifyScreen(int change) {
    registry<Navigation>().setRoot('/home');
    registry<Navigation>().push('/profile');
    registry<Navigation>()
        .push('/quiz/modify', arguments: QuizModifyScreenData(change));
  }

  void _tagPlanCreatedEvent(QuizSubmitData data) {
    final recommendation = data.recommendation;
    final answers = _quizModel.answers;

    registry<LocalyticsService>().tagEvent(PlanSummaryEvent(
      userType: _authStatus == AuthStatus.loggedOut
          ? UserType.Guest
          : UserType.LoggedIn,
      lawnSize: recommendation.lawnData.lawnSqFt.toString(),
      grassType: recommendation.lawnData.grassTypeName,
      zoneName: answers[QuestionType.lawnZone],
      lawnColor: answers[QuestionType.lawnColor],
      lawnThickness: answers[QuestionType.lawnThickness],
      lawnWeeds: answers[QuestionType.lawnWeeds],
      spreaderType: answers[QuestionType.lawnSpreader],
    ));

    registry<AppsFlyerService>().tagEvent(CarePlanCreatedEvent());
  }
}
