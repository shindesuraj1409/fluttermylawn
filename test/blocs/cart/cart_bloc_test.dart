import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/data/cart/cart_item_data.dart';
import 'package:my_lawn/data/cart/cart_totals_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/services/cart/cart_api_exceptions.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';

import '../../resources/cart_totals_data.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  group('CartBloc', () {
    CartService cartService;

    final customerId = '22fa7f11-abf3-4453-9f46-fba29a5c12a9';
    final recommendationId = 'bf3ee422-ae60-49fd-ac37-5f8393c23920';
    final cartId = 'cb2qFQqMzILKJi9he8KY5LE2UGUc8lkp';

    // Annual plan cart data

    final plan = Plan.fromJson(addOnProducts);
    final addOnProduct1 = plan.addOnProducts.first;
    final addOnProduct2 = plan.addOnProducts.last;

    final addOnCartItem1Added = CartItemData(
      id: 1,
      cartId: cartId,
      sku: '76121',
      qty: 1,
      name: 'Scotts® Turf Builder® with Edgeguard Mini Spreader',
    );
    final addOnCartItem2Added = CartItemData(
      id: 2,
      cartId: cartId,
      sku: '76122',
      qty: 1,
      name: 'Scotts® Turf Builder® with Edgeguard Mega Spreader',
    );

    final cartTotalsForAnnualPlan = CartTotals.fromJson(annualCartTotals);
    final cartTotalsSummaryForAnnualPlan =
        cartTotalsForAnnualPlan.copyWith(cartItems: [
      CartItemData(
        id: -1,
        cartId: cartId,
        name: 'Annual Subscription',
        rowTotal: 69.96,
        qty: 4,
      )
    ]);

    // Seasonal plan cart data
    final cartTotalsForSeasonalPlan = CartTotals.fromJson(seasonalCartTotals);
    final cartTotalsSummaryForSeasonalPlan =
        cartTotalsForSeasonalPlan.copyWith(cartItems: [
      CartItemData(
        id: -1,
        cartId: cartId,
        name: 'Seasonal Subscription',
        rowTotal: 17.49,
        qty: 1,
      )
    ]);

    final cartTotalsForSeasonalPlanWithAddOn =
        CartTotals.fromJson(seasonalCartTotalsWithAddOns);
    final cartTotalsSummaryForSeasonalPlanWithAddOn =
        cartTotalsForSeasonalPlanWithAddOn.copyWith(cartItems: [
      CartItemData(
        id: -1,
        cartId: cartId,
        name: 'Seasonal Subscription',
        rowTotal: 17.49,
        qty: 1,
      ),
      addOnCartItem1Added
    ]);

    setUp(() {
      cartService = MockCartService();
    });

    test('throws AssertionError when CartService is null', () {
      expect(() => CartBloc(null), throwsAssertionError);
    });

    test('initial state is CartState.initial()', () {
      final bloc = CartBloc(cartService);
      expect(bloc.state, CartState.initial());
      bloc.close();
    });

    group('Create Cart and Get Cart Totals', () {
      blocTest<CartBloc, CartState>(
        'invokes createCart with CartType.annual for annual plan',
        build: () => CartBloc(cartService),
        act: (bloc) => bloc.createCart(
          customerId,
          recommendationId,
          SubscriptionType.annual,
        ),
        verify: (_) {
          verify(cartService.createCart(
            customerId,
            recommendationId,
            CartType.annual,
          )).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes createCart with CartType.seasonal for seasonal plan',
        build: () => CartBloc(cartService),
        act: (bloc) => bloc.createCart(
          customerId,
          recommendationId,
          SubscriptionType.seasonal,
        ),
        verify: (_) {
          verify(cartService.createCart(
            customerId,
            recommendationId,
            CartType.seasonal,
          )).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes createCart api whenever [CreateCartEvent] is called',
        build: () {
          when(cartService.createCart(
            customerId,
            recommendationId,
            CartType.annual,
          )).thenAnswer((_) async => cartId);

          return CartBloc(cartService);
        },
        act: (bloc) => bloc
          ..createCart(
            customerId,
            recommendationId,
            SubscriptionType.annual,
          )
          ..createCart(
            customerId,
            recommendationId,
            SubscriptionType.annual,
          ), // Retry request
        verify: (_) {
          verify(cartService.createCart(any, any, any)).called(2);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes getCartTotals api whenever [GetCartTotalsEvent] is called',
        build: () {
          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForAnnualPlan);

          return CartBloc(cartService);
        },
        act: (bloc) => bloc
          ..getCartTotals(
            cartId,
            SubscriptionType.annual,
          )
          ..getCartTotals(
            cartId,
            SubscriptionType.annual,
          ), // Retry request
        verify: (_) {
          verify(cartService.getCartTotals(cartId)).called(2);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [creatingCart, cartCreated] when createCart api creates cart successfully',
        build: () {
          when(cartService.createCart(
            customerId,
            recommendationId,
            CartType.annual,
          )).thenAnswer((_) async => cartId);
          return CartBloc(cartService);
        },
        act: (bloc) => bloc.createCart(
          customerId,
          recommendationId,
          SubscriptionType.annual,
        ),
        expect: <CartState>[
          CartState.creatingCart(creatingCartMessage),
          CartState.cartCreated()
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [creatingCart, error] when createCart api fails to create cart',
        build: () {
          when(cartService.createCart(
            customerId,
            recommendationId,
            CartType.annual,
          )).thenThrow(CreateCartException(
              'Sorry, unable to create cart at the moment.'));

          return CartBloc(cartService);
        },
        act: (bloc) => bloc.createCart(
          customerId,
          recommendationId,
          SubscriptionType.annual,
        ),
        expect: <CartState>[
          CartState.creatingCart(creatingCartMessage),
          CartState.error('Sorry, unable to create cart at the moment.')
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [loadingCartInfo, cartInfoReceived] when getCartTotals api gives back cartTotals for Annual plan',
        build: () {
          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForAnnualPlan);

          return CartBloc(cartService);
        },
        act: (bloc) => bloc.getCartTotals(cartId, SubscriptionType.annual),
        expect: <CartState>[
          CartState.loadingCartInfo([], loadingCartInfoMessage),
          CartState.cartInfoReceived(
            [],
            cartTotalsSummaryForAnnualPlan,
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [loadingCartInfo, cartInfoReceived] when getCartTotals api gives back cartTotals for Seasonal plan',
        build: () {
          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForSeasonalPlan);

          return CartBloc(cartService);
        },
        act: (bloc) => bloc.getCartTotals(cartId, SubscriptionType.seasonal),
        expect: <CartState>[
          CartState.loadingCartInfo(
            [],
            loadingCartInfoMessage,
          ),
          CartState.cartInfoReceived(
            [],
            cartTotalsSummaryForSeasonalPlan,
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [loadingCartInfo, cartInfoError] when getCartTotals api throws GetCartTotalsException',
        build: () {
          when(cartService.getCartTotals(cartId))
              .thenThrow(GetCartTotalsException('Unable to get Order Summary'));

          return CartBloc(cartService);
        },
        act: (bloc) => bloc.getCartTotals(cartId, SubscriptionType.annual),
        expect: <CartState>[
          CartState.loadingCartInfo([], loadingCartInfoMessage),
          CartState.cartInfoError(
            [],
            'Unable to get Order Summary',
          ),
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [loadingCartInfo, cartInfoError] when getCartTotals api throws genericError',
        build: () {
          when(cartService.getCartTotals(cartId))
              .thenThrow(Exception('Unable to get Order Summary'));

          return CartBloc(cartService);
        },
        act: (bloc) => bloc.getCartTotals(cartId, SubscriptionType.annual),
        expect: <CartState>[
          CartState.loadingCartInfo([], loadingCartInfoMessage),
          CartState.cartInfoError([], 'Unable to get Order Summary')
        ],
      );
    });

    group('Add/Remove Add-on Products', () {
      blocTest<CartBloc, CartState>(
        'invokes addToCart api only once when [AddToCartEvent] is called multiple times with same Product',
        build: () {
          when(cartService.addToCart(any))
              .thenAnswer((_) async => addOnCartItem1Added);

          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForSeasonalPlan);

          return CartBloc(cartService);
        },
        seed: CartState.cartInfoReceived([], cartTotalsSummaryForSeasonalPlan),
        act: (bloc) => bloc
          ..addToCart(addOnProduct1, cartId)
          ..addToCart(addOnProduct1, cartId)
          ..addToCart(addOnProduct1, cartId),
        verify: (_) {
          verify(cartService.addToCart(any)).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes removeFromCart api only once when [RemoveFromCartEvent] is called multiple times with same Product',
        build: () {
          when(cartService.removeFromCart(cartId, addOnCartItem1Added.id))
              .thenAnswer((_) async => true);

          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForSeasonalPlan);

          return CartBloc(cartService);
        },
        seed: CartState.cartInfoReceived(
          [addOnCartItem1Added],
          cartTotalsSummaryForSeasonalPlan,
        ),
        act: (bloc) => bloc
          ..removeFromCart(addOnProduct1, cartId)
          ..removeFromCart(addOnProduct1, cartId),
        verify: (_) {
          verify(cartService.removeFromCart(
            cartId,
            addOnCartItem1Added.id,
          )).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes addToCart api twice correctly when [AddToCartEvent] is called for 2 different products parallely',
        build: () {
          when(cartService.addToCart(any))
              .thenAnswer((_) async => addOnCartItem1Added);

          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForSeasonalPlan);

          return CartBloc(cartService);
        },
        act: (bloc) => bloc
          ..addToCart(addOnProduct1, cartId)
          ..addToCart(addOnProduct2, cartId),
        verify: (_) {
          verify(cartService.addToCart(any)).called(2);
          verify(cartService.getCartTotals(cartId)).called(2);
        },
      );

      blocTest<CartBloc, CartState>(
        'invokes removeFromCart api twice correctly when [RemoveFromCartEvent] is called for 2 different products parallely',
        build: () {
          when(cartService.removeFromCart(cartId, any))
              .thenAnswer((_) async => true);

          when(cartService.getCartTotals(cartId))
              .thenAnswer((_) async => cartTotalsForSeasonalPlan);

          return CartBloc(cartService);
        },
        seed: CartState.cartInfoReceived(
          [addOnCartItem1Added, addOnCartItem2Added],
          cartTotalsSummaryForSeasonalPlan,
        ),
        act: (bloc) => bloc
          ..removeFromCart(addOnProduct1, cartId)
          ..removeFromCart(addOnProduct2, cartId),
        verify: (_) {
          verify(cartService.removeFromCart(cartId, any)).called(2);
          verify(cartService.getCartTotals(any)).called(2);
        },
      );
    });

    blocTest<CartBloc, CartState>(
      'emits [addingToCart, addToCartSuccess] when Ading to Cart is completed successfully',
      build: () {
        when(cartService.addToCart(any)).thenAnswer(
          (_) async => addOnCartItem1Added,
        );

        when(cartService.getCartTotals(cartId))
            .thenAnswer((_) async => cartTotalsForSeasonalPlanWithAddOn);

        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [],
        cartTotalsSummaryForSeasonalPlan,
      ),
      act: (bloc) async => bloc
        ..selectedSubscriptionType = SubscriptionType.seasonal
        ..addToCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.addingToCart(
          cartTotalsSummaryForSeasonalPlan,
          [],
          addingToCartMessage,
        ),
        CartState.addToCartSuccess(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          addToCartSuccessMessage,
        )
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [addingToCart, addToCartError] when Ading to Cart fails with AddToCartException',
      build: () {
        when(cartService.addToCart(any)).thenThrow(AddToCartException(
          message: 'Unabled to add product to the Cart',
          sku: '1',
        ));
        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [],
        cartTotalsSummaryForSeasonalPlan,
      ),
      act: (bloc) async => bloc..addToCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.addingToCart(
          cartTotalsSummaryForSeasonalPlan,
          [],
          addingToCartMessage,
        ),
        CartState.addToCartError(
          cartTotalsSummaryForSeasonalPlan,
          [],
          'Unabled to add product to the Cart',
        )
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [addingToCart, addToCartError] when Ading to Cart fails with GenericError',
      build: () {
        when(cartService.addToCart(any)).thenThrow(Exception());
        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [],
        cartTotalsSummaryForSeasonalPlan,
      ),
      act: (bloc) async => bloc..addToCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.addingToCart(
          cartTotalsSummaryForSeasonalPlan,
          [],
          addingToCartMessage,
        ),
        CartState.addToCartError(
          cartTotalsSummaryForSeasonalPlan,
          [],
          addToCartErrorMessage,
        )
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [removingFromCart, removeFromCartSuccess] when Removing from Cart is completed suucessfully',
      build: () {
        when(cartService.removeFromCart(cartId, addOnCartItem1Added.id))
            .thenAnswer((_) async => true);

        when(cartService.getCartTotals(cartId))
            .thenAnswer((_) async => cartTotalsForSeasonalPlan);

        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [addOnCartItem1Added],
        cartTotalsSummaryForSeasonalPlanWithAddOn,
      ),
      act: (bloc) async => bloc
        ..selectedSubscriptionType = SubscriptionType.seasonal
        ..removeFromCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.removingFromCart(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          removingFromCartMessage,
        ),
        CartState.removeFromCartSuccess(
          cartTotalsSummaryForSeasonalPlan,
          [],
          removeFromCartSuccessMessage,
        )
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [removingFromCart, removeFromCartError] when Removing from Cart fails with RemoveFromCartException ',
      build: () {
        when(cartService.removeFromCart(cartId, addOnCartItem1Added.id))
            .thenThrow(RemoveFromCartException(
                itemId: addOnCartItem1Added.id,
                message: 'Unable to remove product from the Cart'));

        when(cartService.getCartTotals(cartId))
            .thenAnswer((_) async => cartTotalsForSeasonalPlanWithAddOn);

        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [addOnCartItem1Added],
        cartTotalsSummaryForSeasonalPlanWithAddOn,
      ),
      act: (bloc) async => bloc..removeFromCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.removingFromCart(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          removingFromCartMessage,
        ),
        CartState.removeFromCartError(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          'Unable to remove product from the Cart',
        )
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [removingFromCart, removeFromCartError] when Removing from Cart fails with GenericError ',
      build: () {
        when(cartService.removeFromCart(cartId, addOnCartItem1Added.id))
            .thenThrow(Exception());

        when(cartService.getCartTotals(cartId))
            .thenAnswer((_) async => cartTotalsForSeasonalPlanWithAddOn);

        return CartBloc(cartService);
      },
      seed: CartState.cartInfoReceived(
        [addOnCartItem1Added],
        cartTotalsSummaryForSeasonalPlanWithAddOn,
      ),
      act: (bloc) async => bloc..removeFromCart(addOnProduct1, cartId),
      expect: <CartState>[
        CartState.removingFromCart(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          removingFromCartMessage,
        ),
        CartState.removeFromCartError(
          cartTotalsSummaryForSeasonalPlanWithAddOn,
          [addOnCartItem1Added],
          removeFromCartErrorMessage,
        )
      ],
    );
  });
}
