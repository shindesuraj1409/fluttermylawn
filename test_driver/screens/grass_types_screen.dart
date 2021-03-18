import 'package:flutter_driver/src/driver/driver.dart';

import 'base_screen.dart';

class GrassTypesScreen extends BaseScreen {
  final screen_parant_scroll_view = find.byType('CustomScrollView');
  final grass_types_screen_title = find.text('What is your grass type?');
  final grass_types_screen_sub_title =
      find.text('This helps us send you the right amount of products.');
  final progress_bar_value = find.byValueKey('progress_bar_value_1.0');


  // First 4 grass types
  List<String> GRASS_TYPES = [
  'I don\'t know my grass type',
    'Bermuda',
    'Bluegrass/Rye/Fescue',
    'Buffalo grass',
    'Fine Fescue',
    'Tall Fescue',
  ];

  GrassTypesScreen(FlutterDriver driver) : super(driver);

  Future<void> verifyGrassTypesScreenIsDisplayed({bool edit=false}) async {
    await verifyElementIsDisplayed(back_button);
    await verifyElementIsDisplayed(grass_types_screen_title);
    await verifyElementIsDisplayed(grass_types_screen_sub_title);
    if(!edit) {
      await verifyElementIsDisplayed(progress_bar_value);
    }
    for (var grassType in GRASS_TYPES) {
      await scrollTillElementIsVisible(find.text(grassType), parent_finder: screen_parant_scroll_view);
    }
  }

  Future<void> selectGrassType(String grassTypeToSelect) async {
        await scrollTillElementIsVisible(find.text('I don\'t know my grass type'), parent_finder: screen_parant_scroll_view,dy: 50);
        await scrollTillElementIsVisible(find.text(grassTypeToSelect), parent_finder: screen_parant_scroll_view,dy: -50);
        await clickOn(find.text(grassTypeToSelect));
    }


  Future<void> clickOnBackButton() async
  {
    await clickOn(back_button);
  }

  Future<void> verifyGrassTypes(grassTypes) async {
    for(var grassType in grassTypes) {
      await scrollTillElementIsVisible(find.text(grassType), parent_finder: screen_parant_scroll_view);
    };
  }
}
