import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_lawn/blocs/checkout/address/search_address_form_bloc.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_exception.dart';

import 'package:my_lawn/extensions/places_data_extension.dart';
import 'package:my_lawn/services/places/places_response.dart';

import '../../../resources/place_details_data.dart';

class MockPlacesService extends Mock implements PlacesService {}

void main() {
  const debounceDuration = Duration(milliseconds: 300);
  group('SearchAddressBloc', () {
    PlacesService placesService;

    final predictions = <PlacePrediction>[
      PlacePrediction(placeId: '1', description: 'Place 1'),
      PlacePrediction(placeId: '123', description: 'Place 2'),
      PlacePrediction(placeId: '1234', description: 'Place 3'),
    ];

    final placeDetailsForPlaceId1 =
        PlaceDetailsResponse.fromJson(placeDetailsResponse).placeDetails;
    final addressDataForPlaceId1 = placeDetailsForPlaceId1.addressData;

    setUp(() {
      placesService = MockPlacesService();
    });

    test('throws AssertionError when PlacesService is null', () {
      expect(() => SearchAddressFormBloc(null), throwsAssertionError);
    });

    test('initial state is SearchAddressFormState.initial()', () {
      final bloc = SearchAddressFormBloc(placesService);
      expect(bloc.state, SearchAddressFormState.initial());
      bloc.close();
    });

    group('Find Addresses', () {
      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'invokes [findAddresses] method on [PlacesService] once when [SearchAddressEvent] is sent with non-empty [searchText] once',
        build: () => SearchAddressFormBloc(placesService),
        act: (bloc) => bloc.searchPlaces('1'),
        wait: debounceDuration,
        verify: (_) {
          verify(placesService.findAddresses('1')).called(1);
        },
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'does not invokes [findAddresses] method on [PlacesService] when [SearchAddressEvent] is sent with empty [searchText]',
        build: () => SearchAddressFormBloc(placesService),
        act: (bloc) => bloc.searchPlaces(''),
        wait: debounceDuration,
        verify: (_) {
          verifyNever(placesService.findAddresses(any));
        },
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'does not invokes [findAddresses] method on [PlacesService] when [SearchAddressEvent] is sent with null [searchText]',
        build: () => SearchAddressFormBloc(placesService),
        act: (bloc) => bloc.searchPlaces(null),
        wait: debounceDuration,
        verify: (_) {
          verifyNever(placesService.findAddresses(any));
        },
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [searchingAddress, searchingAddressSuccess] when [SearchAddressEvent] is sent with valid [searchText]',
        build: () {
          when(placesService.findAddresses('1'))
              .thenAnswer((_) async => predictions);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.searchPlaces('1'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.searchingAddress([]),
          SearchAddressFormState.searchingAddressSuccess(predictions),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [initial] when [SearchAddressEvent] is sent with empty [searchText]',
        build: () => SearchAddressFormBloc(placesService),
        act: (bloc) {
          bloc.searchPlaces('');
        },
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.initial(),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [initial] when [SearchAddressEvent] is sent with empty [searchText] after [searchingAddressSuccess] state',
        build: () {
          when(placesService.findAddresses(any))
              .thenAnswer((_) async => predictions);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) {
          bloc.searchPlaces('');
        },
        wait: debounceDuration,
        seed: SearchAddressFormState.searchingAddressSuccess(predictions),
        expect: <SearchAddressFormState>[
          SearchAddressFormState.initial(),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [searchingAddress, searchingAddressSuccess] when Places Api gives back success on [SearchAddressEvent]',
        build: () {
          when(placesService.findAddresses('1'))
              .thenAnswer((_) async => predictions);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.searchPlaces('1'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.searchingAddress([]),
          SearchAddressFormState.searchingAddressSuccess(predictions),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [searchingAddress, searchingAddressFailure] when Places Api throws [PlacesAutoCompleteException] on [SearchAddressEvent]',
        build: () {
          when(placesService.findAddresses(any))
              .thenThrow(PlacesAutoCompleteException('Invalid searchText'));
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.searchPlaces('1'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.searchingAddress([]),
          SearchAddressFormState.searchingAddressFailure('Invalid searchText'),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [searchingAddress, searchingAddressFailure] when Places Api fails with GenericException on [SearchAddressEvent]',
        build: () {
          when(placesService.findAddresses(any))
              .thenThrow(Exception('Error fetching addresses for "Street 1"'));
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.searchPlaces('Street 1'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.searchingAddress([]),
          SearchAddressFormState.searchingAddressFailure(
              'Error fetching addresses for "Street 1"'),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [cancelSearch] when [CancelSearchEvent] is sent when findAddresses api call is in progress',
        build: () {
          when(placesService.findAddresses(any))
              .thenAnswer((_) async => predictions);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.cancelSearch(),
        wait: debounceDuration,
        seed: SearchAddressFormState.searchingAddress([]),
        expect: <SearchAddressFormState>[
          SearchAddressFormState.cancelSearch(),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [cancelSearch] when [CancelSearchEvent] is sent when in [searchingAddressSuccess] state already',
        build: () {
          when(placesService.findAddresses(any))
              .thenAnswer((_) async => predictions);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.cancelSearch(),
        wait: debounceDuration,
        seed: SearchAddressFormState.searchingAddressSuccess(predictions),
        expect: <SearchAddressFormState>[
          SearchAddressFormState.cancelSearch(),
        ],
      );
    });

    group('Get Place Details', () {
      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'invokes [getPlaceDetails] method on [PlacesService] once when [GetAddressDetailsEvent] is sent',
        build: () => SearchAddressFormBloc(placesService),
        act: (bloc) => bloc.getAddressDetails('1', '95002'),
        wait: debounceDuration,
        verify: (_) {
          verify(placesService.getPlaceDetails('1')).called(1);
        },
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [gettingAddressDetails, addressDetailsSuccess] when [GetAddressDetailsEvent] is sent with valid [placeId] for selected zip code',
        build: () {
          when(placesService.getPlaceDetails('1'))
              .thenAnswer((_) async => placeDetailsForPlaceId1);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.getAddressDetails('1', '30339'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.gettingAddressDetails(),
          SearchAddressFormState.addressDetailsSuccess(addressDataForPlaceId1),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [gettingAddressDetails, addressDetailsSuccess] when [GetAddressDetailsEvent] is sent with invalid [placeId] for selected zip code',
        build: () {
          when(placesService.getPlaceDetails('1'))
              .thenAnswer((_) async => placeDetailsForPlaceId1);
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.getAddressDetails('1', '30340'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.gettingAddressDetails(),
          SearchAddressFormState.addressDetailsZipMismatchError(),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [gettingAddressDetails, addressDetailsError] when [GetAddressDetailsEvent] is sent with valid [placeId] but places api throws [PlaceDetailsException]',
        build: () {
          when(placesService.getPlaceDetails('1')).thenThrow(
              PlaceDetailsException(
                  'Unable to fetch place details for placeId : 1'));
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.getAddressDetails('1', '30339'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.gettingAddressDetails(),
          SearchAddressFormState.addressDetailsError(
              'Unable to fetch place details for placeId : 1'),
        ],
      );

      blocTest<SearchAddressFormBloc, SearchAddressFormState>(
        'emits [gettingAddressDetails, addressDetailsError] when [GetAddressDetailsEvent] is sent with valid [placeId] but places api throws GenericException',
        build: () {
          when(placesService.getPlaceDetails('1')).thenThrow(Exception());
          return SearchAddressFormBloc(placesService);
        },
        act: (bloc) => bloc.getAddressDetails('1', '30339'),
        wait: debounceDuration,
        expect: <SearchAddressFormState>[
          SearchAddressFormState.gettingAddressDetails(),
          SearchAddressFormState.addressDetailsError(
              'Error getting place details! Please try again.'),
        ],
      );
    });
  });
}
