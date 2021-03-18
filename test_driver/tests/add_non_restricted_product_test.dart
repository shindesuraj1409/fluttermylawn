import 'dart:io' hide Platform;
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

void main() {
  FlutterDriver driver;

  // Screens objects
  BaseScreen baseScreen;
  SplashScreen splashScreen;
  WelcomeScreen welcomeScreen;
  CreateAccountScreen createAccountScreen;
  LawnConditionScreen lawnConditionsScreen;
  SpreaderTypesScreen spreaderTypesScreen;
  LawnSizeScreen lawnSizeScreen;
  ManualEntryScreen manualEntryScreen;
  GrassTypesScreen grassTypesScreen;
  LocationSharingScreen locationSharingScreen;
  PlanScreen planScreen;
  SignUpScreen signUpScreen;
  MainProductListingScreen mainProductListingScreen;
  ProductDetailsScreen productDetailsScreen;
  CalenderScreen calenderScreen;

  var email;
  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';
  final productName = 'Scotts® GrubEx® Season-Long Grub Killer';
  final futureDate = DateTime.now().add(Duration(days: 20));


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
    mainProductListingScreen = MainProductListingScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
    calenderScreen = CalenderScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    await driver?.close();
  });
  group('C86099: Add a Non-Restricted Product', () {
    test(
      'complete the process till the plan screen',
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
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'saving a product via product detail screen',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // click on floating action button
        await planScreen.clickOnFloatingActionButton();

        sleep(Duration(seconds: 2));

        // click on product
        await planScreen.clickOnProductButton();

        await mainProductListingScreen.clickOnInsectAndDiseaseControl();
        sleep(Duration(seconds: 2));
        await mainProductListingScreen.clickOnProductFromCategory();
        sleep(Duration(seconds: 2));
        await productDetailsScreen.clickOnUseThisProduct();
        await productDetailsScreen.selectDateForWhenField(
            day: futureDate.day,
            year: futureDate.year,
            month: futureDate.month);
        await productDetailsScreen.clickOnSaveButton();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test('verifying \'added by me\' tag in home and calendar screens',
        () async {
      await planScreen.verifyAddedByMe(futureDate, productName);
      await planScreen.changeIndexBottomNavigationBar();
      await calenderScreen.verifyAddedByMeCalender(futureDate, productName);
    });
  });
}
