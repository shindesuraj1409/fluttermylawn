import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/subscription/update_billing_info/update_billing_info_bloc.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/customer/customer_service_excpetion.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/order/order_exception.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';

class MockCustomerService extends Mock implements CustomerService {}

class MockSessionManager extends Mock implements SessionManager {}

class MockRecurlyService extends Mock implements RecurlyService {}

void main() {
  group('UpdateBillingInfoBloc', () {
    CustomerService customerService;
    RecurlyService recurlyService;
    SessionManager sessionManager;

    final validCreditCardData = CreditCardData(
      number: '5454545454545454',
      expiration: '1125',
      cvv: '111',
    );
    final inValidCreditCardData = validCreditCardData.copyWith(
      number: '5454545454',
    );
    final emptyCreditCardData = CreditCardData();

    final validRecurlyToken = '124aec-xe';

    final billingAddress = AddressData(
      firstName: 'FirstName',
      lastName: 'LastName',
      address1: '201 N Main St',
      city: 'Los Angeles',
      state: 'CA',
      country: 'US',
      zip: '95002',
    );
    final invalidBillingAddress =
        billingAddress.copyWith(address1: '2020 1 Main');

    final loggedInUser = User(
      customerId: '1',
      email: 'abc@xyz.co',
    );

    setUp(() {
      customerService = MockCustomerService();
      recurlyService = MockRecurlyService();
      sessionManager = MockSessionManager();
      when(sessionManager.getUser()).thenAnswer((_) async => loggedInUser);
    });

    test('throws AssertionError when dependencies passed are null', () {
      expect(
        () => UpdateBillingInfoBloc(
          customerService: null,
          recurlyService: null,
          sessionManager: null,
        ),
        throwsAssertionError,
      );
    });

    test('initial state is UpdateBillingInfoInitial()', () {
      final bloc = UpdateBillingInfoBloc(
        customerService: customerService,
        recurlyService: recurlyService,
        sessionManager: sessionManager,
      );
      expect(bloc.state, UpdateBillingInfoInitial());
      bloc.close();
    });

    group('Update Billing Info', () {
      blocTest<UpdateBillingInfoBloc, UpdateBillingInfoState>(
        'never invokes [getToken] on [RecurlyService] when user is updating only Billing Address',
        build: () => UpdateBillingInfoBloc(
          customerService: customerService,
          recurlyService: recurlyService,
          sessionManager: sessionManager,
        ),
        act: (bloc) => bloc.updateBillingInfo(
          emptyCreditCardData,
          billingAddress,
        ),
        verify: (_) {
          verifyNever(recurlyService.getToken(
            billingAddress,
            emptyCreditCardData,
          ));
        },
      );

      blocTest<UpdateBillingInfoBloc, UpdateBillingInfoState>(
        'invokes [getToken] on [RecurlyService] and [updateBillingInfo] on [CustomerService] when user is updating Credit Card info',
        build: () => UpdateBillingInfoBloc(
          customerService: customerService,
          recurlyService: recurlyService,
          sessionManager: sessionManager,
        ),
        act: (bloc) => bloc.updateBillingInfo(
          validCreditCardData,
          billingAddress,
        ),
        verify: (_) {
          verify(recurlyService.getToken(
            billingAddress,
            validCreditCardData,
          )).called(1);

          verify(customerService.updateBillingInfo(
            loggedInUser.customerId,
            billingAddress,
            any,
          )).called(1);
        },
      );

      blocTest<UpdateBillingInfoBloc, UpdateBillingInfoState>(
        'emit [UpdatingBillingInfo] and [UpdateBillingInfoError] when Credit Card Number is not valid',
        build: () {
          when(recurlyService.getToken(billingAddress, any)).thenThrow(
              RecurlyException('Number is not a valid credit card number'));

          return UpdateBillingInfoBloc(
            customerService: customerService,
            recurlyService: recurlyService,
            sessionManager: sessionManager,
          );
        },
        act: (bloc) => bloc.updateBillingInfo(
          inValidCreditCardData,
          billingAddress,
        ),
        expect: <UpdateBillingInfoState>[
          UpdatingBillingInfo(),
          UpdateBillingInfoError('Number is not a valid credit card number')
        ],
      );

      blocTest<UpdateBillingInfoBloc, UpdateBillingInfoState>(
        'emits [UpdatingBillingInfo] and [UpdateBillingInfoError] when Billing Address in invalid',
        build: () {
          when(recurlyService.getToken(
            invalidBillingAddress,
            validCreditCardData,
          )).thenAnswer((_) async => validRecurlyToken);

          when(customerService.updateBillingInfo(
            loggedInUser.customerId,
            invalidBillingAddress,
            validRecurlyToken,
          )).thenThrow(
              UpdateBillingInfoException('Unable to update Billing Info'));

          return UpdateBillingInfoBloc(
            customerService: customerService,
            recurlyService: recurlyService,
            sessionManager: sessionManager,
          );
        },
        act: (bloc) => bloc.updateBillingInfo(
          validCreditCardData,
          invalidBillingAddress,
        ),
        expect: <UpdateBillingInfoState>[
          UpdatingBillingInfo(),
          UpdateBillingInfoError('Unable to update Billing Info')
        ],
      );

      blocTest<UpdateBillingInfoBloc, UpdateBillingInfoState>(
        'emits [UpdatingBillingInfo] and [UpdateBillingInfoSuccess] when all information entered is valid',
        build: () {
          when(recurlyService.getToken(
            invalidBillingAddress,
            validCreditCardData,
          )).thenAnswer((_) async => validRecurlyToken);

          when(customerService.updateBillingInfo(
            loggedInUser.customerId,
            invalidBillingAddress,
            validRecurlyToken,
          )).thenAnswer((_) => null);

          return UpdateBillingInfoBloc(
            customerService: customerService,
            recurlyService: recurlyService,
            sessionManager: sessionManager,
          );
        },
        act: (bloc) => bloc.updateBillingInfo(
          validCreditCardData,
          invalidBillingAddress,
        ),
        expect: <UpdateBillingInfoState>[
          UpdatingBillingInfo(),
          UpdateBillingInfoSuccess()
        ],
      );
    });
  });
}
