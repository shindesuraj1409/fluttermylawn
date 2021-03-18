import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/forgot_password/forgot_password_bloc.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:test/test.dart';

class MockGigyaService extends Mock implements GigyaService {}

void main() {
  group('ForgotPasswordBloc', () {
    GigyaService _gigyaService;
    ForgotPasswordBloc _forgotPasswordBloc;

    setUp(() {
      _gigyaService = MockGigyaService();
      _forgotPasswordBloc = ForgotPasswordBloc(gigyaService: _gigyaService);
    });

    test('initial state is ForgotPasswordInitial', () {
      expect(_forgotPasswordBloc.state, ForgotPasswordInitial());
      _forgotPasswordBloc.close();
    });

    group('Send reset password email', () {
      final email = 'test@scotts.com';

      setUp(() {
        when(_gigyaService.resetPassword(email)).thenAnswer((_) async => true);
      });

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [ForgotPasswordLoading, ForgotPasswordSuccess]',
        build: () => _forgotPasswordBloc,
        act: (bloc) => bloc.add(ResetPasswordEmailRequested(email)),
        verify: (_) {
          verify(_gigyaService.resetPassword(email)).called(1);
        },
        expect: <ForgotPasswordState>[
          ForgotPasswordLoading(),
          ForgotPasswordSuccess(),
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [ForgotPasswordLoading, ForgotPasswordError]',
        build: () {
          when(_gigyaService.resetPassword(email))
              .thenAnswer((_) async => false);
          return ForgotPasswordBloc(gigyaService: _gigyaService);
        },
        act: (bloc) => bloc.add(ResetPasswordEmailRequested(email)),
        expect: <ForgotPasswordState>[
          ForgotPasswordLoading(),
          ForgotPasswordError(
            errorMessage: 'Something went wrong. Please try again',
            errorCode: -1,
          )
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [ForgotPasswordLoading, ForgotPasswordError] on GigyaException',
        build: () {
          when(_gigyaService.resetPassword(email))
              .thenThrow(GigyaErrorException(1));
          return ForgotPasswordBloc(gigyaService: _gigyaService);
        },
        act: (bloc) => bloc.add(ResetPasswordEmailRequested(email)),
        expect: <ForgotPasswordState>[
          ForgotPasswordLoading(),
          ForgotPasswordError(
            errorMessage: 'Something went wrong. Please try again!',
            errorCode: 1,
          )
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [ForgotPasswordLoading, ForgotPasswordError] on Exception',
        build: () {
          when(_gigyaService.resetPassword(email)).thenThrow(Exception());
          return ForgotPasswordBloc(gigyaService: _gigyaService);
        },
        act: (bloc) => bloc.add(ResetPasswordEmailRequested(email)),
        expect: <ForgotPasswordState>[
          ForgotPasswordLoading(),
          ForgotPasswordError(
            errorMessage: 'Something went wrong. Please try again',
            errorCode: -1,
          )
        ],
      );
    });
  });
}
