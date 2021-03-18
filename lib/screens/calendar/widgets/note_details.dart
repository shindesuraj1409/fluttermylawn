import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/note_data.dart';
import 'package:my_lawn/screens/calendar/widgets/details_header.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:navigation/navigation.dart';

import 'image_with_token.dart';

class NoteDetails extends StatelessWidget {
  const NoteDetails({
    @required this.noteData,
    @required this.onDeleteTap,
    Key key,
  }) : super(key: key);

  final NoteData noteData;
  final VoidCallback onDeleteTap;

  void _onEditTap() {
    registry<Navigation>().pushReplacement('/addnote', arguments: noteData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DetailsHeader(onDeleteTap: onDeleteTap, date: noteData.date),
        if (noteData.description != null) _buildText(),
        if (noteData.imagePath != null) _buildImage(),
        _buildButton(),
      ],
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: FullTextButton(
        text: 'EDIT',
        onTap: _onEditTap,
        color: Styleguide.color_green_4,
      ),
    );
  }

  Widget _buildText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        noteData.description,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildImage() {
    if (noteData.imagePath != null) {
      return ImageWithToken(
        noteData: noteData,
        height: 312,
        width: 312,
      );
    } else {
      return Container();
    }
  }
}
