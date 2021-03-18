import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/data_mock/quiz_response.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/quiz_screen/state.dart';
import 'package:my_lawn/widgets/animated_linear_progress_indicator_widget.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/widgets/quiz/option_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';

class SpreaderTypeScreen extends StatefulWidget {
  @override
  _SpreaderTypeScreenState createState() => _SpreaderTypeScreenState();
}

class _SpreaderTypeScreenState extends State<SpreaderTypeScreen>
    with RouteMixin<SpreaderTypeScreen, LawnData> {
  QuizModel _quizModel;
  QuizPage _quizPage;
  LawnData _lawnData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (routeArguments != null) {
      _lawnData = routeArguments;
      _quizPage =
          spreaderTypeData; // get static quiz page data like title, subtitle, options, etc.
    } else {
      _quizModel = registry<QuizModel>();
      _quizPage = _quizModel.getQuizPage(QuizPageType.spreader);
    }
  }

  void _saveAnswer(Option option) {
    final selectedOption = _quizPage.questions[0].options
        .firstWhere((_option) => _option.value == option.value);

    final selectedSpreader = Spreader.values
        .firstWhere((spreader) => spreader.string == selectedOption.value);

    // Edit Lawn Profile flow
    if (_lawnData != null) {
      _saveLawnProfile(selectedSpreader);
    }
    // Quiz flow
    else {
      _quizModel.saveSpreaderType(selectedSpreader);

      registry<AdobeRepository>().trackAppState(
          LawnSizeState(spreaderSelect: selectedSpreader.toString()));
      registry<Navigation>().push('/quiz/lawnaddress');
    }
  }

  void _saveLawnProfile(Spreader selectedSpreader) {
    final updatedLawnData = _lawnData.copyWith(
      spreader: selectedSpreader,
    );

    registry<Navigation>().pop<LawnData>(updatedLawnData);
  }

  void _showBottomSheet(BuildContext context) {
    showBottomSheetDialog(
      context: context,
      title: DialogTitle(title: _quizPage.tooltipTitle),
      child: DialogContent(
        content: _quizPage.tooltipLabel,
        actions: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: FractionallySizedBox(
              widthFactor: 1,
              child: OutlineButton(
                key: Key('got_it'),
                child: Text('GOT IT!'),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = _quizPage.questions[0].options;

    return BasicScaffoldWithAppBar(
      appBarElevation: 0,
      isNotUsingWillPop: true,
      appBarBrightness: Brightness.dark,
      backgroundColor: theme.primaryColor,
      appBarBackgroundColor: theme.primaryColor,
      appBarForegroundColor: theme.colorScheme.onPrimary,
      trailing:
          // This means screen is opened in quiz flow and
          // we need to show progress percentage of quiz flow
          _quizModel != null
              ? Expanded(
                  child: AnimatedLinearProgressIndicator(
                    initialValue: 0.25,
                    finalValue: 0.50,
                    backgroundColor: theme.colorScheme.background,
                    foregroundColor: theme.colorScheme.secondaryVariant,
                  ),
                )
              : SizedBox(),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _quizPage.title,
                          style: theme.textTheme.headline2.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        key: Key('spreader_type_screen_info_icon_button'),
                        onPressed: () => _showBottomSheet(context),
                        icon: Image.asset(
                          'assets/icons/info.png',
                          color: theme.colorScheme.onPrimary,
                          width: 24,
                          height: 24,
                        ),
                      )
                    ],
                  ),
                  if (_quizPage.subtitle != null &&
                      _quizPage.subtitle.isNotEmpty)
                    Text(
                      _quizPage.subtitle,
                      style: theme.textTheme.subtitle2.copyWith(
                        color: theme.colorScheme.onPrimary,
                        height: 1.6,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              //TODO: why is this widget scrollable?
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ImageOption(
                    ObjectKey(options[index].value),
                    option: options[index],
                    onSelected: _saveAnswer,
                    isSpreaderOption: true,
                  );
                },
                childCount: options.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
