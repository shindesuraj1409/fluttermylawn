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

  var profileScreen;
  var mySubscriptionScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;
  var addonsList;

  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';
  final shipmentList = List.generate(4, (i) => List(3), growable: false);

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

    shipmentList[0][0] = 'A bag of Scotts® Turf Builder® Lawn Food (5m)';
    shipmentList[0][1] = '\u00D7\u200A' '1';
    shipmentList[0][2] = '\u00D7\u200A' '0';

    shipmentList[1][0] =
        "A bag of Scotts® Turf Builder® Thick'R Lawn® Bermudagrass (5m)";
    shipmentList[1][1] = '\u00D7\u200A' '1';
    shipmentList[1][2] = '\u00D7\u200A' '0';

    shipmentList[2][0] =
        'A bag of Scotts® Turf Builder® With SummerGuard® (5m)';
    shipmentList[2][1] = '\u00D7\u200A' '1';
    shipmentList[2][2] = '\u00D7\u200A' '0';

    shipmentList[3][0] = 'A bag of Scotts® Turf Builder® Lawn Food (5m)';
    shipmentList[3][1] = '\u00D7\u200A' '1';
    shipmentList[3][2] = '\u00D7\u200A' '0';

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
    profileScreen = ProfileScreen(driver);
    mySubscriptionScreen = MySubscriptionScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C90271: Seasonal Subscription without Addon',
      () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();
        await driver.requestData('trackAppState');

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
            '\$17.49', '\$49.99', '\$25.99', '17.49');

        //Select Seasonal Subscription option
        await deliveryScreen.selectSeasonalSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed(
            isAnnualSubscription: false);

        // Verify Seasonal Subscription
        await cartScreen.verifySeasonalSubscriptionIsDisplayed('17.49', 1);

        // Verify Addons
        await cartScreen.verifyAddonsCommonElementsAreDisplayed(
            addonsList.length,
            isAnnualSubscription: false);

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Verify Order Summary
        await cartScreen.verifyOrderSummary(
            false, '\$17.49', '', '\$17.49', 'FREE');

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
        await checkoutScreen.verifyOrderSummaryDetails(
            true, false, '\$17.49', '', '\$17.49', 'FREE', '\$1.32', '\$18.81');

        // Accept Subscription Confirmation Checkbox
        await checkoutScreen.acceptSubscriptionConfirmation();

        //here
        // Click on Place Order
        await checkoutScreen.clickOnPlaceOrder();

        // Verify Order Confirmation Screen
        await orderConfirmationScreen.verifyOrderConfirmationDetails();
        await orderConfirmationScreen.clickOnReturnHome();

        //Open profile screen
        await planScreen.clickOnProfileIcon();
        await sleep(Duration(seconds: 20));

        //Click on My Subscription
        await profileScreen.clickOnMySubscriptionAccount();

        // Verify My Subscription
        await mySubscriptionScreen.verifyMySubscriptionScreenIsDisplayed(
            true,
            false,
            subscriptionCardProductDetails,
            paymentDetails,
            shippingDetails,
            shipmentList);

        // Verify Email
        // TODO: Add email verification code using Google apis
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
