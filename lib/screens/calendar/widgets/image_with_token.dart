import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class ImageWithToken extends StatefulWidget {
  const ImageWithToken({
    @required this.noteData,
    Key key,
    this.height = 300,
    this.width,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  final NoteData noteData;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  _ImageWithTokenState createState() => _ImageWithTokenState();
}

class _ImageWithTokenState extends State<ImageWithToken> {
  final _notesService = registry<NotesService>();
  final user = registry<AuthenticationBloc>().state?.user;
  String imagePath;
  Map<String, String> headers;

  @override
  void initState() {
    imagePath = widget.noteData.imagePath != null
        ? _notesService.getNoteWithImagePath(
            user.customerId, widget.noteData.notesId, widget.noteData.imagePath)
        : null;

    asyncMethod();
    super.initState();
  }

  void asyncMethod() async {
    headers = await _notesService.prepareImageHeader();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (headers != null && imagePath != null) {
      return Image.network(
        imagePath,
        headers: headers,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          if (frame == null) {
            return Center(child: ProgressSpinner());
          }
          return child;
        },
        loadingBuilder: (context, child, loadingProgress) => Container(
          height: widget.height,
          width: widget.width,
          child: child,
        ),
        errorBuilder: (_, __, ___) =>
            Container(height: widget.height, width: widget.width),
      );
    } else {
      return Container();
    }
  }
}
