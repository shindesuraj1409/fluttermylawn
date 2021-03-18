import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/calendar/entity/calendar_events.dart';

import 'image_with_token.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    @required this.event,
    Key key,
  }) : super(key: key);

  final CalendarEvents event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildText()),
        if (event.note.imagePath != null) _buildImage(),
      ],
    );
  }

  Widget _buildText() {
    return Text(
      event.note.description ?? '',
      key: Key('note_description'),
      style: const TextStyle(
        color: Styleguide.color_gray_9,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImage() {
    if (event.note.imagePath != null) {
      return ImageWithToken(
        noteData: event.note,
        height: 56,
        width: 56,
        fit: BoxFit.fill,
      );
    } else {
      return Container();
    }
  }
}
