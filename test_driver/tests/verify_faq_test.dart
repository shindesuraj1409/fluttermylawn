import 'dart:io' hide Platform;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';
import '../test_data/payment_details.dart';
import '../test_data/shipping_details.dart';

void main() async {
  FlutterDriver driver;

  // Screens objects
  var baseScreen;
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
  var faqScreen;

  final size = '25';
  final zip = '43203';
//  final unit = 'sqft';  TODO: Rich text, not able to find
  final grass = 'Bermuda';

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    baseScreen = BaseScreen(driver);
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
    faqScreen = FAQScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C85700: verify the behaviour of FAQ',
      () async {
        // Create an account using an email
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

        await grassTypesScreen.verifyGrassTypesScreenIsDisplayed();
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
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();

        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // verify annual subscription
        await deliveryScreen.verifyAnnualSubscriptionOption(
            '\$110.96', '\$99.86');

        // Select Annual Subscription
        await deliveryScreen.selectAnnualSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        await cartScreen.scrollAddonInView();

        // Proceed to Checkout
        await cartScreen.clickOnCheckout();

        // Fill Shipping details
        await checkoutScreen.fillCheckoutShippingDetails(true, shippingDetails);
        await checkoutScreen.clickContinueToPayment();

        await checkoutScreen.fillPaymentDetails(true, paymentDetails);
        await checkoutScreen.clickOnContinueToOrderSummary();

        // Accept Subscription Confirmation Checkbox
        await checkoutScreen.acceptSubscriptionConfirmation();

        //here
        // Click on Place Order
        await checkoutScreen.clickOnPlaceOrder();

        await orderConfirmationScreen.clickOnReturnHome();
      },
      timeout: Timeout(
        Duration(minutes: 7),
      ),
    );

    test(
      'navigate to faq',
      () async {
        await planScreen.waitForPlanScreenLoading();
        await planScreen.clickOnProfileIcon();

        await profileScreen.clickOnMySubscriptionAccount();
        await mySubscriptionScreen.scrollTillEnd();
        await mySubscriptionScreen.clickOnFAQ();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    /// This is a failing test. Uncomment to run it
    // test('test should fail if the text is not available in the list', () async {
    //   await faqScreen.clickOnFailingString();
    // });

    test(
      'check the subscription faq list',
      () async {
        await faqScreen.clickOnSubscription();
        await faqScreen.clickOnSubscriptionFAQListViewItem();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'click on billing and shipping and expend the list',
      () async {
        await faqScreen.clickOnbillingAndShipping();
        await faqScreen.verifyBillingAndShippingList();
        await faqScreen.clickOnBillingAndShippingFAQListItem();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
