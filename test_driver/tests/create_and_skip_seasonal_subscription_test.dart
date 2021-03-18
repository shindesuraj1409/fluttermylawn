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
      'C90266: Create and Skip Seasonal Subscription',
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

        await signUpScreen.clickOnContinueWithGuestButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // TODO: Skipped the last two products verification on plan screen due to issue: https://scotts.jira.com/browse/CORE-1841
        // Verify subscription card details
        for (var productID = 0; productID < 4; productID++) {
          if(productID == 2){continue;}
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

        // Select Seasonal Subscription
        await deliveryScreen.selectSeasonalSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        //verify signUp bottom sheet elements
        await welcomeScreen.verifyLoginBottomSheetIsDisplayed();

        //click on continue with email button
        welcomeScreen.clickOnContinueWithEmailButton();
        // Sign up user
        email = 'automation.mylawn+' +
            await baseScreen.getFormattedTimeStamp() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();


        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed(isAnnualSubscription: false);

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
        //click on Skip Shipment link
        final productName = await mySubscriptionScreen.clickOnSkipShipment();

        //Verify Reason for Skipping Shipment screen
        await mySubscriptionScreen.verifyElementsOnSkipShipmentScreen(skipShipmentReasons);

        //Selecting reason for skipping Shipment
        await mySubscriptionScreen.clickOnSkipShipmentReason('reason_1', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason('reason_2', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason('reason_3', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason('reason_4', skipShipmentReasons);
        await mySubscriptionScreen.clickOnSkipShipmentReason('reason_5', skipShipmentReasons);

        //Submit Reason(s) and confirm Skip Shipment
        await mySubscriptionScreen.clickOnSubmitButton();

        await sleep(Duration(seconds: 3));

        //Verify ship Skipped screen
        await mySubscriptionScreen.verifyShipmentSkippedScreenElements();
        await expect(await mySubscriptionScreen.getShipmentSkippedSubtitle(),
            contains('You won’t be billed for this shipment.'));
        await mySubscriptionScreen.clickOnCloseIcon();
        //verify shipment skipped text for product on my subscription screen
        await mySubscriptionScreen.verifyProductShipmentSkippedText(productName);


      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
