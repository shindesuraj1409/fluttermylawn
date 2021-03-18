import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/subscription_card_widget.dart';

import '../utils/image_test_utils.dart';

void main() {
  Product product;
  setUp(() {
    final productApplicationWindow = ProductApplicationWindow.fromJson(
      {
        'startDate': '2020-01-01',
        'endDate': '2020-12-12',
        'shipStartDate': '2020-11-11',
        'shipEndDate': '2020-11-11'
      },
    );
    //Note: ChildProduts cannot be empty or subcription card will fail
    product = Product(
      childProducts: [
        Product(
          imageUrl: 'https://www.scotts.com/',
        )
      ],
      applicationWindow: productApplicationWindow,
      name: 'Test Product',
    );
  });

  testWidgets('Find Title and SubscriptionWidget', (WidgetTester tester) async {
    await provideMockedNetworkImages(() async {
      /// Now we can pump NetworkImages without crashing our tests. Yay!
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: SubscriptionCard(
          product: product,
          isCollapsed: false,
        ),
      ));
      final tappableProductTitle = find.ancestor(
          of: find.text('Test Product'), matching: find.byType(TappableText));
      final tappableViewDetails = find.ancestor(
          of: find.text('VIEW DETAILS'), matching: find.byType(TappableText));
      expect(tappableProductTitle, findsOneWidget);
      expect(tappableViewDetails, findsOneWidget);
    });
  });
}
