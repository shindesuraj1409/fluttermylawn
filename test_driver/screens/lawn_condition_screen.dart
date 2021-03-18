import 'package:flutter_driver/flutter_driver.dart';

import 'base_screen.dart';

class LawnConditionScreen extends BaseScreen {
  final screen_title = find.text('What does your Lawn look like?');
  final color_slider_title = find.text('Color');
  final color_slider = find.byValueKey('slider_color');
  final thickness_slider_title = find.text('Thickness');
  final thickness_slider = find.byValueKey('slider_thickness');
  final weeds_slider_title = find.text('Weeds');
  final weeds_slider = find.byValueKey('slider_weeds');
  final save_button = find.byValueKey('lawn_condition_screen_save_button');
  final progress_bar_value = find.byValueKey('progress_bar_value_0.25');

  Map<String, String> grassColor = {
    'brown': '-36',
    'light_brown': '-18',
    'green_&_brown': '0',
    'mostly_green': '18',
    'very_green': '36',
  };

  Map<String, String> grassThickness = {
    'no_grass': '-36',
    'some_grass': '-18',
    'patchy_grass': '0',
    'thin_grass': '18',
    'thick_&_lush': '36',
  };

  Map<String, String> weeds = {
    'many_weeds': '-36',
    'several_weeds': '-18',
    'some_weeds': '0',
    'few_weeds': '18',
    'no_weeds': '36',
  };

  LawnConditionScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyLawnConditionIsDisplayed({bool authStatus=false, bool edit=false}) async {
    await verifyElementIsDisplayed(screen_title);
    await verifyElementIsDisplayed(color_slider_title);
    await verifyElementIsDisplayed(color_slider);
    await verifyElementIsDisplayed(thickness_slider_title);
    await verifyElementIsDisplayed(thickness_slider);
    await verifyElementIsDisplayed(weeds_slider_title);
    await verifyElementIsDisplayed(weeds_slider);
    await verifyElementIsDisplayed(save_button);
    if(!edit) {
      await verifyElementIsDisplayed(progress_bar_value);
    }
    if(!authStatus) {
      await verifyElementIsDisplayed(back_button);
    }
  }

  Future<void> setColorSliderValue(String grass_color) async {
    await scrollElement(color_slider, dx: double.parse(grassColor[grass_color]));
  }

  Future<void> setThicknessSliderValue(String grass_thickness) async {
    await scrollElement(thickness_slider, dx: double.parse(grassThickness[grass_thickness]));
  }

  Future<void> setWeedsSliderValue(String weedsCondition) async {
    await scrollElement(weeds_slider, dx: double.parse(weeds[weedsCondition]));
  }


  Future<void> clickOnSaveButton() async {
    await clickOn(save_button);
  }

  Future<void> clickOnBackButton() async
  {
    await clickOn(back_button);
  }

}
