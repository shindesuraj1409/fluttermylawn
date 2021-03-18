import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';
import '../test_data/skip_shipment_reasons.dart';
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
  var editLawnProfileScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;
  var addonsList;

  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';
  final shipmentList = List.generate(5, (i) => List(3), growable: false);
  final tax = 7.5;
  final annualDiscount = 10;

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
    profileScreen = ProfileScreen(driver);
    mySubscriptionScreen = MySubscriptionScreen(driver);
    editLawnProfileScreen = EditLawnProfile(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C82678: Annual Subscriber Skips',
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

        // Verify Annual Subscription option
        await deliveryScreen.verifyAnnualSubscriptionOption(
            '\$110.96', '\$99.86');

        // Verify Seasonal Subscription option
        await deliveryScreen.verifySeasonalSubscriptionOption('', '', '', '');

        // Select Annual Subscription
        await deliveryScreen.selectAnnualSubscriptionOption();

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
        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Add Addon to cart
        await cartScreen.addAddonToCart(4);

        // Verify Order Summary
        await cartScreen.verifyOrderSummary(
            true, '\$110.96', '-\$11.10', '\$159.85', 'FREE');

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
        await checkoutScreen.verifyOrderSummaryDetails(true, true, '\$110.96',
            '-\$11.10', '\$159.85', 'FREE', '\$11.98', '\$171.83');

        // Verify Addon in Checkout Order Summary
        await checkoutScreen.verifyAddonInOrderSummary(
            addonsList[4][0], addonsList[4][1]);

        // Accept Subscription Confirmation Checkbox
        await checkoutScreen.acceptSubscriptionConfirmation();

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
            true,
            subscriptionCardProductDetails,
            paymentDetails,
            shippingDetails,
            shipmentList);
        //click on Skip Shipment link
        final productName = await mySubscriptionScreen.clickOnSkipShipment();

        //Verify Reason for Skipping Shipment screen
        await mySubscriptionScreen
            .verifyElementsOnSkipShipmentScreen(skipShipmentReasons);

        //Selecting reason for skipping Shipment
        await mySubscriptionScreen.clickOnSkipShipmentReason(
            'reason_1', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason(
            'reason_2', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason(
            'reason_3', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason(
            'reason_4', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason(
            'reason_5', skipShipmentReasons);

        //Submit Reason(s) and confirm Skip Shipment
        await mySubscriptionScreen.clickOnSubmitButton();

        //verify skip shipment Processing label
        await mySubscriptionScreen.verifySkipShipmentProcessingLabel();

        await sleep(Duration(seconds: 3));

        //Verify ship Skipped screen
        await mySubscriptionScreen.verifyShipmentSkippedScreenElements();
        final refundAmt = '\$' +
            (await mySubscriptionScreen.getCalculatedRefundAmount(
                    true,
                    subscriptionCardProductDetails,
                    addonsList,
                    productName,
                    tax,
                    annualDiscount))
                .toString();
        await expect(await mySubscriptionScreen.getShipmentSkippedSubtitle(),
            contains(refundAmt));
        await mySubscriptionScreen.clickOnCloseIcon();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'C82684: I have Moved',
      () async {
        //Go back to Profile screen
        await mySubscriptionScreen.goToProfileScreen();

        //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed();

        //Click on Edit link on profile screen
        await profileScreen.clickOnEditButton();

        await sleep(Duration(seconds: 2));
        //verify alert all elements
        await profileScreen.verifyEditProfileBottomSheet();
        //click on Edit AnyWay button
        await profileScreen.clickOnEditAnywayButton();
        //verify Edit Lawn Profile
        await editLawnProfileScreen.verifyEditProfileIsDisplayed(true);
        //click on Lawn Address
        await editLawnProfileScreen
            .clickOnEditLawnProfileSections('LawnAddress', true);

        //verify Alert Elements
        await editLawnProfileScreen.verifyLawnAddressDialogElements();

        //click on Got It button
        await editLawnProfileScreen.clickOnGotItButton();

        //verify if modal is dismissed
        await editLawnProfileScreen.verifyLawnAddressModalIsDismissed();

        //verify Edit Lawn Profile
        await editLawnProfileScreen.verifyEditProfileIsDisplayed(true);
        //click on Lawn Address
        await editLawnProfileScreen
            .clickOnEditLawnProfileSections('LawnAddress', true);

        //Click on I Have Moved button
        await editLawnProfileScreen.clickOnIHaveMovedButton();

        //verify just moved alert
        await editLawnProfileScreen.verifyJustMovedDialogElements();

        //click on retake quiz
        await editLawnProfileScreen.clickOnRetakeQuizButton();

        //Verify lawn condition screen
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
