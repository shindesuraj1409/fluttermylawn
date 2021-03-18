import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_exception.dart';
import 'package:rxdart/rxdart.dart';

part 'lawn_size_zip_code_form_event.dart';
part 'lawn_size_zip_code_form_state.dart';

class LawnSizeZipCodeFormBloc
    extends Bloc<LawnSizeZipCodeFormEvent, LawnSizeZipCodeFormState> {
  final PlacesService placesServices;
  final invalidZipCodeError = 'Please enter a valid zip code';
  final invalidLawnSizeError = 'Please enter a valid lawn area';
  var _zipCode = '';
  var _lawnSize = '';
  // Valid US Zip codes are 5 digits and 9 digits(5 digits + '-' + 4 digits)
  final zipCodePattern = RegExp('^[0-9]{5}(?:-[0-9]{4})?\$');

  LawnSizeZipCodeFormBloc(this.placesServices)
      : super(LawnSizeZipCodeFormState.initial());

  void onZipCodeChanged(String zipCode) {
    _zipCode = zipCode;
    add(SetZipCodeFormEvent(zipCode));
  }

  void onLawnSizeChanged(String lawnSize) {
    _lawnSize=lawnSize;
    add(SetLawnSizeFormEvent(lawnSize));
  }

  void submitForm(String zipCode, String lawnSize) {
    if(zipCode=='' && _zipCode!=null){
      zipCode = _zipCode;
    }
    if(lawnSize=='' && _lawnSize!=null){
      lawnSize = _lawnSize;
    }
    add(SubmitFormEvent(zipCode: zipCode, lawnSize: lawnSize));
  }

  @override
  Stream<Transition<LawnSizeZipCodeFormEvent, LawnSizeZipCodeFormState>>
      transformEvents(
    Stream<LawnSizeZipCodeFormEvent> events,
    TransitionFunction<LawnSizeZipCodeFormEvent, LawnSizeZipCodeFormState>
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<LawnSizeZipCodeFormState> mapEventToState(
    LawnSizeZipCodeFormEvent event,
  ) async* {
    if (event is SetZipCodeFormEvent) {
      final isValidZipCode = await _isValidZipCode(event.zipCode);
      if (isValidZipCode) {
        yield state.copyWith(
          zipCodeError: null,
          lawnSizeError: state.lawnSizeError,
          zipCode: event.zipCode,
        );
      } else {
        yield state.copyWith(
          zipCodeError: invalidZipCodeError,
          lawnSizeError: state.lawnSizeError,
          zipCode: event.zipCode,
        );
      }
    } else if (event is SetLawnSizeFormEvent) {
      final isValidLawnSize = _isValidLawnSize(event.lawnSize);
      if (isValidLawnSize) {
        yield state.copyWith(
          lawnSizeError: null,
          zipCodeError: state.zipCodeError,
          lawnSize: event.lawnSize,
        );
      } else {
        yield state.copyWith(
          lawnSizeError: invalidLawnSizeError,
          zipCodeError: state.zipCodeError,
          lawnSize: event.lawnSize,
        );
      }
    } else if (event is SubmitFormEvent) {
      final isValidZipCode = await _isValidZipCode(event.zipCode);
      final isValidLawnSize = _isValidLawnSize(event.lawnSize);

      if (!isValidZipCode && !isValidLawnSize) {
        yield state.copyWith(
          lawnSizeError: invalidLawnSizeError,
          zipCodeError: invalidZipCodeError,
        );
      } else if (!isValidZipCode) {
        yield state.copyWith(
          lawnSizeError: null,
          zipCodeError: invalidZipCodeError,
        );
      } else if (!isValidLawnSize) {
        yield state.copyWith(
          lawnSizeError: invalidLawnSizeError,
          zipCodeError: null,
        );
      } else {
        yield LawnSizeZipCodeFormSuccessState(
          zipCode: event.zipCode,
          lawnSize: event.lawnSize,
        );
      }
    }
  }

  bool _isValidLawnSize(String lawnSize) {
    return lawnSize != null &&
        lawnSize.isNotEmpty &&
        int.parse(lawnSize) > 0 &&
        int.parse(lawnSize) <= 200000;
  }

  Future<bool> _isValidZipCode(String zipCode) async {
    if (!zipCodePattern.hasMatch(zipCode)) {
      return false;
    }
    try {
      await placesServices.findAddresses(zipCode, types: '(regions)');
    } on PlacesAutoCompleteException {
      return false;
    }
    return true;
  }
}
