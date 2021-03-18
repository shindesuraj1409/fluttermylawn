import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  var baseScreen;
  var splashScreen;
  var welcomeScreen;
  var createAccountScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  var locationSharingScreen;
  var planScreen;
  var homeScreen;
  var lawnTipsScreen;
  var email;
  var signUpScreen;


  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  // First 4 grass types
  final TIPS_SLIDER_CARD_DATA = <Map<String, String>>[
    {
      'tip_type': 'Lawns Matter',
      'tip_title': 'How use Triple Action (North)',
      'tip_description':
      'Get three benefits in one product with Scotts® Turf Builder® Triple Action. It kills weeds fast and prevents future weeds all while feeding and strengthening your lawn.',
      'reading_time': null
    },
    {
      'tip_type': 'Grass & Grass Seed',
      'tip_title': 'Fall is the Best Time to seed & Feed',
      'tip_description':
          'Fall isn’t just for pumpkin spice and picking apples. It’s also the best time to seed and feed your lawn.Fall isn’t just for pumpkin spice and picking apples. It’s also the best time to seed and feed your lawn.',
      'reading_time': '4 min Read'
    },
    {
      'tip_type': 'Lawn Care Basic',
      'tip_title': 'Another article',
      'tip_description':
          '# How to Reseed a Lawn\nWhen the weeds far outnumber the grass blades in your lawn, it’s time to reseed.\n- one\n- two\n- three\n# How to Reseed a Lawn\nWhen the weeds far outnumber the grass blades in your lawn, it’s time to reseed. \n- one \n- two \n- three',
      'reading_time': null
    }
  ];

  final ARTICLES_LIST = <Map<String, String>>[
    {
      'tip_type': 'DISEASE CONTROL',
      'tip_title': 'Easy Fixes for Common Lawn Problems',
      'reading_time': '4 min Read',
    },
    {
      'tip_type': 'DISEASE CONTROL',
      'tip_title': '5 Reasons for Thin Grass – and What to Do About It',
      'reading_time': '4 min Read',
    },
    {
      'tip_type': 'GRASS & GRASS SEED',
      'tip_title': 'How to Control Broadleaf Weeds',
      'reading_time': '4 min Read',
    },
    {
      'tip_type': 'OTHER LAWN PROBLEMS',
      'tip_title': 'Guide to 7 Common Lawn Weeds',
      'reading_time': '5 min Read',
    },
    {
      'tip_type': 'GRASS & GRASS SEED',
      'tip_title': 'How to Use Scotts Turf Builder Weed & Feed',
      'reading_time': null,
    },
  ];

  final DETAIL_ARTICLE = {
    'tip_title': 'Easy Fixes for Common Lawn Problems',
    'tip_description':
        'If you’re encountering lawn problems, you’re not alone. Luckily, there’s an easy fix for most issues. Here are solutions to 7 common lawn conundrums.',
    'reading_time': '4 min Read',
  };

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    baseScreen = BaseScreen(driver);
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    homeScreen = HomeScreen(driver);
    lawnTipsScreen = LawnTipsScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('C86532: Read a Lawn Tips Article', () {
    test(
      'C86532: Read a Lawn Tips Article',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        await grassTypesScreen.selectGrassType(grass);

        await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await locationSharingScreen.clickOnNotNow();

        // Sign up user
        await signUpScreen.waitForSignUpScreenLoading();
        await signUpScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();
        // Verify Home screen
        await homeScreen.verifyHomeScreenElementsAreDisplayed();
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        await homeScreen.clickOnTipsNavigationButton();
        await lawnTipsScreen.verifyLawnTipsScreenIsDisplayed();

        for (var index = 0; index < 2; index++) {
          await lawnTipsScreen.verifyTipsSliderOnScreen(
              TIPS_SLIDER_CARD_DATA[index], index);
        }
        await lawnTipsScreen.clickOnFiltersButton();

        await lawnTipsScreen.verifyFilterBox();

        await lawnTipsScreen.selectWeedControlArticleOnFilterBox();

        await lawnTipsScreen.clickOnShowArticlesButton();

        for (var index = 0; index < 2; index++) {
          await lawnTipsScreen.verifyWeedControlArticles(
              ARTICLES_LIST[index], index);
        }

        await lawnTipsScreen.clickOnArticlesTabButton();

        for (var index = 0; index < 2; index++) {
          await lawnTipsScreen.verifyWeedControlArticles(
              ARTICLES_LIST[index], index);
        }

        await lawnTipsScreen.clickOnVideosTabButton();

        await lawnTipsScreen.verifyWeedControlArticles(ARTICLES_LIST[4], 4);

        await lawnTipsScreen.clickOnArticlesTabButton();

        await lawnTipsScreen.clickOnArticle(DETAIL_ARTICLE);

        await lawnTipsScreen.verifyArticlePage(DETAIL_ARTICLE);

        await lawnTipsScreen.goToBack();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
