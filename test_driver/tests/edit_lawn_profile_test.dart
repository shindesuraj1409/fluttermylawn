import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';

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

  var profileScreen;
  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;
  var editLawnProfile;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final change_grass = 'Bluegrass/Rye/Fescue';
  final shipmentList = List.generate(4, (i) => List(2), growable: false);{};

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    shipmentList[0][0] = 'Scotts® Turf Builder® Lawn Food';
    shipmentList[0][1] = '\u00D7\u200A' '1';
    shipmentList[1][0] = "Scotts® Turf Builder® Thick'R Lawn® Bermudagrass";
    shipmentList[1][1] = '\u00D7\u200A' '1';
    shipmentList[2][0] = 'Scotts® Turf Builder® With SummerGuard®';
    shipmentList[2][1] = '\u00D7\u200A' '1';
    shipmentList[3][0] = 'Scotts® Turf Builder® Lawn Food';
    shipmentList[3][1] = '\u00D7\u200A' '1';

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
    deliveryScreen = DeliveryScreen(driver);
    cartScreen = CartScreen(driver);
    profileScreen = ProfileScreen(driver);
    editLawnProfile = EditLawnProfile(driver);
    checkoutScreen = CheckoutScreen(driver);
    orderConfirmationScreen = OrderConfirmationScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
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

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C70110: Retake Lawn Quiz - Same Plan',
      () async {
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnEditButton();

        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        await editLawnProfile.validateLawnProfileValues(false, grassType: grass,
            spreaderType: 'None', grassThickness: 'Some Grass', grassColor: 'Mostly Green',
            weeds: 'No Weeds');

        await editLawnProfile.clickOnRetakeLawnQuiz();

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

        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        await editLawnProfile.validateLawnProfileValues(false, grassType: grass,
            spreaderType: 'None', grassThickness: 'Some Grass', grassColor: 'Mostly Green',
            weeds: 'No Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69415: Edit Grass type',
      () async {
        // click on grass type
        await editLawnProfile.clickOnEditLawnProfileSections('GrassType', false);

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed(edit: true);
        await grassTypesScreen.selectGrassType(change_grass);

        await editLawnProfile.validateLawnProfileValues(false, grassType: change_grass);
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69417: Edit Spreader',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('SpreaderType', false);

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed(edit: true);
        await spreaderTypesScreen.selectSpreader('wheeled');

        await editLawnProfile.validateLawnProfileValues(false, spreaderType: 'Wheeled Spreader');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69418: Edit Lawn Condition',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('LawnCondition', false);

        await lawnConditionsScreen.setColorSliderValue('brown');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('thin_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('many_weeds');//passing weeds map key which present in lawn_condition_screen

        await lawnConditionsScreen.clickOnSaveButton();

        await editLawnProfile.validateLawnProfileValues(false, grassThickness: 'Thin Grass',
            grassColor: 'Brown', weeds: 'Many Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C72408: Cancel Editing Lawn Profile',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('LawnCondition', false);

        // change the value of lawn condition
        await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen

        await editLawnProfile.goToBack();
        // verify edit lawn profile screen with unchanged value
        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        await editLawnProfile.validateLawnProfileValues(false, grassType: change_grass,
            spreaderType: 'Wheeled Spreader', grassThickness: 'Thin Grass',
            grassColor: 'Brown', weeds: 'Many Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C72407: Cancel Retaking the Quiz',
      () async {
        await editLawnProfile.clickOnRetakeLawnQuiz();

        // try to change the grass looks
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();

        // verify spreader type screen is displayed
        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();

        await spreaderTypesScreen.goToBack();

        // verify lawn condition is displayed
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();

        await lawnConditionsScreen.goToBack();

        // verify edit lawn profile screen with unchanged value
        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        await editLawnProfile.validateLawnProfileValues(false, grassType: change_grass,
            spreaderType: 'Wheeled Spreader', grassThickness: 'Thin Grass',
            grassColor: 'Brown', weeds: 'Many Weeds');

        await editLawnProfile.clickOnCloseIcon();

        await profileScreen.goToBack();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'process till subscription',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // Verify Delivery screen
        await deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

        // Verify Annual Subscription option
        await deliveryScreen.verifyAnnualSubscriptionOption(
            '\$110.96', '\$99.86');

        // Select Annual Subscription
        await deliveryScreen.selectAnnualSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed();

        // Proceed to Checkout
        await cartScreen.clickOnCheckout();

        // Verify Checkout screen
        await checkoutScreen.verifyCheckoutShippingElementsAreDisplayed(true);

        // Fill Shipping details
        await checkoutScreen.fillCheckoutShippingDetails(true, shippingDetails);
        await checkoutScreen.clickContinueToPayment();

        // Verify Payment Details
        await checkoutScreen.verifyPaymentDetails(true);
        await checkoutScreen.fillPaymentDetails(true, paymentDetails);
        await checkoutScreen.clickOnContinueToOrderSummary();

        // Accept Subscription Confirmation Checkbox
        await checkoutScreen.acceptSubscriptionConfirmation();

        //here
        // Click on Place Order
        await checkoutScreen.clickOnPlaceOrder();

        // Verify Order Confirmation Screen
        await orderConfirmationScreen.verifyOrderConfirmationDetails();
        await orderConfirmationScreen.clickOnReturnHome();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C70113: Cancel Editing Lawn Address - Subscribed User',
      () async {
        // navigate to edit lawn profile screen
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnEditButton();

        // verify edit anyway bottom sheet is displayed
        await profileScreen.verifyEditProfileBottomSheet();
        await profileScreen.clickOnEditAnywayButton();
        await editLawnProfile.clickOnEditLawnProfileSections('LawnAddress', true);

        // verify bottom sheet is shown after clicking lawn address
        await editLawnProfile.verifyLawnAddressDialogElements();
        await editLawnProfile.clickOnGotItButton();

        // verify bottom sheet is shown after clicking lawn address is dissmissed
        await editLawnProfile.verifyLawnAddressModalIsDismissed();
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C70114: Cancel Just moved - Subscribed User',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('LawnAddress', true);

        // verify bottom sheet is shown after clicking lawn address
        await editLawnProfile.verifyLawnAddressDialogElements();
        await editLawnProfile.clickOnIHaveMovedButton();

        // verify bottom sheet is shown after clicking I Have Moved Button
        await editLawnProfile.verifyJustMovedDialogElements();
        sleep(Duration(seconds: 2));
        await editLawnProfile.clickOnJustMovedCloseIcon();

        await editLawnProfile
            .verifyBottomSheetAfterClickingIHaveMovedIsDismissed();
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
    test(
      'C70111: Retake Lawn Quiz - Modify Plan',
      () async {
        await editLawnProfile.clickOnRetakeLawnQuiz();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('brown');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('thin_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('many_weeds');//passing weeds map key which present in lawn_condition_screen

        await lawnConditionsScreen.clickOnSaveButton();

        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, '100');
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        await grassTypesScreen.selectGrassType(grass);

        await locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await locationSharingScreen.clickOnNotNow();

        // verify edit lawn profile screen
        await editLawnProfile.verifyEditProfileIsDisplayed(true);
        await editLawnProfile.validateLawnProfileValues(true, grassType: grass,
            lawnSize: 100, spreaderType: 'None', grassThickness: 'Thin Grass',
            grassColor: 'Brown', weeds: 'Many Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C70112: Edit Lawn Address - Subscribed User',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('LawnAddress', true);

        // verify bottom sheet is shown after clicking lawn address
        await editLawnProfile.verifyLawnAddressDialogElements();
        await editLawnProfile.clickOnIHaveMovedButton();

        // verify bottom sheet is shown after clicking I Have Moved Button
        await editLawnProfile.verifyJustMovedDialogElements();
        sleep(Duration(seconds: 2));
        await editLawnProfile.clickOnRetakeQuizButton();
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();

        await lawnSizeScreen.goToBack();
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C72530: Edit Lawn Size - Subscribed User',
      () async {
        await editLawnProfile.clickOnEditLawnProfileSections('LawnSize', true);

        await manualEntryScreen.verifyManualEntryScreenIsDisplayed(edit: true);
        await manualEntryScreen.typeInLawnSizeInputField('3097');
        await manualEntryScreen.clickOnContinueButton();

        await editLawnProfile.verifyEditProfileIsDisplayed(true);
        await editLawnProfile.validateLawnProfileValues(true, grassType: grass,
            lawnSize: 3097, spreaderType: 'None', grassThickness: 'Thin Grass',
            grassColor: 'Brown', weeds: 'Many Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
