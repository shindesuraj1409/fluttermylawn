import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';
import '../utils/getRecommondedProducts.dart';

import '../screens/screens.dart';

void main() async {
  FlutterDriver driver;
  BaseScreen _baseScreen;
  SplashScreen _splashScreen;
  WelcomeScreen _welcomeScreen;
  CreateAccountScreen _createAccountScreen;
  LawnConditionScreen _lawnConditionsScreen;
  SpreaderTypesScreen _spreaderTypesScreen;
  LawnSizeScreen _lawnSizeScreen;
  ManualEntryScreen _manualEntryScreen;
  GrassTypesScreen _grassTypesScreen;
  LocationSharingScreen _locationSharingScreen;
  PlanScreen _planScreen;
  SignUpScreen _signUpScreen;
  DeliveryScreen _deliveryScreen;
  CartScreen _cartScreen;
  CheckoutScreen _checkoutScreen;
  OrderConfirmationScreen _orderConfirmationScreen;
  MySubscriptionScreen _mySubscriptionScreen;

  var email;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;
  var addonsList;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final shipmentList = List.generate(4, (i) => List(2), growable: false);

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails =
        recommendedProducts.subscriptionCardProductDetails;
    addonsList = recommendedProducts.addonsList;

    shipmentList[0][0] = 'Scotts® Turf Builder® Lawn Food';
    shipmentList[0][1] = '\u00D7\u200A' '1';
    shipmentList[1][0] = "Scotts® Turf Builder® Thick'R Lawn® Bermudagrass";
    shipmentList[1][1] = '\u00D7\u200A' '1';
    shipmentList[2][0] = 'Scotts® Turf Builder® With SummerGuard®';
    shipmentList[2][1] = '\u00D7\u200A' '1';
    shipmentList[3][0] = 'Scotts® Turf Builder® Lawn Food';
    shipmentList[3][1] = '\u00D7\u200A' '1';

    await sleep(Duration(seconds: 1));
    _baseScreen = BaseScreen(driver);
    _splashScreen = SplashScreen(driver);
    _welcomeScreen = WelcomeScreen(driver);
    _createAccountScreen = CreateAccountScreen(driver);
    _lawnConditionsScreen = LawnConditionScreen(driver);
    _spreaderTypesScreen = SpreaderTypesScreen(driver);
    _lawnSizeScreen = LawnSizeScreen(driver);
    _manualEntryScreen = ManualEntryScreen(driver);
    _grassTypesScreen = GrassTypesScreen(driver);
    _locationSharingScreen = LocationSharingScreen(driver);
    _planScreen = PlanScreen(driver);
    _signUpScreen = SignUpScreen(driver);
    _deliveryScreen = DeliveryScreen(driver);
    _cartScreen = CartScreen(driver);
    _checkoutScreen = CheckoutScreen(driver);
    _orderConfirmationScreen = OrderConfirmationScreen(driver);
    _mySubscriptionScreen = MySubscriptionScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('deep links tests', () {
    group('Annual Subscription without Addon', () {
      setUp(() async {
        // Create an account using an email
        await _splashScreen.verifySplashScreenIsDisplayed();
        await _welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await _welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await _lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await _lawnConditionsScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await _lawnConditionsScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await _lawnConditionsScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await _lawnConditionsScreen.clickOnSaveButton();

        await _spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await _spreaderTypesScreen.selectSpreader('no');

        await _lawnSizeScreen.clickOnManualEnterLawnSizeLink();
        await _manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await _manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await _manualEntryScreen.clickOnContinueButton();

        await _grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
        await _grassTypesScreen.selectGrassType(grass);

        await _locationSharingScreen.verifyLocalDealsScreenIsDisplayed();
        await _locationSharingScreen.clickOnNotNow();

        // Sign up user
        await _signUpScreen.waitForSignUpScreenLoading();
        await _signUpScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            await _baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await _createAccountScreen.enterEmail(email);
        await _createAccountScreen.clickOnContinueButton();
        await _createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await _createAccountScreen.enterPassword('Pass123!@#');
        await _createAccountScreen.waitForCreateAccountScreenLoading();
        await _createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
        await _planScreen.waitForPlanScreenLoading();
        await _planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await _planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }

        // Subscribe
        await _planScreen.clickOnSubscribeNow();

        // Verify Delivery screen
        await _deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

        // Verify product details in carousal section
        for (var productID = 0; productID < 2; productID++) {
          await _deliveryScreen.verifyProductCardDetails(
              subscriptionCardProductDetails, productID);
        }

        // Verify Annual Subscription option
        await _deliveryScreen.verifyAnnualSubscriptionOption(
            '\$110.96', '\$99.86');

        // Verify Seasonal Subscription option
        await _deliveryScreen.verifySeasonalSubscriptionOption('', '', '', '');

        // Click on continue
        await _deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await _cartScreen.verifyCartScreenIsDisplayed();

        // Verify Annual Subscription
        await _cartScreen.verifyAnnualSubscriptionIsDisplayed(
            '\$110.96', '99.86', 4);

        // Verify Addons
        await _cartScreen
            .verifyAddonsCommonElementsAreDisplayed(addonsList.length);

        // Verify addons detail
        await _cartScreen.scrollAddonInView();
        await sleep(Duration(seconds: 2));

        for (var addonID = 0; addonID < 5; addonID++) {
          await _cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Verify Order Summary
        await _cartScreen.verifyOrderSummary(
            true, '\$110.96', '-\$11.10', '\$99.86', 'FREE');

        // Proceed to Checkout
        await _cartScreen.clickOnCheckout();

        // Verify Checkout screen
        await _checkoutScreen.verifyCheckoutShippingElementsAreDisplayed(true);

        // Fill Shipping details
        await _checkoutScreen.fillCheckoutShippingDetails(
            true, shippingDetails);
        await _checkoutScreen.clickContinueToPayment();

        // Verify Payment Details
        await _checkoutScreen.verifyPaymentDetails(true);
        await _checkoutScreen.fillPaymentDetails(true, paymentDetails);
        await _checkoutScreen.clickOnContinueToOrderSummary();

        // Verify Checkout Order Summary Details
        await _checkoutScreen.verifyOrderSummaryDetails(true, true, '\$110.96',
            '-\$11.10', '\$99.86', 'FREE', '\$7.48', '\$107.34');

        // Accept Subscription Confirmation Checkbox
        await _checkoutScreen.acceptSubscriptionConfirmation();

        //here
        // Click on Place Order
        await _checkoutScreen.clickOnPlaceOrder();

        // Verify Order Confirmation Screen
        await _orderConfirmationScreen.verifyOrderConfirmationDetails();
        await _orderConfirmationScreen.clickOnReturnHome();
        await sleep(Duration(seconds: 30));
      });

      test('/mysubscriptionscreen', () async {
        await driver.requestData('raiseDeepLink|/mysubscriptionscreen');
        await _mySubscriptionScreen.verifyMySubscriptionScreenIsDisplayed(
            true,
            true,
            subscriptionCardProductDetails,
            paymentDetails,
            shippingDetails,
            shipmentList);
      });
    });
  }, timeout: Timeout(Duration(minutes: 10)));
}
