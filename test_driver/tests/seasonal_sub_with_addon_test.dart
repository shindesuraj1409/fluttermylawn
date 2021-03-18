import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';
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
  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;
  var addonsList;

  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
    subscriptionCardProductDetails = recommendedProducts.subscriptionCardProductDetails;
    addonsList = recommendedProducts.addonsList;

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
      'C85694: Seasonal Subscription with Addon',
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

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // Verify Delivery screen
        await deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

        // TODO: Skipped the last two products verification on a subscription screen product carousel due to issue: https://scotts.jira.com/browse/CORE-1841
        // Verify product details in carousal section
        for (var productID = 0; productID < 2; productID++) {
          await deliveryScreen.verifyProductCardDetails(
              subscriptionCardProductDetails, productID);
        }

        // Verify Seasonal Subscription option
        await deliveryScreen.verifySeasonalSubscriptionOption(
            '\$17.49', '\$49.99', '\$25.99', '\$17.49');

        // Verify Seasonal Subscription option
        await deliveryScreen.verifySeasonalSubscriptionOption('', '', '', '');

        // Select Seasonal Subscription
        await deliveryScreen.selectSeasonalSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed(
            isAnnualSubscription: false);

        // Verify Seasonal Subscription
        await cartScreen.verifySeasonalSubscriptionIsDisplayed('17.49', 4);

        // Verify Addons
        await cartScreen.verifyAddonsCommonElementsAreDisplayed(
            addonsList.length,
            isAnnualSubscription: false);

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Add Addon to cart
        await cartScreen.addAddonToCart(4);

        // Verify Order Summary
        await cartScreen.verifyOrderSummary(
            false, '\$17.49', '-\$59.99', '\$77.48', 'FREE');

        // Verify Addon in Order Summary
        await cartScreen.verifyAddonInOrderSummary(
            addonsList[4][0], addonsList[4][1]);

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

        // Verify Checkout Order Summary Details
        await checkoutScreen.verifyOrderSummaryDetails(true, false, '\$17.49',
            '\$59.99', '\$77.48', 'FREE', '\$5.82', '\$83.30');

        // Verify Addon in Checkout Order Summary
        await checkoutScreen.verifyAddonInOrderSummary(
            addonsList[4][0], addonsList[4][1]);

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
        Duration(minutes: 20),
      ),
    );

    test(
      'run email parser script',
      () async {
        // TODO: To be implemented once backend email issue is fixed
        // email = 'automation.mylawn+' +
        //     await baseScreen.getFormattedTimeStamp() +
        //     '@gmail.com';
        // sleep(Duration(seconds: 30));

        await baseScreen.readingEmail(email);
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
