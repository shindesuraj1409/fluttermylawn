import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';

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
  var createAccountScreen;
  var planScreen;
  var signUpScreen;
  var productDetailsScreen;
  var buyOnlineScreen;
  var mainProductListingScreen;
  var productListingScreen;
  var email;

  final size = '25';
  final zip = '43203';
  final grass = 'I don\'t know my grass type';
  final availableProductName = 'Scotts® GrubEx® Season-Long Grub Killer';
  final retailersList=['Ace Hardware'];
  final noOfRetailers = 9;
  final unAvailableProductName =
      'Scotts® Turf Builder® Grass Seed Quality All-Purpose Mix';

  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionsScreen = LawnConditionScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypesScreen = GrassTypesScreen(driver);
    locationSharingScreen = LocationSharingScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
    planScreen = PlanScreen(driver);
    signUpScreen = SignUpScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
    mainProductListingScreen = MainProductListingScreen(driver);
    productListingScreen = ProductListingScreen(driver);
    buyOnlineScreen = BuyOnlineScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('C85194 Buy Online:', () {
    test(
      'Sign Up User',
      () async {
        // Create an account using an email
        email = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
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
        await signUpScreen.clickOnContinueWithEmailButton();
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'Available Product on Scotts',
      () async {
        // click on floating action button
        await planScreen.clickOnFloatingActionButton();

        sleep(Duration(seconds: 2));
        // click on product
        await planScreen.clickOnProductButton();

        //Click on Product Category
        await mainProductListingScreen
            .clickOnProductCategory('Insect & Disease Control');

        //Click on Product
        await productListingScreen
            .clickOnProductUsingName(availableProductName);

        //Verify Product Detail Screen
        await productDetailsScreen
            .verifyProductDetailsCommonElements(availableProductName);

        //Tap on Buy Now
        await productDetailsScreen.clickOnBuyNow();
        //Verify BottomSheet
        await productDetailsScreen.verifyBottomSheetOfBuyNow();
        //Click on Buy Online
        await productDetailsScreen.clickOnBuyOnline();
        // Verify Buy online screen
        await buyOnlineScreen.verifyBuyOnlineScreenIsDisplayed(isInStock: true);
        //Verify Retailers
        sleep(Duration(seconds: 5));
        await buyOnlineScreen
            .verifyBuyOnlineScreenRetailerElements(noOfRetailers);
        //Skipping Step 3,4 and 5 as it cant be automated

        await buyOnlineScreen.verifyRetailersOnBuyOnlineScreen(retailersList,
            isInStock: true);
        //Return back to PDP screen
        await buyOnlineScreen.goToBack();
        //Return back to PLP screen
        await productDetailsScreen.goToBack();
        //Return back to Main PLP screen
        await productListingScreen.goToBack();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'Product not available on Scotts/Retailer Site',
      () async {
        //Scroll To Bottom of Page
        await mainProductListingScreen.scrollTillEnd();
        //Tap on Bare Spots
        await mainProductListingScreen.clickOnLawnProblemMenu('Bare Spots');
        //Tap on Product
        await productListingScreen
            .clickOnProductUsingName(unAvailableProductName);

        //Verify Product Detail Screen
        await productDetailsScreen
            .verifyProductDetailsCommonElements(unAvailableProductName);

        //Tap on Buy Now
        await productDetailsScreen.clickOnBuyNow();
        //Verify BottomSheet
        await productDetailsScreen.verifyBottomSheetOfBuyNow();
        //Click on Buy Online
        await productDetailsScreen.clickOnBuyOnline();
        //Verify Buy online screen
        await buyOnlineScreen.verifyBuyOnlineScreenIsDisplayed(
            isInStock: false);
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
