import 'package:flutter_driver/src/driver/driver.dart';

import 'screens.dart';

class AskScreen extends BaseScreen {
  AskScreen(FlutterDriver driver) : super(driver);
  final email_us = find.byValueKey('email_us');
  final call_us = find.byValueKey('call_us');
  final text_us = find.byValueKey('text_us');
  final email_us_text = find.text('Typically replies in 3 business days');
  final call_us_text = find.text('Wait times may be long due to COVID');
  final text_us_text = find.text('Get a quick response from us');
  final article_sub_title = find.text('Add Custom Products');
  final call_scotts = find.text('Call Scotts');
  final call_text = find.text('Call');
  final cancel_text = find.text('Cancel');

  final ask_question = [
    'My Lawn Care Plan',
    'Feed & Seed Activities',
    'Rainfall Total'
  ];

  Future<void> verifyAskScreenIsDisplayed() async {
    await verifyElementIsDisplayed(email_us);
    await verifyElementIsDisplayed(call_us);
    await verifyElementIsDisplayed(text_us);
    await verifyElementIsDisplayed(email_us_text);
    await verifyElementIsDisplayed(call_us_text);
    await verifyElementIsDisplayed(text_us_text);
    for (var item in ask_question) {
      await verifyElementIsDisplayed(find.text(item));
    }
  }

  Future<void> clickOnMyLawnCarePlan() async {
    await clickOn(find.text(ask_question[0]));
  }

  Future<void> clickOnFeedAndSeedActivities() async {
    await clickOn(find.text(ask_question[1]));
  }

  Future<void> clickOnRainfallTotal() async {
    await clickOn(find.text(ask_question[2]));
  }

  Future<void> goToAskScreen() async {
    await goToBack();
  }

  Future<void> verifyMyLawnCarePlanArticleIsDispplayed() async {
    await verifyElementIsDisplayed(find.text(ask_question[0]));
    await scrollTillElementIsVisible(article_sub_title);
  }

  Future<void> verifyFeedAndSeedActivitiesIsDispplayed() async {
    await verifyElementIsDisplayed(find.text(ask_question[1]));
  }

  Future<void> verifyRainfallTotalIsDispplayed() async {
    await verifyElementIsDisplayed(find.text(ask_question[2]));
  }

  Future<void> verifyCallUsDialogue() async {
    await verifyElementIsDisplayed(call_scotts);
    await verifyElementIsDisplayed(cancel_text);
    await verifyElementIsDisplayed(call_text);
  }

  Future<void> verifyEmailUs() async {
    await verifyElementIsDisplayed(email_us);
  }

  Future<void> verifyCallUs() async {
    await verifyElementIsDisplayed(call_us);
  }

  Future<void> verifyTextUs() async {
    await verifyElementIsDisplayed(text_us);
  }
}
