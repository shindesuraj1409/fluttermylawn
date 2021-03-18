import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/quiz/lawn_size_zip_code_form/lawn_size_zip_code_form_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/quiz/widgets/lawn_size_limit_dialog.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/widgets/animated_linear_progress_indicator_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';
import 'package:my_lawn/widgets/quiz/question_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

const lawnSizeLimitError = '''
Unfortunately we don't have plans to support very large lawns above 200,000 square feet.

You can enter a smaller lawn size, or get in touch with our team to get help.
''';

class LawnSizeZipCodeScreen extends StatefulWidget {
  @override
  _LawnSizeZipCodeScreenState createState() => _LawnSizeZipCodeScreenState();
}

class _LawnSizeZipCodeScreenState extends State<LawnSizeZipCodeScreen>
    with RouteMixin<LawnSizeZipCodeScreen, LawnData> {
  final _scrollController = ScrollController();
  // Existing Lawn Profile of existing user passed on from Edit Lawn Profile screen
  // when they're editing "Lawn Size" or null otherwise
  LawnData _lawnData;
  LawnSizeZipCodeFormBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LawnSizeZipCodeFormBloc(registry<PlacesService>());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lawnData = routeArguments;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) => BasicScaffoldWithAppBar(
        isNotUsingWillPop: true,
        appBarElevation: 0,
        backgroundColor: theme.primaryColor,
        appBarBackgroundColor: theme.primaryColor,
        leading: BackButton(
          color: theme.iconTheme.color,
          onPressed: () => registry<Navigation>().pop(),
          key: Key('back_button'),
        ),
        trailing:
            // This means screen is opened in quiz flow and
            // we need to show progress percentage of quiz flow
            _lawnData == null
                ? Expanded(
                    child: AnimatedLinearProgressIndicator(
                      initialValue: 0.50,
                      finalValue: 0.75,
                      backgroundColor: theme.colorScheme.background,
                      foregroundColor: theme.colorScheme.secondaryVariant,
                    ),
                  )
                : SizedBox(),
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: QuestionText(
                        title: 'Great! Tell us about the size of your lawn',
                        subtitle:
                            'This helps us send you the right amount of products.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _ZipCodeAndLawnAreaInputForm(
                        bloc: _bloc,
                        lawnData: _lawnData,
                      ),
                    ),
                    const Spacer(),
                    _ContinueToNextQuestionCard(
                      bloc: _bloc,
                      lawnData: _lawnData,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ZipCodeAndLawnAreaInputForm extends StatefulWidget {
  final LawnSizeZipCodeFormBloc bloc;
  final LawnData lawnData;

  _ZipCodeAndLawnAreaInputForm({
    @required this.bloc,
    this.lawnData,
  });

  @override
  __ZipCodeAndLawnAreaInputFormState createState() =>
      __ZipCodeAndLawnAreaInputFormState();
}

class __ZipCodeAndLawnAreaInputFormState
    extends State<_ZipCodeAndLawnAreaInputForm> {
  final _zipCodeNode = FocusNode();
  final _lawnSizeNode = FocusNode();
  final _zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If LawnData is passed along from EditLawnProfile screen, we setup zipCode programmatically
    // ZipCode wouldn't be editable. Only Lawn Size is editable in this case.
    final zipCode = widget.lawnData?.lawnAddress?.zip ?? '';
    _zipCodeController.text = zipCode;
    if (zipCode.isNotEmpty) {
      widget.bloc.add(SetZipCodeFormEvent(zipCode));
    }
  }

  @override
  void dispose() {
    _zipCodeNode.dispose();
    _lawnSizeNode.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: BlocConsumer<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
          cubit: widget.bloc,
          listener: (context, state) {
            if (state.lawnSizeError != null &&
                state.lawnSize.isNotEmpty &&
                int.parse(state.lawnSize) > 200000) {
              showLawnSizeLimitErrorDialog(
                context: context,
                errorMessage: lawnSizeLimitError,
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextInputField(
                  key: Key('ScottsTextInput.zipCode'),
                  controller: _zipCodeController,
                  onChanged: widget.lawnData == null
                      ? widget.bloc.onZipCodeChanged
                      : null,
                  // we disable zipcode editing when user is coming from EditLawnProfile screen and only allow them to change just Lawn Size.
                  enabled: widget.lawnData == null,
                  textInputAction: TextInputAction.next,
                  labelText: 'Zip Code',
                  errorText: state.zipCodeError,
                  focusNode: _zipCodeNode,
                  textInputType: TextInputType.number,
                  maxLength: 5,
                  maxLengthEnforced: true,
                  onSubmitted: () =>
                      FocusScope.of(context).requestFocus(_zipCodeNode),
                  textInputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 16.0),
                TextInputField(
                  key: Key('ScottsTextInput.lawnSize'),
                  onChanged: widget.bloc.onLawnSizeChanged,
                  textInputAction: TextInputAction.done,
                  labelText: 'Lawn Size',
                  errorText: state.lawnSizeError,
                  focusNode: _lawnSizeNode,
                  textInputType: TextInputType.number,
                  onSubmitted: () =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  textInputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  'sq. ft.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ContinueToNextQuestionCard extends StatelessWidget {
  final LawnSizeZipCodeFormBloc bloc;
  final LawnData lawnData;
  _ContinueToNextQuestionCard({@required this.bloc, this.lawnData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
          cubit: bloc,
          listener: (context, state) {
            if (state is LawnSizeZipCodeFormSuccessState) {
              // Edit Lawn Profile flow
              if (lawnData != null) {
                final updatedLawnData = lawnData.copyWith(
                  lawnSqFt: int.parse(state.lawnSize),
                );
                registry<Navigation>().pop<LawnData>(updatedLawnData);
              }
              // Quiz Flow
              else {
                final results = [state.lawnSize, state.zipCode];
                registry<Navigation>().pop(results);
              }
            }
          },
          builder: (context, state) {
            return RaisedButton(
              key: Key('lawn_size_zipcode_screen_continue_button'),
              child: Text('CONTINUE'),
              onPressed:
                  state.lawnSizeError == null && state.zipCodeError == null
                      ? () => bloc.submitForm(state.zipCode, state.lawnSize)
                      : null,
            );
          },
        ),
      ),
    );
  }
}
