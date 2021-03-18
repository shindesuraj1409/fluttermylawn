import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../utils/getRecommondedProducts.dart';

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
  var email;
  var signUpScreen;
  var mainProductListingScreen;
  var productListingScreen;
  var productDetailsScreen;
  var addProductScreen;
  var profileScreen;
  var myScottsAccountScreen;
  var homeScreen;
  var calendarScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;


  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';



  final productCategory = 'Insect & Disease Control';
  final productName = 'Scotts® GrubEx® Season-Long Grub Killer';
  final futureDate = DateTime.now().add(Duration(days: 20));


  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails = recommendedProducts.subscriptionCardProductDetails;

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
    productListingScreen = ProductListingScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
    addProductScreen = AddProductScreen(driver);
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
    homeScreen = HomeScreen(driver);
    calendarScreen = CalenderScreen(driver);

  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C91525: Add a Product Manually',
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

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }
        //click on floating action button
        await planScreen.clickOnFloatingActionButton();

        //verify floating action button elements
        await planScreen.verifyFloatingActionButtonElementsAreDisplayed();

        //Click on product icon
        await planScreen.clickOnProductButton();
        //verify main product listing screen
        await mainProductListingScreen.verifyMainProductListingScreen();
        //click on category
        await mainProductListingScreen.clickOnInsectAndDiseaseControl();
        //verify product listing screen
        await productListingScreen.verifyProductScreen(productCategory);
        //click on product
        await productListingScreen.clickOnProductUsingName(productName);
        //verify comment elements on product details screen
        await productDetailsScreen.verifyProductDetailsCommonElements(productName,productCategory,'Main Category');
        //click on use this product button
        await productDetailsScreen.clickOnUseThisProduct();
        //verify add product screen
        await addProductScreen.verifyAddProductScreen(productName);
        //click on edit button on add product screen
        await addProductScreen.clickOnEditButton();
        //verify date picker dialog
        await addProductScreen.verifyDatePickerDialog();
        //click on cancel button
        await addProductScreen.clickOnDatePickerCancelButton();
        //select future date
        await addProductScreen.selectDateForWhenField(
            day: futureDate.day,
            year: futureDate.year,
            month: futureDate.month);
        //enter text in text-box on add product screen
        await addProductScreen.enterTextInTextBox('This is a test note for adding product $productName');
        //click on save button on add product screen
        await addProductScreen.clickOnSaveButton();
        //verify added to calendar message
        await addProductScreen.verifyProductAddedNotificationIsDisplayed('Added to Calendar');

        //verify manually added product details
        await planScreen.verifyAddedByMe(futureDate, productName);
        //click on manually added product
        await planScreen.clickOnManuallyAddedProduct(futureDate, productName);
        //verify product details on product detail screen
        await productDetailsScreen.verifyProductDetailsCommonElements(
            productName,productCategory,'Main Category');
        //verify added by me badge on product details screen
        await productDetailsScreen.verifyAddedByMe();
        //click on back button
        await productDetailsScreen.goToPlanScreen();
        await sleep(Duration(seconds: 5));
        //click on calendar icon/button
        await homeScreen.clickOnCalendarNavigationButton();
        //verify calendar screen common elements
        await calendarScreen.verifyCalenderScreenCommonElementsAreDisplayed();
        //verify product activity on calendar screen
        await calendarScreen.verifyAddedByMeCalender(futureDate, productName);
        await sleep(Duration(seconds: 5));
        //Navigate to plan screen
        await homeScreen.clickOnPlanNavigationButton();
        await sleep(Duration(seconds: 5));
        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed();

        //click on My Scotts Account
        await profileScreen.clickOnMyScottsAccount();
        //click on logout button
        await myScottsAccountScreen.clickOnLogoutButton();

        //click on drawer logout button
        await myScottsAccountScreen.clickOnDrawerLogoutButton();

      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'C100948: Add a Product Manually - Guest User',
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
        await signUpScreen.clickOnContinueWithGuestButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        //click on floating action button
        await planScreen.clickOnFloatingActionButton();

        //verify floating action button elements
        await planScreen.verifyFloatingActionButtonElementsAreDisplayed();

        //Click on product icon
        await planScreen.clickOnProductButton();
        //verify main product listing screen
        await mainProductListingScreen.verifyMainProductListingScreen();
        //click on category
        await mainProductListingScreen.clickOnInsectAndDiseaseControl();
        //verify product listing screen
        await productListingScreen.verifyProductScreen(productCategory);
        //click on product
        await productListingScreen.clickOnProductUsingName(productName);
        //verify comment elements on product details screen
        await productDetailsScreen.verifyProductDetailsCommonElements(productName,productCategory,'Main Category');
        //click on use this product button
        await productDetailsScreen.clickOnUseThisProduct();

        //verify signUp bottom sheet
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();


      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

  });
}
