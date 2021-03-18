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

  var mainProductListingScreen;
  var productDetailsScreen;
  var deliveryScreen;
  var cartScreen;
  var storeLocator;
  var checkoutScreen;
  var orderConfirmationScreen;
  var addProductScreen;
  var productListingScreen;

  final size = '25';
  final zip = '14420';
  final grass = 'Fine Fescue';
  final zipCode = '43203';
  final futureDate = DateTime.now().add(Duration(days: 20));
  final product = 'Scotts® Turf Builder® Weed & Feed₃';
  final store_list = ['Schreiner Ace Hardware', 'Lowe\'s Inc', 'Wal-Mart'];

  // Update shipping details for 14420 zipcode
  shippingDetails['shipping_zip_code'] = zip;
  shippingDetails['shipping_street_address'] = '6265 Brockport Spencerport Rd';
  shippingDetails['shipping_city'] = 'Brockport';
  shippingDetails['shipping_state'] = 'NY';

  final store_list_after_zip_code_change = [
    'Lowe\'s Inc',
    'Wal-Mart',
    'Crocker\'s Ace Hardware'
  ];

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );
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
    mainProductListingScreen = MainProductListingScreen(driver);
    productDetailsScreen = ProductDetailsScreen(driver);
    storeLocator = StoreLocator(driver);
    deliveryScreen = DeliveryScreen(driver);
    cartScreen = CartScreen(driver);
    checkoutScreen = CheckoutScreen(driver);
    orderConfirmationScreen = OrderConfirmationScreen(driver);
    addProductScreen = AddProductScreen(driver);
    productListingScreen = ProductListingScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  group('description', () {
    test(
      'C79610: Verifying cancel button in the remove a product bottom sheet. Includes process till plan screen',
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

        await planScreen.clickOnSecondViewDetails();
        await productDetailsScreen.clickOnInfoMore();
        await productDetailsScreen.verifyBottomSheet();
        await productDetailsScreen.clickOnBackButtonOfRemoveProduct();
        await productDetailsScreen.verifyBottomSheetIsDissmissed();

        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 7),
      ),
    );

    test('C79423: Remove a product from the plan', () async {
      sleep(Duration(seconds: 4));
      await productDetailsScreen.clickOnInfoMore();
      await productDetailsScreen.verifyBottomSheet();
      await productDetailsScreen.clickOnRemoveProduct();
      await productDetailsScreen.verifyProductRemovedSuccessfully();
      await productDetailsScreen
          .clickOnCancelButtonOfProductRemovedBottomSheet();

      // Go to Plan screen
      await productDetailsScreen.goToPlanScreen();
    });

    test(
      'Go to PDP screen of a product which is not recommended',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // click on floating action button
        await planScreen.clickOnFloatingActionButton();

        await sleep(Duration(seconds: 2));

        // click on product
        await planScreen.clickOnProductButton();

        await mainProductListingScreen.clickOnLawnFood();
        await sleep(Duration(seconds: 5));
        await productListingScreen.clickOnProductUsingName(product);
        await sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C79606: Verifying info icon on coverage calculator and taping to open bottom sheet',
      () async {
        // click on info icon of product detail
        await productDetailsScreen.clickOnInfoIconProductDetail();

        // verify bottom sheet and click on got it button
        await productDetailsScreen.verifyBottomSheetOfCoverage();
        sleep(Duration(seconds: 2));
        await productDetailsScreen.clickOnGotItButtonProductDetail();
        sleep(Duration(seconds: 2));

        // verify bottom sheet is dissmissed and click on got it button
        await productDetailsScreen.verifyBottomSheetOfCoverageIsDissmissed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C79613: Verifying calculation of coverage area',
      () async {
        // verify zero sqft coverage
        await productDetailsScreen.verifyCoverageZero();

        await productDetailsScreen.clickOnAddIcon();
        sleep(Duration(seconds: 2));

        // verify zero to 5000 coverage
        await productDetailsScreen.verifyCoverageIncrement('5000');
        sleep(Duration(seconds: 2));

        await productDetailsScreen.clickOnSecondAddIcon();
        sleep(Duration(seconds: 2));

        // verify 5000 to 20000 coverage
        await productDetailsScreen.verifyCoverageIncrement('20000');
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C79609: Tap no quibble guarantee',
      () async {
        // click on no quibble guarantee text
        await productDetailsScreen.clickOnNoQuibbleGuarantee();

        // verify the bottom sheet after pressing no quibble guarantee text
        await productDetailsScreen.verifyBottomSheetOfNoQuibbleGuarantee();
        sleep(Duration(seconds: 2));

        // click to got it button which is there in the bottom sheet
        await productDetailsScreen.clickOnGotItOfNoQuibbleGuarantee();
        sleep(Duration(seconds: 2));

        // verify the bottom sheet is dissmissed after pressing no quibble guarantee text
        await productDetailsScreen
            .verifyBottomSheetOfNoQuibbleGuaranteeIsDissmissed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C79607: Verifying buy now button to open bottom sheet and cancelling to close bottom sheet',
      () async {
        // click on buy now button
        await productDetailsScreen.clickOnBuyNow();

        // verify bottom sheet after pressing buy now button
        await productDetailsScreen.verifyBottomSheetOfBuyNow();
        sleep(Duration(seconds: 2));

        // click on cancel button
        await productDetailsScreen.clickOnCancelButton();
        sleep(Duration(seconds: 2));

        // verify bottom sheet is dissmissed after pressing buy now button
        await productDetailsScreen.verifyBottomSheetIsDissmissed();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C84463: Store Locator',
      () async {
        // click on buy now button
        await productDetailsScreen.clickOnBuyNow();
        await productDetailsScreen.clickOnFindLocalStore();

        // verify store locator
        await storeLocator.verifyStoreList(store_list_after_zip_code_change);

        await storeLocator.enterZipCode(zipCode);

        await storeLocator.verifyStoreLocatorScreenIsDisplayed(store_list);
        sleep(Duration(seconds: 2));

        // verify direction and phone icon
        await storeLocator.verifyDirectionIcon();
        await storeLocator.verifyPhoneIcon();

        // verify phone dialogue after pressing phone icon
        if (await driver.requestData('get_os') == 'ios') {
          await storeLocator.clickOnPhoneIcon();
          await storeLocator.verifyPhoneDialogue();
          await storeLocator.clickOnCancelButton();
        }

        await storeLocator.clickOnMap();
        sleep(Duration(seconds: 2));

        await storeLocator.goToBack();
        sleep(Duration(seconds: 2));
      },
      timeout: Timeout(
        Duration(
          minutes: 5,
        ),
      ),
    );

    test('C79604: Tap to use this product', () async {
      // click on use this product button
      await productDetailsScreen.clickOnUseThisProduct();

      // verify add product screen
      await addProductScreen.verifyAddProductScreen(product);
      await productDetailsScreen.selectDateForWhenField(
          day: futureDate.day,
          year: futureDate.year,
          month: futureDate.month);
      await productDetailsScreen.clickOnSaveButton();

      // Verify My Plan screen
      await planScreen.waitForPlanScreenLoading();
      await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

      // verify the product is there in Plan screen
      await planScreen.verifyAddedByMe(futureDate, product);
    },timeout: Timeout(
      Duration(
      minutes: 5,
    ),
    ),);

    test(
      'Process of subscription',
      () async {
        await planScreen.verifyPlanScreenCommonElementsAreDisplayed();

        // Subscribe
        await planScreen.clickOnSubscribeNow();

        // Verify Delivery screen
        await deliveryScreen.verifyDeliveryScreenCommonElementsAreDisplayed();

        // Select Annual Subscription
        await deliveryScreen.selectAnnualSubscriptionOption();

        // Click on continue
        await deliveryScreen.clickOnContinueButton();

        // Verify Cart Screen
        await cartScreen.verifyCartScreenIsDisplayed();

        // Verify addons detail
        await cartScreen.scrollAddonInView();
        await sleep(Duration(seconds: 2));

        // Proceed to Checkout
        await cartScreen.clickOnCheckout();

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
        Duration(minutes: 7),
      ),
    );

    test(
      'C77461: How to apply',
      () async {
        // Verify My Plan screen
        await planScreen.waitForPlanScreenLoading();
        await planScreen.verifyPlanScreeIsDisplayed();
        await planScreen.clickOnViewDetails();

        await productDetailsScreen.waitForProudctDetailScreenLoading();

        await productDetailsScreen.clickOnHowToApply();
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );

    test(
      'C77462: Play the video',
      () async {
        // verify the video url
        await productDetailsScreen.verifyYouTubeUrl();
        sleep(Duration(seconds: 5));

        // play the video
        await productDetailsScreen.playYouTubeUrl();
        sleep(Duration(seconds: 10));
      },
      timeout: Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
