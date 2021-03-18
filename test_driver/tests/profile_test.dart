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
  var profileScreen;
  var deliveryScreen;
  var cartScreen;
  var checkoutScreen;
  var orderConfirmationScreen;
  var editLawnProfileScreen;
  var mySubscriptionScreen;
  var appSettingScreen;
  var myScottsAccountScreen;

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
    editLawnProfileScreen = EditLawnProfile(driver);
    mySubscriptionScreen = MySubscriptionScreen(driver);
    appSettingScreen = AppSettingScreen(driver);
    myScottsAccountScreen = MyScottsAccountScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  Future<void> completeQuiz() async {
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
  }

  group('description', () {
    test(
      'Navigates to Profile screen',
      () async {
        await completeQuiz();

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

        // Navigate to profile
        await planScreen.clickOnProfileIcon();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69402: Get Your Lawn Plan for non-subscribed user',
      () async {
        await profileScreen.clickOnGetProductsDeliveredBloc();

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
        await deliveryScreen.clickOnbillingAndShipping();
        await deliveryScreen.clickOnCloseIcon();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69398: App Settings (all user type)',
      () async {
        await profileScreen.clickOnAppSettingsButton();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
        sleep(Duration(seconds: 2));
        await appSettingScreen.goToBack();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69399: My Scotts Account for logged in user',
      () async {
        await profileScreen.clickOnMyScottsAccount();

        // verify my scotts account screen
        await myScottsAccountScreen.verifyMyScottsAccountScreenIsDisplayed();
        sleep(Duration(seconds: 2));
        await myScottsAccountScreen.goToBack();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69393: Back navigation on Edit confirmation screen',
      () async {
        await profileScreen.goToBack();

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
        await sleep(Duration(seconds: 2));

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

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed();

        //Click on Edit link on profile screen
        await profileScreen.clickOnEditButton();
        await sleep(Duration(seconds: 2));

        //verify alert all elements
        await profileScreen.verifyEditProfileBottomSheet();

        await profileScreen.clickOnCancelButton();
        await profileScreen.verifyEditProfileBottomSheetIsDismissed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

    test(
      'C69392: Navigates to Profile screen',
      () async {
        //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69390: Show selected answers on profile',
      () async {
        // verify selected answers are shown
        await profileScreen.verifySelectedAnswerOnProfile(size, zip, grass,
            'Spreader type: None', 'Some Grass', 'Mostly Green', 'No Weeds');
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69391: Edit Profile',
      () async {
        //Click on Edit link on profile screen
        await profileScreen.clickOnEditButton();
        //verify alert all elements
        await profileScreen.verifyEditProfileBottomSheet();
        //click on Edit AnyWay button
        await profileScreen.clickOnEditAnywayButton();
        //verify Edit Lawn Profile
        await editLawnProfileScreen.verifyEditProfileIsDisplayed(true);
        sleep(Duration(seconds: 2));
        await editLawnProfileScreen.clickOnCloseIcon();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69389: My Subscription for subscribed user',
      () async {
        await sleep(const Duration(seconds: 30));
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

        await mySubscriptionScreen.goToProfileScreen();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69403: Back navigation on profile',
      () async {
        await profileScreen.goToBack();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayedAfterLogIn();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C69401: Get Your Lawn Plan for guest user',
      () async {
        // logout
        await planScreen.clickOnProfileIcon();
        await profileScreen.clickOnMyScottsAccount();
        await myScottsAccountScreen.clickOnLogoutButton();
        await myScottsAccountScreen.verifyLogoutDrawerIsDisplayed();
        await myScottsAccountScreen.clickOnDrawerLogoutButton();

        await completeQuiz();

        // Sign up user
        await signUpScreen.waitForSignUpScreenLoading();
        await signUpScreen.clickOnContinueWithGuestButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();
        await planScreen.clickOnProfileIcon();

        // //verify profile screen elements
        await profileScreen.verifyProfileScreenIsDisplayed(isGuest: true);

        await profileScreen.clickOnGetProductsDeliveredBloc();

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
        await deliveryScreen.clickOnbillingAndShipping();
        await deliveryScreen.clickOnCloseIcon();
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );
  });
}
