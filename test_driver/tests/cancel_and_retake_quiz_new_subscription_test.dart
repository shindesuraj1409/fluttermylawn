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
  var beforeYouCancelScreen;
  var whyAreYouCancellingScreen;
  var confirmCancelationScreen;
  var editLawnProfile;

  // Products data objects
  var recommendedProducts;
  var addonsList;

  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';

  final size2 = '100';
  final grass2 = 'Buffalo grass';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    // Retrieve products data using APIs
    recommendedProducts = GetRecommondedProducts();
    await recommendedProducts.setProductsData();
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
    beforeYouCancelScreen = BeforeYouCancelScreen(driver);
    whyAreYouCancellingScreen = WhyAreYouCancellingScreen(driver);
    confirmCancelationScreen = ConfirmCancellationScreen(driver);
    editLawnProfile = EditLawnProfile(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C85697: Retake the quiz and get a new subscription',
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

        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();

        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size);
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.selectGrassType(grass);

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

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // Select Seasonal Subscription
        await deliveryScreen.selectSeasonalSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Add Addon to cart
        await cartScreen.addAddonToCart(4);

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
        await sleep(Duration(seconds: 30));
      },
      timeout: Timeout(
        Duration(minutes: 7),
      ),
    );

    test(
      'canceling the Seasonal subscription',
      () async {
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
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'retaking the quiz',
      () async {
        // Open My Subscription
        await profileScreen.clickOnEditButton();
        await profileScreen.verifyEditProfileBottomSheet();
        await profileScreen.clickOnEditAnywayButton();

        // click for retaking the quiz
        await editLawnProfile.clickOnRetakeLawnQuiz();

        // Complete quiz
        await lawnConditionsScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionsScreen.setColorSliderValue('brown');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionsScreen.setThicknessSliderValue('thin_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionsScreen.setWeedsSliderValue('many_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionsScreen.clickOnSaveButton();

        await spreaderTypesScreen.selectSpreader('no');

        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();

        await manualEntryScreen.setZipCodeAndLawnSizeData(zip, size2);
        await manualEntryScreen.clickOnContinueButton();

        await grassTypesScreen.selectGrassType(grass2);

        await locationSharingScreen.clickOnNotNow();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'completing the checkout process',
      () async {
        // Verify Lawn Profile screen
        await editLawnProfile.verifyEditProfileIsDisplayed(false);
        await editLawnProfile.clickOnCloseIcon();
        await profileScreen.clickOnBackButton();

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // Select Seasonal Subscription
        await deliveryScreen.selectAnnualSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        for (var addonID = 0; addonID < 5; addonID++) {
          await cartScreen.verifyAddonsDetails(addonsList, addonID);
        }

        // Add Addon to cart
        await cartScreen.addAddonToCart(4);

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
        Duration(minutes: 10),
      ),
    );

    test(
      'verifing the new subscription',
      () async {
        await planScreen.waitForPlanScreenLoading();
        await planScreen.clickOnProfileIcon();

        // Open My Subscription
        await profileScreen.verifyProfileScreenIsDisplayed();
        await profileScreen.clickOnMySubscriptionAccount();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );
  });
}
