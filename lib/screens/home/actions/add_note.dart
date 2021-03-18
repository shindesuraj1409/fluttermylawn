import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/widgets/login_widget.dart';
import 'package:my_lawn/blocs/calendar/calendar_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_event.dart';
import 'package:my_lawn/blocs/note/add_note_bloc.dart';
import 'package:my_lawn/blocs/note/add_note_event.dart' hide AddNoteEvent;
import 'package:my_lawn/blocs/note/add_note_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/calendar/widgets/image_with_token.dart';
import 'package:my_lawn/services/analytic/actions/localytics/customize_plan_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/note/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/note/state.dart';
import 'package:my_lawn/widgets/add_note_fab.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  ThemeData _theme;

  final _textFieldController = TextEditingController();
  String fieldValue = '';

  bool hasEditedImage;

  final ImagePicker _picker = ImagePicker();
  String _filePath = '';

  AddNoteBloc _bloc;
  NoteData _note;

  @override
  void initState() {
    super.initState();
    _bloc = registry<AddNoteBloc>();
    _bloc.listen(_onStateChanged);
    hasEditedImage = false;
    sendAdobeAnalyticState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _note = ModalRoute.of(context).settings?.arguments as NoteData;
    _filePath = _note?.imagePath ?? '';
    fieldValue = _note?.description ?? '';
    _textFieldController.text = fieldValue;

    _theme = Theme.of(context);
  }

  void sendAdobeAnalyticState() {
    registry<AdobeRepository>().trackAppState(
      AddNoteScreenAdobeState(),
    );
  }

  void _saveNote() {
    registry<LocalyticsService>().tagEvent(AddNoteEvent());
    registry<AdobeRepository>().trackAppActions(NoteAddedScreenAdobeAction());
    _bloc.add(SaveNoteEvent(
      description: fieldValue,
      imagePath: _filePath,
      noteId: _note?.notesId,
      isUpdatingImage: hasEditedImage,
    ));
  }

  void _onStateChanged(AddNoteState state) {
    if (state is AddNoteSuccessState) {
      registry<Navigation>().popToRoot().then(
            (_) => showSnackbar(
              context: context,
              text: 'Added to Calendar',
              duration: Duration(seconds: 2),
            ),
          );
    }
  }

  void returnToHome() {
    registry<Navigation>().popToRoot();
  }

  void _onImageButtonPressed(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      registry<Logger>().d(pickedFile.path);
      setState(() {
        _filePath = pickedFile.path;
        hasEditedImage = true;
      });
    } catch (e) {
      registry<Logger>().d(e);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
      setState(() {
        _filePath = e;
      });
    }
  }

  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return PlatformAwareAlertDialog(
          content: null,
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                registry<Navigation>().pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _filePath = '';
                  hasEditedImage = true;
                });
                registry<Navigation>().pop();
              },
            ),
          ],
          title: Text(
            'Delete the image?',
            style: _theme.textTheme.subtitle1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = registry<AuthenticationBloc>().state.isGuest;
    Widget _bottomButton() => Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(16),
            width: 120,
            height: 52,
            child: RaisedButton(
                color: Styleguide.color_green_4.withOpacity(
                    fieldValue.isNotEmpty || _filePath.isNotEmpty ? 1 : 0.5),
                child: Text('SAVE'),
                onPressed: () {
                  if (fieldValue.isNotEmpty || _filePath.isNotEmpty) {
                    if (isGuest) {
                      buildLoginBottomCard(context);
                    } else {
                      _saveNote();
                    }
                  }
                }),
          ),
        );
    Widget _build() => BasicScaffold(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/paper_texture.png'),
              fit: BoxFit.cover,
            )),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => returnToHome(),
                            icon: Icon(
                              Icons.close,
                              size: 32,
                              color: Styleguide.color_gray_9,
                              key: Key('cancel_button'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'Write a Note',
                              style: _theme.textTheme.headline1.copyWith(
                                fontSize: 35,
                              ),
                            ),
                          ),
                          TextFormField(
                            key: Key('note_text_input'),
                            autofocus: true,
                            controller: _textFieldController,
                            cursorColor: Colors.black,
                            onChanged: (String value) {
                              setState(() {
                                fieldValue = value;
                              });
                            },
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: _theme.textTheme.subtitle1,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 100, right: 15),
                                hintText: 'Start writing',
                                hintStyle: _theme.textTheme.subtitle1
                                    .copyWith(color: Styleguide.color_gray_4)),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    _filePath.isEmpty
                        ? AddNoteFab(_onImageButtonPressed)
                        : Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 88,
                              width: 88,
                              margin: EdgeInsets.only(left: 16, bottom: 16),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                0x33, 0x00, 0x00, 0x00),
                                            blurRadius: 5.0,
                                            spreadRadius: -1.0,
                                            offset: Offset(
                                              0.0,
                                              3.0,
                                            ),
                                          ),
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                0x1E, 0x00, 0x00, 0x00),
                                            blurRadius: 18.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(
                                              0.0,
                                              1.0,
                                            ),
                                          ),
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                0x23, 0x00, 0x00, 0x00),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(
                                              0.0,
                                              6.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                        child: Container(
                                          child: ClipRRect(
                                            child: (_note != null &&
                                                    _note.notesId != null &&
                                                    hasEditedImage == false)
                                                ? ImageWithToken(
                                                    noteData: _note,
                                                    height: 90,
                                                    width: 140,
                                                  )
                                                : Image.file(
                                                    File(_filePath),
                                                    height: 90,
                                                    width: 140,
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showDeleteDialog();
                                      },
                                      child: Image.asset(
                                        'assets/icons/remove_solid.png',
                                        width: 22,
                                        height: 22,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    _bottomButton(),
                    _buildLoader(),
                  ],
                ),
              ),
            ),
          ),
        );
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          cubit: registry<LoginBloc>(),
          listener: (context, state) {
            if (state is PendingRegistrationState) {
              registry<Navigation>().push(
                '/auth/pendingregistration',
                arguments: {'email': state.email, 'regToken': state.regToken},
              );
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          cubit: registry<AuthenticationBloc>(),
          listener: (context, state) {
            if (!state.isGuest) {
              _saveNote();
            }
          },
        ),
      ],
      child: BlocConsumer<AddNoteBloc, AddNoteState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state is AddNoteErrorState) {
            showSnackbar(
              context: context,
              text: state.errorMessage,
              duration: Duration(seconds: 2),
            );
          }
        },
        builder: (context, state) => _build(),
      ),
    );
  }

  Widget _buildLoader() {
    return BlocBuilder<AddNoteBloc, AddNoteState>(
      cubit: _bloc,
      builder: (context, state) {
        if (state is AddNoteLoadingState) {
          return Center(child: const ProgressSpinner());
        } else {
          if (state is AddNoteErrorState) {
            return const SizedBox();
          } else if (state is AddNoteSuccessState) {
            registry<CalendarBloc>().add(InitialCalendarEvent());
            return const SizedBox();
          }
        }
        return SizedBox();
      },
    );
  }
}
