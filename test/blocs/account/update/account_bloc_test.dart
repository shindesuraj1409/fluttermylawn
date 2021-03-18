import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/data/user_data.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';

class MockCustomerService extends Mock implements CustomerService {}

class MockSessionManager extends Mock implements SessionManager {}

class MockGigyaService extends Mock implements GigyaService {}

void main() {
  group(
    'AccountBloc',
    () {
      CustomerService _customerService;
      SessionManager _sessionManager;
      GigyaService _gigyaService;

      final _user = User(
        email: 'test@gmail.com',
        firstName: 'Test',
        lastName: 'Test',
        customerId: 'customerId',
        isNewsletterSubscribed: true,
      );

      final _customerId = 'customerId';
      final _email = 'test@gmail.com';
      final _firstName = 'Test';
      final _lastName = 'Test';
      final _oldPassword = 'Test@123';
      final _newPassword = 'Test@12345';

      setUp(() {
        _customerService = MockCustomerService();
        _sessionManager = MockSessionManager();
        _gigyaService = MockGigyaService();
      });

      test(
          'throws AssertionError when CustomerService, SessionManager, GigyaService is null',
          () {
        expect(
            () => AccountBloc(
                  null,
                  null,
                  null,
                  null,
                ),
            throwsAssertionError);
      });

      test('initial state is AccountState.initial()', () {
        final bloc = AccountBloc(
            _customerService, _sessionManager, _gigyaService, _user);
        expect(bloc.state, AccountState.initial(_user));
        bloc.close();
      });

      group('Change Password', () {
        blocTest<AccountBloc, AccountState>(
          'invokes setAccountInfo on gigyaService',
          build: () => AccountBloc(
              _customerService, _sessionManager, _gigyaService, _user),
          act: (bloc) =>
              bloc.add(ChangePasswordEvent(_oldPassword, _newPassword)),
          verify: (_) {
            verify(_gigyaService.setAccountInfo(
              currentPassword: _oldPassword,
              newPassword: _newPassword,
            )).called(1);
          },
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, success] when setAccountInfo returns success',
          build: () {
            _gigyaService.setAccountInfo(
              currentPassword: _oldPassword,
              newPassword: _newPassword,
            );
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) => bloc.add(
            ChangePasswordEvent(_oldPassword, _newPassword),
          ),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.success('Password Updated Successfully!', _user),
          ],
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, error] when setAccountInfo returns Generic exception',
          build: () {
            when(_gigyaService.setAccountInfo(
              currentPassword: _oldPassword,
              newPassword: _oldPassword,
            )).thenThrow(Exception());
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) => bloc.add(
            ChangePasswordEvent(_oldPassword, _oldPassword),
          ),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.error(genericErrorMessage, _user),
          ],
        );
      });

      group('Account Update', () {
        blocTest<AccountBloc, AccountState>(
          'invokes udpate customer on customer service',
          build: () => AccountBloc(
              _customerService, _sessionManager, _gigyaService, _user),
          act: (bloc) =>
              bloc.add(AccountUpdateEvent(_email, _firstName, _lastName, true)),
          verify: (_) {
            verify(_customerService.updateCustomer(_customerId, _user))
                .called(1);
            verify(_customerService.getCustomer(_customerId)).called(1);
            verify(_sessionManager.getUser());
          },
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, success] when updateCustomer returns success',
          build: () {
            when(_customerService.updateCustomer(_customerId, _user))
                .thenAnswer((_) async => genericeSuccessMessage);
            when(_customerService.getCustomer(_customerId))
                .thenAnswer((_) async => _user);
            _sessionManager.setUser(_user);
            when(_sessionManager.getUser()).thenAnswer((_) async => _user);
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) =>
              bloc.add(AccountUpdateEvent(_email, _firstName, _lastName, true)),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.success(genericeSuccessMessage, _user),
          ],
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, error] when updateCustomer returns Generic exception',
          build: () {
            when(_customerService.updateCustomer(_customerId, _user))
                .thenThrow(Exception());
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) =>
              bloc.add(AccountUpdateEvent(_email, _firstName, _lastName, true)),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.error(genericErrorMessage, _user),
          ],
        );
      });

      group('Subscribe to NewsLetter', () {
        blocTest<AccountBloc, AccountState>(
          'invokes subscribeNewsLetter call',
          build: () => AccountBloc(
              _customerService, _sessionManager, _gigyaService, _user),
          act: (bloc) => bloc.add(AccountSubscribeNewsLetterEvent()),
          verify: (_) {
            verify(_customerService.subscribeNewsLetter(_customerId)).called(1);
            verify(_sessionManager.getUser());
          },
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, success] when subscribeNewsLetter returns success',
          build: () {
            when(_customerService.subscribeNewsLetter(_customerId))
                .thenAnswer((_) async => _user);
            _sessionManager.setUser(_user);
            when(_sessionManager.getUser()).thenAnswer((_) async => _user);
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) => bloc.add(AccountSubscribeNewsLetterEvent()),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.success(genericeSuccessMessage, _user),
          ],
        );

        blocTest<AccountBloc, AccountState>(
          'emits [loading, error] when subscribeNewsLetter returns Generic exception',
          build: () {
            when(_customerService.subscribeNewsLetter(_customerId))
                .thenThrow(Exception());
            return AccountBloc(
                _customerService, _sessionManager, _gigyaService, _user);
          },
          act: (bloc) => bloc.add(AccountSubscribeNewsLetterEvent()),
          expect: <AccountState>[
            AccountState.loading(_user),
            AccountState.error(genericErrorMessage, _user),
          ],
        );
      });
    },
  );
}
