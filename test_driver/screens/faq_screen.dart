import 'package:flutter_driver/src/driver/driver.dart';
import 'dart:io';
import 'screens.dart';

class FAQScreen extends BaseScreen {
  FAQScreen(FlutterDriver driver) : super(driver);
  final faq_title = find.text('FAQs');
  final faq = find.byValueKey('faqs');
  final faq_parent = find.byType('CustomScrollView');
  final subscription = find.byValueKey('subscription');
  final billing_and_shipping = find.byValueKey('billing_and_shipping');

  final subscriptionFaqList = <String>[
    'How do I know when to apply products?',
    'Do I need to know my grass type to get a plan?',
    'How does my plan work with the My Lawn App?',
    'What is the difference between the subscription options?',
    'Can I change from a seasonal to an annual or vice versa?'
  ];

  final billinAndShippingFaqList = <String>[
    'When and how often will I be billed?',
    'How do I update my credit card?',
    'How do I cancel my subscription?',
    'I have a question about my bill.',
    'How do I update my billing and shipping address?'
  ];

  Map faqBillingList = {
    'How do I update my credit card?':
        'To update your credit card information, log into your account and click Billing Information. You can change your credit card information and billing address on this page.'
  };

  final failingString = 'How do I update my billing and shipping addresses?';

  Future<void> verifyFaqScreen() async {
    assert(await getText(header_title) == 'My Subscription');
    await verifyElementIsDisplayed(faq_title);
    await verifyElementIsDisplayed(subscription);
    for (var item in subscriptionFaqList) {
      await verifyElementIsDisplayed(await find.text(item));
    }
  }

  Future<void> verifyBillingAndShippingList() async {
    for (var item in billinAndShippingFaqList) {
      await verifyElementIsDisplayed(await find.text(item));
    }
  }

  Future<void> clickOnSubscription() async {
    await clickOn(subscription);
  }

  Future<void> clickOnSubscriptionFAQListViewItem() async {
    for (var i in subscriptionFaqList) {
      await _clickOnItem(i);

      sleep(Duration(seconds: 1));
      await _clickOnItem(i);
    }
    await scrollElement(faq_parent, dy: 50);
  }

  Future<void> clickOnBillingAndShippingFAQListItem() async {
    for (var i in billinAndShippingFaqList) {
      await _clickOnItem(i);

      sleep(Duration(seconds: 1));
      await _clickOnItem(i);
    }
    await scrollElement(faq_parent, dy: 50);
  }

  Future<void> clickOnbillingAndShipping() async {
    await clickOn(billing_and_shipping);
  }

  Future<void> clickOnFaq() async {
    await clickOn(faq);
  }

  Future<void> _clickOnItem(String item) async {
    await clickOn(await find.text(item));
  }

  Future<void> clickOnFailingString() async {
    await clickOn(find.text(failingString));
  }

  Future<void> goToSubscriptionScreen() async {
    await goToBack();
  }

  Future<void> verifyBillingFAQDescription({var faqQuestion}) async {
    await verifyBillingAndShippingList();
    if(faqQuestion!=null){
      await verifyElementIsDisplayed(find.text(faqBillingList[faqQuestion]));
    }
    else{
      for(var faq in faqBillingList.keys){
        await verifyElementIsDisplayed(find.text(faqBillingList[faq]));
      }
    }

  }
}
