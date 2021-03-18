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
  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;
  var profileScreen;
  var mySubscriptionScreen;

  // Products data objects
  final subscriptionCardProductDetails =
  List.generate(5, (i) => List(8), growable: false);
  final addonsList = List.generate(9, (i) => List(2), growable: false);

    final size = '20000';
  final zip = '43203';
  final grass = 'Tall Fescue';
  final shipmentList = List.generate(6, (i) => List(3), growable: false);

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    subscriptionCardProductDetails[0][0] = 'Scotts® Turf Builder® Lawn Food';
    subscriptionCardProductDetails[0][1] = true;
    subscriptionCardProductDetails[0][2] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[0][3] = '15K sqft';
    subscriptionCardProductDetails[0][4] = '\$61.48';
    subscriptionCardProductDetails[0][5] = ['Feeds Grass','Promotes Root Development','Increases Water Absorption'];
    subscriptionCardProductDetails[0][6] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[0][7] = '5K sqft';

    subscriptionCardProductDetails[1][0] = "Scotts® Turf Builder® THICK'R Lawn™ Tall Fescue";
    subscriptionCardProductDetails[1][1] = false;
    subscriptionCardProductDetails[1][2] = '\u00D7\u200A' '5';
    subscriptionCardProductDetails[1][3] = '4K sqft';
    subscriptionCardProductDetails[1][4] = '\$257.45';
    subscriptionCardProductDetails[1][5] = ['Increases Thickness','Feeds Grass','Promotes Root Development'];
    subscriptionCardProductDetails[1][6] = null;
    subscriptionCardProductDetails[1][7] = null;

    subscriptionCardProductDetails[2][0] = 'Scotts® Turf Builder® SummerGuard® Lawn Food with Insect Control';
    subscriptionCardProductDetails[2][1] = false;
    subscriptionCardProductDetails[2][2] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[2][3] = '15K sqft';
    subscriptionCardProductDetails[2][4] = '\$97.98';
    subscriptionCardProductDetails[2][5] = ['Feeds Grass','Insect Control','Strengthens Against Heat'];
    subscriptionCardProductDetails[2][6] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[2][7] = '5K sqft';

    subscriptionCardProductDetails[3][0] = 'Scotts® Turf Builder® WinterGuard® Fall Weed & Feed₃';
    subscriptionCardProductDetails[3][1] = false;
    subscriptionCardProductDetails[3][2] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[3][3] = '15K sqft';
    subscriptionCardProductDetails[3][4] = '\$91.48';
    subscriptionCardProductDetails[3][5] = ['Feeds Grass','Kills Weeds','Recoup From Summer'];
    subscriptionCardProductDetails[3][6] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[3][7] = '5K sqft';

    subscriptionCardProductDetails[4][0] = 'Scotts® Turf Builder® WinterGuard® Fall Lawn Food';
    subscriptionCardProductDetails[4][1] = false;
    subscriptionCardProductDetails[4][2] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[4][3] = '15K sqft';
    subscriptionCardProductDetails[4][4] = '\$71.48';
    subscriptionCardProductDetails[4][5] = ['Feeds Grass','Promotes Root Development','Recoup From Summer'];
    subscriptionCardProductDetails[4][6] = '\u00D7\u200A' '1';
    subscriptionCardProductDetails[4][7] = '5K sqft';

    addonsList[0][0] = 'Scotts® Turf Builder® Edgeguard® Mini Broadcast Spreader';
    addonsList[0][1] = '\$36.99';
    addonsList[1][0] = 'Scotts® GrubEx® Season-Long Grub Killer (10m)';
    addonsList[1][1] = '\$95.98';
    addonsList[2][0] = 'Scotts® DiseaseEx™ Lawn Fungicide';
    addonsList[2][1] = '\$81.96';
    addonsList[3][0] = 'Scotts® MossEx®';
    addonsList[3][1] = '\$57.96';
    addonsList[4][0] = 'Scotts® Turf Builder® Edgeguard® DLX Broadcast Spreader';
    addonsList[4][1] = '\$59.99';
    addonsList[5][0] = 'Scotts EZ Seed Patch & Repair Tall Fescue Lawns';
    addonsList[5][1] = '\$16.49';
    addonsList[6][0] = 'Scotts EZ Seed Patch & Repair Sun & Shade';
    addonsList[6][1] = '\$16.49';
    addonsList[7][0] = 'Scotts EZ Seed Dog Spot Repair Sun & Shade';
    addonsList[7][1] = '\$13.49';
    addonsList[8][0] = 'Scotts EZ Seed Dog Spot Repair Tall Fescue';
    addonsList[8][1] = '\$13.49';

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
      'C90251: Add a One-Time Addon at Checkout',
          () async {
        // Create an account using an email
        await splashScreen.verifySplashScreenIsDisplayed();
        await welcomeScreen.verifyWelcomeScreenIsDisplayed();
        await welcomeScreen.clickOnGetStartedButton();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('brown');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('no_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('many_weeds');//passing weeds map key which present in lawn_condition_screen
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
        for (var productID = 0; productID < subscriptionCardProductDetails.length; productID++) {
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
        await deliveryScreen.verifySeasonalSubscriptionOption('\$61.48', '\$257.45', '\$97.98', '\$91.48', subscriptionCardProductDetails.length);


        // Select Seasonal Subscription
        await deliveryScreen.selectSeasonalSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed(
            isAnnualSubscription: false);

        // Verify Seasonal Subscription
        await cartScreen.verifySeasonalSubscriptionIsDisplayed('61.48', 5);

        // Verify Addons
        await cartScreen.verifyAddonsCommonElementsAreDisplayed(
            addonsList.length,
            isAnnualSubscription: false);

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        for (var addonID = 0; addonID < addonsList.length; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Add Addon to cart
        await cartScreen.addAddonToCart(4);

        // Verify Order Summary
        await cartScreen.verifyOrderSummary(
            false, '\$61.48', '-\$59.99', '\$121.47', 'FREE');

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
        await checkoutScreen.verifyOrderSummaryDetails(true, false, '\$61.48',
            '\$59.99', '\$121.47', 'FREE', '\$9.12', '\$130.59');

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

        await sleep(Duration(seconds: 30));

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed();

        // Open My Subscription
        await profileScreen.clickOnMySubscriptionAccount();

        // Verify My Subscription
        await mySubscriptionScreen.verifyMySubscriptionScreenIsDisplayed(
            true,
            false,
            subscriptionCardProductDetails,
            paymentDetails,
            shippingDetails,
            shipmentList);

        //verify addon product
        await mySubscriptionScreen.verifyProductInShipmentProductList(addonsList[4][0]);

      },
      timeout: Timeout(
        Duration(minutes: 20),
      ),
    );
  });
}