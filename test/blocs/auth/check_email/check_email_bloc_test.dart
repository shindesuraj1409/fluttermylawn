import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/auth/check_email/check_email_bloc.dart';
import 'package:my_lawn/services/api_error_exceptions.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:test/test.dart';

class MockGigyaService extends Mock implements GigyaService {}

void main() {
  group('CheckEmailBloc', () {
    GigyaService gigyaService;

    setUp(() {
      gigyaService = MockGigyaService();
    });

    test('initial state is CheckEmailInitialState', () {
      final checkEmailBloc = CheckEmailBloc(gigyaService: gigyaService);
      expect(checkEmailBloc.state, CheckEmailInitialState());
      checkEmailBloc.close();
    });

    group('check is email available', () {
      const email = 'test@scotts.com';

      setUp(() {
        when(gigyaService.isEmailAvailable(email))
            .thenAnswer((_) async => true);
      });

      blocTest<CheckEmailBloc, CheckEmailState>(
        'invokes GigyaService isEmailAvailable',
        build: () => CheckEmailBloc(gigyaService: gigyaService),
        act: (bloc) => bloc.add(CheckEmailEvent(email)),
        verify: (_) {
          verify(gigyaService.isEmailAvailable(email)).called(1);
        },
      );

      blocTest<CheckEmailBloc, CheckEmailState>(
        'emits [CheckEmailLoading, CheckEmailSuccess(test@scotts.com, true)] when check succeeds',
        build: () => CheckEmailBloc(gigyaService: gigyaService),
        act: (bloc) => bloc.add(CheckEmailEvent(email)),
        expect: <CheckEmailState>[
          CheckEmailLoadingState(),
          CheckEmailSuccessState(email: email, isEmailAvailable: true),
        ],
      );

      blocTest<CheckEmailBloc, CheckEmailState>(
        'emits [CheckEmailLoading, CheckEmailSuccess(test@scotts.com, false)] when check succeeds',
        build: () {
          when(gigyaService.isEmailAvailable(email))
              .thenAnswer((_) async => false);
          return CheckEmailBloc(gigyaService: gigyaService);
        },
        act: (bloc) => bloc.add(CheckEmailEvent(email)),
        expect: <CheckEmailState>[
          CheckEmailLoadingState(),
          CheckEmailSuccessState(email: email, isEmailAvailable: false),
        ],
      );

      blocTest<CheckEmailBloc, CheckEmailState>(
        'emits [CheckEmailLoading, CheckEmailErrorState)] when check fails with gigyaErrorException',
        build: () {
          when(gigyaService.isEmailAvailable(email))
              .thenThrow(GigyaErrorException(401030));
          return CheckEmailBloc(gigyaService: gigyaService);
        },
        act: (bloc) => bloc.add(CheckEmailEvent(email)),
        expect: <CheckEmailState>[
          CheckEmailLoadingState(),
          CheckEmailErrorState(
            errorCode: 401030,
            errorMessage: 'Incorrect password',
          ),
        ],
      );

      blocTest<CheckEmailBloc, CheckEmailState>(
        'emits [CheckEmailLoading, CheckEmailErrorState)] when check fails with generic exception',
        build: () {
          when(gigyaService.isEmailAvailable(email)).thenThrow(Exception());
          return CheckEmailBloc(gigyaService: gigyaService);
        },
        act: (bloc) => bloc.add(CheckEmailEvent(email)),
        expect: <CheckEmailState>[
          CheckEmailLoadingState(),
          CheckEmailErrorState(
            errorMessage: 'Something went wrong. Please try again',
            errorCode: -1,
          )
        ],
      );
    });
  });
}
