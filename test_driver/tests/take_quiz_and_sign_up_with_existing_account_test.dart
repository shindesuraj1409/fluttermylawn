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
  var signUpScreen;
  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;
  var profileScreen;
  var mySubscriptionScreen;
  var loginScreen;
  var beforeYouCancelScreen;
  var whyAreYouCancellingScreen;
  var confirmCancelationScreen;

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
    subscriptionCardProductDetails = recommendedProducts.subscriptionCardProductDetails;
    addonsList = recommendedProducts.addonsList;

    await sleep(Duration(seconds: 1));
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
    loginScreen = LoginScreen(driver);
    beforeYouCancelScreen = BeforeYouCancelScreen(driver);
    whyAreYouCancellingScreen = WhyAreYouCancellingScreen(driver);
    confirmCancelationScreen = ConfirmCancellationScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C64542: Take the Quiz and Sign Up with an Existing Account',
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
        await createAccountScreen.enterEmail('automation.mylawn+2021_02_10_13_39_27_842905@gmail.com');
        await createAccountScreen.clickOnContinueButton();
        await loginScreen.verifyWelcomeBackScreenIsDisplayed();
        await loginScreen.enterPassword('Pass123!@#');
        await loginScreen.clickOnLoginButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();

        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }

        // if user don't have subscription then it will take subscription first
        if (await planScreen.verifySubscribeNowIsPresent()) {
          // Subscribe
          await planScreen.clickOnSubscribeNow();

          // Verify Delivery screen
          await deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

          // Verify product details in carousal section
          for (var productID = 0; productID < 4; productID++) {
            await deliveryScreen.verifyProductCardDetails(
                subscriptionCardProductDetails, productID);
          }

          // Verify Annual Subscription option
          await deliveryScreen.verifyAnnualSubscriptionOption(
              '\$110.96', '\$99.86');

          // Verify Seasonal Subscription option
          await deliveryScreen.verifySeasonalSubscriptionOption('', '', '', '');

          // Click on continue
          await deliveryScreen.clickOnContinueButton();

          // Verify Cart Screen
          await cartScreen.verifyCartScreenIsDisplayed();

          // Verify Annual Subscription
          await cartScreen.verifyAnnualSubscriptionIsDisplayed(
              '\$110.96', '99.86', 4);

          // Verify Addons
          await cartScreen
              .verifyAddonsCommonElementsAreDisplayed(addonsList.length);

          // Verify addons detail
          await cartScreen.scrollAddonInView();
          await sleep(Duration(seconds: 2));

          for (var addonID = 0; addonID < 5; addonID++) {
            await cartScreen.verifyAddonsDetails(addonsList, addonID);
          }

          // Verify Order Summary
          await cartScreen.verifyOrderSummary(
              true, '\$110.96', '-\$11.10', '\$99.86', 'FREE');

          // Proceed to Checkout
          await cartScreen.clickOnCheckout();

          // Verify Checkout screen
          await checkoutScreen.verifyCheckoutShippingElementsAreDisplayed(true);

          // Fill Shipping details
          await checkoutScreen.fillCheckoutShippingDetails(
              true, shippingDetails);
          await checkoutScreen.clickContinueToPayment();

          // Verify Payment Details
          await checkoutScreen.verifyPaymentDetails(true);
          await checkoutScreen.fillPaymentDetails(true, paymentDetails);
          await checkoutScreen.clickOnContinueToOrderSummary();

          // Verify Checkout Order Summary Details
          await checkoutScreen.verifyOrderSummaryDetails(true, true, '\$110.96',
              '-\$11.10', '\$99.86', 'FREE', '\$7.48', '\$107.34');

          // Accept Subscription Confirmation Checkbox
          await checkoutScreen.acceptSubscriptionConfirmation();

          //here
          // Click on Place Order
          await checkoutScreen.clickOnPlaceOrder();

          // Verify Order Confirmation Screen
          await orderConfirmationScreen.verifyOrderConfirmationDetails();
          await orderConfirmationScreen.clickOnReturnHome();
          await sleep(Duration(seconds: 30));
        }

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        await profileScreen.clickOnMySubscriptionAccount();

        // Click on Cancel Subscription
        await mySubscriptionScreen.clickOnCancelSubscriptionButton();

        // Before You Cancel
        await beforeYouCancelScreen.verifyBeforeYouCancelScreenIsDisplayed();
        await beforeYouCancelScreen.clickOnContinueButton();

        // Why Are you Cancelling Screen
        await whyAreYouCancellingScreen
            .verifyWhyAreYouCancellingScreenIsDisplayed();
        await whyAreYouCancellingScreen.selectCancelationOption('price');
        await whyAreYouCancellingScreen.selectCancelationOption('shipping');
        await whyAreYouCancellingScreen.selectCancelationOption('quality');
        await whyAreYouCancellingScreen.selectCancelationOption('moved');
        await whyAreYouCancellingScreen.selectCancelationOption('prefer_store');
        await whyAreYouCancellingScreen.selectCancelationOption('lawn_service');
        await whyAreYouCancellingScreen
            .selectCancelationOption('leftover_product');
        await whyAreYouCancellingScreen.selectCancelationOption('app_issue');
        await whyAreYouCancellingScreen.selectCancelationOption('other');
        await whyAreYouCancellingScreen.clickOnContinueButton();

        await sleep(Duration(seconds: 3));
        await confirmCancelationScreen.clickOnContinueButton();
        await mySubscriptionScreen.goToBack();
        await profileScreen.goToBack();

        // Subscribe
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
        await planScreen.clickOnSubscribeNow();

        // Verify Delivery screen
        await deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

        for (var productID = 0; productID < 4; productID++) {
          await deliveryScreen.verifyProductCardDetails(
              subscriptionCardProductDetails, productID);
        }

        // Verify Annual Subscription option
        await deliveryScreen.verifyAnnualSubscriptionOption(
            '\$110.96', '\$99.86');

        // Verify Seasonal Subscription option
        await deliveryScreen.verifySeasonalSubscriptionOption('', '', '', '');

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed();

        // Verify Annual Subscription
        await cartScreen.verifyAnnualSubscriptionIsDisplayed(
            '\$110.96', '99.86', 4);

        // Verify Addons
        await cartScreen
            .verifyAddonsCommonElementsAreDisplayed(addonsList.length);

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        await sleep(Duration(seconds: 2));

        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Verify Order Summary
        await cartScreen.verifyOrderSummary(
            true, '\$110.96', '-\$11.10', '\$99.86', 'FREE');

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
        await checkoutScreen.verifyOrderSummaryDetails(true, true, '\$110.96',
            '-\$11.10', '\$99.86', 'FREE', '\$7.48', '\$107.34');

        // Accept Subscription Confirmation Checkbox
        await checkoutScreen.acceptSubscriptionConfirmation();

        //here
        // Click on Place Order
        await checkoutScreen.clickOnPlaceOrder();

        // Verify Order Confirmation Screen
        await orderConfirmationScreen.verifyOrderConfirmationDetails();
        await orderConfirmationScreen.clickOnReturnHome();
        await sleep(Duration(seconds: 30));

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        // Open My Subscription
        await profileScreen.clickOnMySubscriptionAccount();

        // Verify My Subscription
        await mySubscriptionScreen.verifyMySubscriptionScreenIsDisplayed(
            true,
            true,
            subscriptionCardProductDetails,
            paymentDetails,
            shippingDetails,
            shipmentList);
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
