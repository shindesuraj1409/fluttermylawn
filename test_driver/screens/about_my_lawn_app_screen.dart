import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class AboutMyLawnAppScreen extends BaseScreen {
  final screen_header = find.text('About the MyLawn App');
  final header_text = find.byValueKey('about_my_lawn_header_text');
  final key_features = find.byValueKey('key_features');
  final what_to_buy_header = find.byValueKey('what_to_buy');
  final what_to_buy_description = find.byValueKey('what_to_buy_description');

  final when_to_apply_header = find.byValueKey('when_to_apply');
  final when_to_apply_description =
      find.byValueKey('when_to_apply_description');
  final purchase_header = find.byValueKey('purchase');
  final purchase_description = find.byValueKey('purchase_description');
  final customize_plan_header = find.byValueKey('customize_your_plan');

  final customize_plan_description =
      find.byValueKey('customize_your_plan_description');
  final calculate_plan_header = find.byValueKey('calculate_your_plan');
  final calculate_plan_description =
      find.byValueKey('calculate_your_plan_description');
  final help_header = find.byValueKey('ask_scotts_for_help');
  final help_description = find.byValueKey('ask_scotts_for_help_description');

  final lawn_care_header = find.byValueKey('lawn_care_tips');
  final lawn_care_description = find.byValueKey('lawn_care_tips_description');
  final water_tracking_header = find.byValueKey('water_tracking');
  final water_tracking_description =
      find.byValueKey('water_tracking_description');

  AboutMyLawnAppScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyAboutMyLawnAppScreenElementsAreDisplayed() async {
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(screen_header);
    assert(
        await getText(header_text) ==
            'The My Lawn app from Scotts simplifies lawn care by creating an easy-to-follow lawn maintenance plan so you know the right products to use at the right time.',
        'header text is not matched');
    assert(
        await getText(key_features) == 'Key Features', 'Text is not matched');
    assert(await getText(what_to_buy_header) == 'What to Buy',
        'Text is not matched');
    assert(
        await getText(what_to_buy_description) ==
            'Create a lawn care plan for product recommendations. My lawn will generate a personalized lawn care plan based on your grass type, location, lawn size, and lawn conditions.',
        'Text is not matched');
    assert(await getText(when_to_apply_header) == 'When to Apply',
        'Text is not matched');
    assert(
        await getText(when_to_apply_description) ==
            'Create a lawn care plan for product recommendations. My lawn will generate a personalized lawn care plan based on your grass type, location, lawn size, and lawn conditions.',
        'Text is not matched');
    assert(await getText(purchase_header) == 'Purchase', 'Text is not matched');
    assert(
        await getText(purchase_description) ==
            'During the growing season, conveniently purchase all the Scotts products needed to care for your lawn for the rest of the season. Products will be delivered straight to your home with free shipping.',
        'Text is not matched');
    assert(await getText(customize_plan_header) == 'Customize Your Plan',
        'Text is not matched');
    assert(
        await getText(customize_plan_description) ==
            'Add or remove products within your lawn care plan. Within the My Lawn App, you have the option to add additional feed, seed, grub, and weed treatments to your plan.',
        'Text is not matched');
    assert(await getText(calculate_plan_header) == 'Calculate Your Plan',
        'Text is not matched');
    assert(
        await getText(calculate_plan_description) ==
            "Don't know how much to purchase? Use the Lawn Size calculator in the My Lawn App. This tool will help you calculate the size of your lawn.",
        'Text is not matched');
    assert(await getText(help_header) == 'Ask Scotts for Help',
        'Text is not matched');
    assert(
        await getText(help_description) ==
            "Email, call or text the Scotts representatives for even more lawn care advice. Whether you have a question about how much product to use, or need help identifying and removing a specific type of weed, you'll always have the knowledge of Scotts experts just a tap away",
        'Text is not matched');
    assert(await getText(lawn_care_header) == 'Lawn Care Tips',
        'Text is not matched');
    assert(
        await getText(lawn_care_description) ==
            'Expert articles from the Scotts team and library of helpful videos.',
        'Text is not matched');
    assert(await getText(water_tracking_header) == 'Water Tracking',
        'Text is not matched');
    assert(
        await getText(water_tracking_description) ==
            'Track and manage the amount of water your lawn gets each week by the automatic local rainfall totals and by manually adding when you water your lawn',
        'Text is not matched');
  }
}
