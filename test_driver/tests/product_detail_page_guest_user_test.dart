import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';
import '../utils/getRecommondedProducts.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects

  var splashScreen;
  var welcomeScreen;
  var lawnConditionsScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypesScreen;
  var locationSharingScreen;
  var planScreen;

  var signUpScreen;
  ProductDetailsScreen productDetailsScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  var productToVerify = '';
  final index = 1;

  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails =
        recommendedProducts.subscriptionCardProductDetails;
    productToVerify = subscriptionCardProductDetails[index][0];

    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('Product Detail Page', () {
    test(
      'C90838: PDP as a Guest',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue(
            'mostly_green'); //passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue(
            'some_grass'); //passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue(
            'no_weeds'); //passing weeds map key which present in lawn_condition_screen
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
        await signUpScreen.clickOnContinueWithGuestButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          //ToDo: Skipping product verification till issue CORE-1841 is resolved
          if (productID != 2) {
            await planScreen.verifyProductElementsAreDisplayed(
                subscriptionCardProductDetails, productID);
          }
        }
        //Tap on Product
        await planScreen.clickOnProduct(productToVerify, index);
        //Verify Product Details Screen
        await productDetailsScreen
            .verifyProductDetailsCommonElements(productToVerify);
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
