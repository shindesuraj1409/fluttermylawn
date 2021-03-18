import 'dart:io' hide Platform;
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../screens/screens.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';
import '../utils/getRecommondedProducts.dart';

void main() {
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
  var signUpScreen;

  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;
  var productDetailsScreen;
  var profileScreen;
  var myScottsAccountScreen;

  // Products data objects
  var recommendedProducts;
  var subscriptionCardProductDetails;

  var email;
  final size = '25';
  final zip = '43203';
  final grass = 'Bermuda';
  final lawn_name = 'Lawn';

  // Connect to the Flutter driver before running any tests
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
    deliveryScreen = DeliveryScreen(driver);
    cartScreen = CartScreen(driver);
    checkoutScreen = CheckoutScreen(driver);
    orderConfirmationScreen = OrderConfirmationScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
    profileScreen = ProfileScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    await driver?.close();
  });
  group('discription', () {
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
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test('C71793: Home screen - Remind Me Next Year', () async {
      // Verify My Plan screen
      await planScreen.waitForPlanScreenLoading();
      await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

      await planScreen.verifySubscribeNow();
      await planScreen.clickOnRemindMeNextYear();
      await planScreen.verifySmallCardOfLearnMore();

      await planScreen.verifyPlanScreenCommonElementsAreDisplayedAfterLogIn();
    });

    test('logout user', () async {
      await planScreen.clickOnProfileIcon();
      await profileScreen.clickOnMyScottsAccount();
      await myScottsAccountScreen.clickOnLogoutButton();
      await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
      await myScottsAccountScreen.clickOnDrawerLogoutButton();
    });

    test(
      'complete the process till the plan screen',
      () async {
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
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
    test(
      'C70203: Cancel Lawn name change',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // click on My Lawn text
        await planScreen.clickOnScreenHeader();
        await planScreen.verifyLawnNameChangedBottomSheet();

        // click on cancel button to dismiss the bottom sheet
        await planScreen.clickOnCancelButtonOfLanwName();

        await planScreen.verifyLawnNameChangedBottomSheetIsDissmissed();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C70202: Change Lawn Name',
      () async {
        // click on My Lawn text
        await planScreen.clickOnScreenHeader();
        await planScreen.verifyLawnNameChangedBottomSheet();

        // change the lawn name
        await planScreen.changeLawnName(lawn_name);

        await planScreen.clickOnSaveButtonOfLawnName();
        await planScreen.verifyLawnNameChangedBottomSheetIsDissmissed();
        await planScreen.verifyLawnNameIsChanged();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C71778: Product recommendation covers 12 months ',
      () async {
        await planScreen.verify12MonthsDifference();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C71782: Arrow icon on collapsed card',
      () async {
        for (var productID = 0; productID < 4; productID++) {
          await planScreen.verifyProductElementsAreDisplayed(
              subscriptionCardProductDetails, productID);
        }
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C70201: Home screen - Subscribe Now',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();

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
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C71779: Active application window - Unsubscribed',
      () async {
        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify addons detail
        await cartScreen.scrollAddonInView();

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

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayedAfterLogIn();

        // verify product details
        await planScreen.verifyActiveApplicationWindowProduct();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C71777: Home screen without Subscription Card',
      () async {
        // subscibe now button is not displayed
        await planScreen.subscribedNowIsNotDisplayed();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test(
      'C71783: View Details on Product card',
      () async {
        // click on first product
        await planScreen.clickOnFirstViewDetail();

        // verify PDP
        await productDetailsScreen.verifyLabels();

        sleep(Duration(seconds: 1));

        // go back to plan screen
        await productDetailsScreen.goToPlanScreen();

        // click on second product
        await planScreen.clickOnSecondViewDetails();

        // verify PDP
        await productDetailsScreen.verifyLabels();

        sleep(Duration(seconds: 1));

        // go back to plan screen
        await productDetailsScreen.goToPlanScreen();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );
  });
}
