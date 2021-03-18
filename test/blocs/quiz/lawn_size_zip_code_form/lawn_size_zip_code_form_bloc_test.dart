import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_lawn/blocs/quiz/lawn_size_zip_code_form/lawn_size_zip_code_form_bloc.dart';
import 'package:my_lawn/services/places/i_places_service.dart';

class MockPlacesService extends Mock implements PlacesService {}

void main() {
  const debounceDuration = Duration(milliseconds: 300);

  group('LawnSizeZipCodeFormBloc', () {
    const invalidZipCodeError = 'Please enter a valid zip code';
    const invalidLawnSizeError = 'Please enter a valid lawn area';

    test('initial state is LawnSizeZipCodeFormState with all empty fields', () {
      final formBloc = LawnSizeZipCodeFormBloc(MockPlacesService());
      expect(formBloc.state, LawnSizeZipCodeFormState.initial());
      formBloc.close();
    });

    group('Form fields entered', () {
      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [invalidZipCodeError] when zipcode entered is invalid',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.onZipCodeChanged('950'),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '950',
            lawnSize: '',
            zipCodeError: invalidZipCodeError,
            lawnSizeError: null,
          ),
        ],
      );

      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [noError] when zipcode entered is valid',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.onZipCodeChanged('95002'),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '95002',
            lawnSize: '',
            zipCodeError: null,
            lawnSizeError: null,
          ),
        ],
      );

      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [invalidLawnSizeError] when lawnSize entered is empty',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.onLawnSizeChanged(''),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '',
            lawnSize: '',
            zipCodeError: null,
            lawnSizeError: invalidLawnSizeError,
          ),
        ],
      );

      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [invalidLawnSizeError] when lawnSize entered is zero',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.onLawnSizeChanged('00'),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '',
            lawnSize: '00',
            zipCodeError: null,
            lawnSizeError: invalidLawnSizeError,
          ),
        ],
      );

      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [noError] when lawnSize entered is valid',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.onLawnSizeChanged('2400'),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '',
            lawnSize: '2400',
            zipCodeError: null,
            lawnSizeError: null,
          ),
        ],
      );
    });

    group('Submit Form', () {
      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [invalidZipCodeError and invalidLawnSizeError] when empty form is submitted',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.submitForm('', ''),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormState(
            zipCode: '',
            lawnSize: '',
            zipCodeError: invalidZipCodeError,
            lawnSizeError: invalidLawnSizeError,
          )
        ],
      );

      blocTest<LawnSizeZipCodeFormBloc, LawnSizeZipCodeFormState>(
        'emits [LawnSizeZipCodeFormSuccessState] when both zipCode and lawnSize submitted are valid',
        build: () => LawnSizeZipCodeFormBloc(MockPlacesService()),
        act: (bloc) => bloc.submitForm('95002', '2400'),
        wait: debounceDuration,
        expect: const <LawnSizeZipCodeFormState>[
          LawnSizeZipCodeFormSuccessState(
            zipCode: '95002',
            lawnSize: '2400',
          )
        ],
      );
    });
  });
}
