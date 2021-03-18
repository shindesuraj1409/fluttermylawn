import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../screens/screens.dart';

void main() {
  FlutterDriver driver;

  // Screen objects
  var splashScreen;
  var welcomeScreen;
  var lawnConditionScreen;
  var appSettingScreen;
  var profileScreen;
  var aboutMyLawnAppScreen;
  var conditionOfUseScreen;
  var privacyNoticeScreen;
  var appFeedBackScreen;
  var positiveFeedbackScreen;
  var negativeFeedbackScreen;
  var spreaderTypesScreen;
  var lawnSizeScreen;
  var manualEntryScreen;
  var grassTypeScreen;

  var lawnTracingScreen;
  var signUpScreen;
  var planScreen;
  var homeScreen;
  var createAccountScreen;
  var email;

  // Connect to the Flutter driver before running any tests
  setUpAll(() async {
    driver = await FlutterDriver.connect(
      printCommunication: true,
    );

    await sleep(Duration(seconds: 1));
    splashScreen = SplashScreen(driver);
    welcomeScreen = WelcomeScreen(driver);
    lawnConditionScreen = LawnConditionScreen(driver);
    profileScreen = ProfileScreen(driver);
    aboutMyLawnAppScreen = AboutMyLawnAppScreen(driver);
    conditionOfUseScreen = ConditionOfUseScreen(driver);
    privacyNoticeScreen = PrivacyNoticeScreen(driver);
    appFeedBackScreen = AppFeedBackScreen(driver);
    positiveFeedbackScreen = PositiveFeedbackScreen(driver);
    negativeFeedbackScreen = NegativeFeedbackScreen(driver);
    spreaderTypesScreen = SpreaderTypesScreen(driver);
    lawnSizeScreen = LawnSizeScreen(driver);
    manualEntryScreen = ManualEntryScreen(driver);
    grassTypeScreen = GrassTypesScreen(driver);
    signUpScreen = SignUpScreen(driver);
    planScreen = PlanScreen(driver);
    homeScreen = HomeScreen(driver);
    lawnTracingScreen = LawnTracingScreen(driver);
    profileScreen = ProfileScreen(driver);
    appSettingScreen = AppSettingScreen(driver);
    createAccountScreen = CreateAccountScreen(driver);
  });

  // Close the connection to the driver after the tests have completed
  tearDownAll(() async {
    await driver?.close();
  });

  group('App Setting screen Tests', () {
    test(
      'complete the process till the plan screen and navigate to app setting screen',
      () async {
        //Quiz
        // Verify "Splash Screen" should be displayed
        await splashScreen.verifySplashScreenIsDisplayed();

        // Click on "GET STARTED" button on "Welcome Screen"
        await welcomeScreen.clickOnGetStartedButton();

        // Completing "Quiz" questions
        // Take all questions on "Lawn Condition" screen
        await lawnConditionScreen.verifyLawnConditionIsDisplayed();
        await lawnConditionScreen.setColorSliderValue('mostly_green');//passing grassColor map key which present in lawn_condition_screen
        await lawnConditionScreen.setThicknessSliderValue('some_grass');//passing grassThickness map key which present in lawn_condition_screen
        await lawnConditionScreen.setWeedsSliderValue('no_weeds');//passing weeds map key which present in lawn_condition_screen
        await lawnConditionScreen.clickOnSaveButton();

        // Take all questions on "Spreader Types" screen
        await spreaderTypesScreen.verifySpreaderTypeScreenIsDisplayed();
        await spreaderTypesScreen.selectSpreader('wheeled');

        // Take all questions on "Lawn Size" screen
        await lawnSizeScreen.verifyLawnSizeScreenIsDisplayed();
        await lawnSizeScreen.clickOnManualEnterLawnSizeLink();

        // Take all questions on "Manual Entry" screen
        await manualEntryScreen.verifyManualEntryScreenIsDisplayed();
        await manualEntryScreen.typeInZipCodeInputField('43203');
        await manualEntryScreen.typeInLawnSizeInputField('300');
        await manualEntryScreen.clickOnContinueButton();

        // Take all questions on "Grass Types" screen
        await grassTypeScreen.verifyGrassTypesScreenIsDisplayed();
        await grassTypeScreen.selectGrassType('Bermuda');

        // Take all questions on "Lawn Tracing" screen
        await lawnTracingScreen.verifyLawnTracingScreenElementsAreDisplayed();
        await lawnTracingScreen.selectYesNo(false);

        // Verify "Sign up Screen" should be displayed
        await signUpScreen.verifySignUpScreenIsDisplayed();

        // Verify "EmailScreen" should be displayed
        // Sign up user
        await signUpScreen.waitForSignUpScreenLoading();
        await signUpScreen.clickOnContinueWithEmailButton();
        email = 'automation.mylawn+' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '@gmail.com';
        await createAccountScreen.enterEmail(email);
        await createAccountScreen.clickOnContinueButton();
        await createAccountScreen.verifyCreateAccountScreenIsDisplayed();
        await createAccountScreen.enterPassword('Pass123!@#');
        await createAccountScreen.waitForCreateAccountScreenLoading();
        await createAccountScreen.clickOnSignUpButton();
        // Verify "Home Screen" should be displayed
        await homeScreen.verifyHomeScreenElementsAreDisplayed();

        // Navigate to profile
        await planScreen.clickOnProfileIcon();

        // Verify Profile screen is displayed
        await profileScreen.verifyProfileScreenIsDisplayed();

        // Open App Settings
        await profileScreen.clickOnAppSettingsButton();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 10),
      ),
    );

//    test('C71825: Turn ON Push Notification', () async {
//      // Turn On Push Notifications
////      await AppSettingScreen(driver).clickOnPushNotificationsSwitch();
//
//      if (Platform.isIOS) {
//        // Step: Allow permissions to accept push notifications
//        // TODO: "Push notification permissions modal is not displayed as of now"
//      }
//
//      // Step: Send push notification from Localytics dashboard
//      //TODO: "Need more info on how to send PN from Localytics dashboard"
//    });
//
//    test('C71827: To verify Push Notification is enabled', () async {
//      // Turn On Push Notifications
//      await AppSettingScreen(driver).clickOnPushNotificationsSwitch();
//
//      if (Platform.isIOS) {
//        // Step: Allow permissions to accept push notifications
//        // TODO: "Push notification permissions modal is not displayed as of now"
//      }
//
//      // Navigate back
//      await appSettingScreen.goToBack();
//
//      // Verify Profile screen is displayed
////      await profileScreen.verifyEditLawnProfileScreenElementsAreDisplayed();
//      // Open App Settings
//      await profileScreen.clickOnAppSettingsButton();
//
//      // Verify "App Settings" are be displayed
//      await appSettingScreen.verifyAppSettingScreenIsDisplayed();
//
//      // Verify Push Notification toggle remains in enabled state
////      TODO: "No method available for reading the value of Switch so we can assert if it is enabled
//    });
//
//    test('C71826: Deny Push Notification', () async {
//      // Turn On Push Notifications
//      await appSettingScreen.clickOnPushNotificationsSwitch();
//
//      // Step: Deny permissions to accept push notifications for ios
////    TODO: "Push notification permissions modal is not displayed as of now"
//
//      // Step: Send push notification from Localytics dashboard
////  TODO: "Need more info on how to send PN from Localytics dashboard"
//    });
//
//    test('C72035: Turn OFF Push Notification', () async {
//// Turn On Push Notifications
//      await appSettingScreen.clickOnPushNotificationsSwitch();
//
//      // Step: Allow permissions to accept push notifications
////      TODO: "Push notification permissions modal is not displayed as of now"
//
//      // Turn Off Push Notifications
//      await appSettingScreen.clickOnPushNotificationsSwitch();
//
//      // Step: Allow permissions to accept push notifications
////      TODO: "Push notification permissions modal is not displayed as of now"
//
//      // Step: Send push notification from Localytics dashboard
////    TODO: "Need more info on how to send PN from Localytics dashboard"
//    });
//
//    test('C72409: Turn ON Location Sharing - Always Allow', () async {
//      // Turn ON Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: Tap on 'Allow'
////    TODO: "Location permissions modal is not displayed as of now"
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//    });
//
//    test('C72410: Turn ON Location Sharing - Donot Allow', () async {
//      // Turn ON Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: Tap on 'Allow'
////    TODO: "Location permissions modal is not displayed as of now"
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//
//      // Step: Select Don't Allow
////    TODO: "System dialog box is not displayed as of now"
//    });
//
//    test('C72411: Deny Location Permission', () async {
//// Turn ON Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: Tap on 'Deny'
////    TODO: "Location permissions modal is not displayed as of now"
//
//      // Step: Verify Location permissions Pop up is dismissed
////    TODO: "Pop up is not displayed as of now"
//
//      // Step: Verify Location permission remains disabled
////    TODO: "Methods not available to verify the state of switch element"
//    });
//
//    test('C72412: Turn OFF Location Permission', () async {
//      // Turn ON Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: Tap on 'Allow'
////    TODO: "Location permissions modal is not displayed as of now"
//
//      // Step: Verify Location permissions Pop up is dismissed
////    TODO: "Pop up is not displayed as of now"
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//
//      // Step: Select Allow
////    TODO: "System dialog box is not displayed as of now"
//
//      // Turn OFF Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//
//      // Step: i) Go to device settings, turn OFF location service
////    TODO: "Research on how to turn device settings"
//    });
//
//    test('C72528: Cancel turning OFF Location Permission', () async {
//      // Blocked due to alert screen
//      // Turn ON Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: Tap on 'Allow'
////    TODO: "Location permissions modal is not displayed as of now"
//
//      // Step: Verify Location permissions Pop up is dismissed
////    TODO: "Pop up is not displayed as of now"
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//
//      // Step: Select Allow
////    TODO: "System dialog box is not displayed as of now"
//
//      // Turn OFF Location permission
//      await appSettingScreen.clickOnLocationPermissionSwitch();
//
//      // Step: System dialog box will appear
////    TODO: "System dialog box is not displayed as of now"
//
//      // Click on Cancel
////    TODO: "System dialog box is not displayed as of now"
//    });

    test(
      'C72036: About My Lawn App',
      () async {
        // Tap on About My Lawn App
        await appSettingScreen.clickOnAboutMyLawnAppButton();

        // Verify About My Lawn App screen elements are displayed
        await aboutMyLawnAppScreen
            .verifyAboutMyLawnAppScreenElementsAreDisplayed();

        // Go to back
        await aboutMyLawnAppScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72037: Condition Of Use',
      () async {
        // Tap on Terms & Conditions
        await appSettingScreen.clickOnConditionsOfUseButton();

        // Verify Terms & Conditions screen elements are displayed
        await conditionOfUseScreen
            .verifyConditionsOfUseScreenElementsAreDisplayed();

        // Go to back
        await conditionOfUseScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72038: Privacy Notice',
      () async {
        // Tap on Privacy Notice
        await appSettingScreen.clickOnPrivacyNoticeButton();

        // Verify Privacy Notice screen elements are displayed
        await privacyNoticeScreen
            .verifyPrivacyPolicyScreenElementsAreDisplayed();

        // Go to back
        await privacyNoticeScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72401: Give App Feedback',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

//       By default 'Share Today's Data' is turned ON
//    TODO: 'not able to verify if share data is turned on by default'

        // Go to back
        await appFeedBackScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72402: App Rating - Positive Feedback',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 5-star ratings
        await appFeedBackScreen.rateApp(5);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await positiveFeedbackScreen
            .verifyPositiveFeedbackScreenElementsAreDisplayed();

        // Go to back
        await positiveFeedbackScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72404: Positive Feedback - Rate Us in App / Play store',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 5-star ratings
        await appFeedBackScreen.rateApp(5);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await positiveFeedbackScreen
            .verifyPositiveFeedbackScreenElementsAreDisplayed();

        // TODO:Cannot verify email ,switching to other app is not supported(gmail)
//      await positiveFeedbackScreen.clickOnGoToAppStoreButton();

        // Go to back
        await positiveFeedbackScreen.goToBack();

        // Verify app setting screen
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72531: Cancel navigating to App store',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 5-star ratings
        await appFeedBackScreen.rateApp(5);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await positiveFeedbackScreen
            .verifyPositiveFeedbackScreenElementsAreDisplayed();

        //Go to back
        await positiveFeedbackScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72403: App Rating - Negative Feedback',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 2-star ratings
        await appFeedBackScreen.rateApp(2);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await negativeFeedbackScreen
            .verifyNegativeFeedbackScreenElementsAreDisplayed();

        //Go to back
        await negativeFeedbackScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72405: Negative Feedback - Contact Customer Support',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 2-star ratings
        await appFeedBackScreen.rateApp(2);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await negativeFeedbackScreen
            .verifyNegativeFeedbackScreenElementsAreDisplayed();

        // Tap on 'Contact Customer Support
//      await negativeFeedbackScreen.clickOnContactCustomerSupport();

        // User is taken to their email with their lawn info pre-populated in the email body
//    TODO:Cannot verify email ,switching to other app is not supported(gmail)

        //Go to back
        await negativeFeedbackScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72532: Cancel contacting customer support',
      () async {
        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Provide 2-star ratings
        await appFeedBackScreen.rateApp(2);

        await sleep(Duration(seconds: 2));

        // Tap on SEND
        await appFeedBackScreen.clickOnSendFeedback();

        // Verify Thankyou screen elements
        await appSettingScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 1),
      ),
    );

    test(
      'C72533: App Settings - Back navigation across all section',
      () async {
        // Navigate to About My Lawn App
        await appSettingScreen.clickOnAboutMyLawnAppButton();

        // Verify About My Lawn Screen
        await aboutMyLawnAppScreen
            .verifyAboutMyLawnAppScreenElementsAreDisplayed();

        // Navigate Back
        await aboutMyLawnAppScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();

        // Tap on Terms & Conditions
        await appSettingScreen.clickOnConditionsOfUseButton();

        // Verify Terms & Conditions screen elements are displayed
        await conditionOfUseScreen
            .verifyConditionsOfUseScreenElementsAreDisplayed();

        // Navigate Back
        await conditionOfUseScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();

        // Tap on Privacy Policy
        await appSettingScreen.clickOnPrivacyNoticeButton();

        // Verify Privacy Policy screen elements are displayed
        await privacyNoticeScreen
            .verifyPrivacyPolicyScreenElementsAreDisplayed();

        // Navigate Back
        await privacyNoticeScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();

        // Tap on Give App Feedback
        await appSettingScreen.clickOnGiveAppFeedbackButton();

        // Verify Give App Feedback screen elements are displayed
        await appFeedBackScreen.verifyAppFeedbackScreenIsDisplayed();

        // Navigate Back
        await appFeedBackScreen.goToBack();

        // Verify "App Settings" should be displayed
        await appSettingScreen.verifyAppSettingScreenIsDisplayed();
      },
      timeout: Timeout(
        Duration(minutes: 2),
      ),
    );
  });
}
