import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class AddNoteScreen extends BaseScreen {
  final cancel_note_button = find.byValueKey('cancel_button');
  final save_button = find.text('SAVE');
  final attachment_button = find.byValueKey('attachment_button');
  final note_input = find.byValueKey('note_text_input');
  final from_gallery_icon = find.byValueKey('from_gallery_icon');
  final take_photo_icon = find.byValueKey('take_photo_icon');

  AddNoteScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyNoteScreenCommonElementsAreDisplayed() async {
    await verifyElementIsDisplayed(cancel_note_button);
    await verifyElementIsDisplayed(note_input);
    await verifyElementIsDisplayed(attachment_button);
    await verifyElementIsDisplayed(save_button);
    await clickOn(attachment_button);
    await verifyElementIsDisplayed(from_gallery_icon);
    await verifyElementIsDisplayed(take_photo_icon);
    await clickOn(attachment_button);
  }

  Future<void> enterNote(String note) async {
    await typeIn(note_input, note);
  }

  Future<void> clickOnSave() async {
    await clickOn(save_button);
  }

  Future<void> clickOnCancelButton() async {
    await clickOn(cancel_note_button);
  }
}
