import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/places/place_prediction_data.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_exception.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_lawn/extensions/places_data_extension.dart';

part 'search_address_form_event.dart';
part 'search_address_form_state.dart';

class SearchAddressFormBloc
    extends Bloc<AddressFormEvent, SearchAddressFormState> {
  final PlacesService _placesService;
  SearchAddressFormBloc(this._placesService)
      : assert(_placesService != null, 'PlacesService cannot be null'),
        super(SearchAddressFormState.initial());

  void searchPlaces(String searchText) {
    add(SearchAddressEvent(searchText));
  }

  void cancelSearch() {
    add(CancelSearchEvent());
  }

  void getAddressDetails(String placeId, String validZipCode) {
    add(GetAddressDetailsEvent(
      placeId: placeId,
      validZipCode: validZipCode,
    ));
  }

  @override
  Stream<Transition<AddressFormEvent, SearchAddressFormState>> transformEvents(
      Stream<AddressFormEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchAddressFormState> mapEventToState(
      AddressFormEvent event) async* {
    if (event is SearchAddressEvent) {
      yield* _mapSearchAddressEventToState(event);
    } else if (event is GetAddressDetailsEvent) {
      yield* _mapGetAddressDetailsEventToState(event);
    } else if (event is CancelSearchEvent) {
      yield SearchAddressFormState.cancelSearch();
    }
  }

  Stream<SearchAddressFormState> _mapSearchAddressEventToState(
      SearchAddressEvent event) async* {
    try {
      // If searchText is empty move the State to [initial] and don't do an api call
      if (event.searchText == null || event.searchText.isEmpty) {
        yield SearchAddressFormState.initial();
        return;
      }

      // Copy over old predictions to show old ones till recent ones are loaded
      yield SearchAddressFormState.searchingAddress(state.predictions);

      // Places Autocomplete api call
      final predictions = await _placesService.findAddresses(event.searchText);
      yield SearchAddressFormState.searchingAddressSuccess(predictions);
    } on PlacesAutoCompleteException catch (e) {
      yield SearchAddressFormState.searchingAddressFailure(e.reason);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield SearchAddressFormState.searchingAddressFailure(
          'Error fetching addresses for "${event.searchText}"');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }

  Stream<SearchAddressFormState> _mapGetAddressDetailsEventToState(
      GetAddressDetailsEvent event) async* {
    try {
      yield SearchAddressFormState.gettingAddressDetails();

      // Place Details API call
      final placeDetails = await _placesService.getPlaceDetails(event.placeId);

      // Convert PlaceDetails to AddressData using extension function
      final addressData = placeDetails.addressData;

      if (event.validZipCode != null &&
          event.validZipCode.isNotEmpty &&
          addressData.zip != event.validZipCode) {
        yield SearchAddressFormState.addressDetailsZipMismatchError();
        return;
      }

      yield SearchAddressFormState.addressDetailsSuccess(addressData);
    } on PlaceDetailsException catch (e) {
      yield SearchAddressFormState.addressDetailsError(e.reason);
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    } catch (e) {
      yield SearchAddressFormState.addressDetailsError(
          'Error getting place details! Please try again.');
      unawaited(
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current));
    }
  }
}
