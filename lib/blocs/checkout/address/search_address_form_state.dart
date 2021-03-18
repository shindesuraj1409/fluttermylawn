part of 'search_address_form_bloc.dart';

enum FormStatus {
  initial,
  searchingAddress,
  searchingAddressSuccess,
  searchingAddressFailure,
  cancelSearch,
  gettingAddressDetails,
  addressDetailsSuccess,
  addressDetailsError,
  addressDetailsZipMismatchError,
}

class SearchAddressFormState extends Equatable {
  final FormStatus status;
  final List<PlacePrediction> predictions;
  final String errorMessage;
  final AddressData addressData;

  const SearchAddressFormState._({
    FormStatus status,
    List<PlacePrediction> predictions = const [],
    AddressData addressData,
    String errorMessage,
  })  : status = status,
        predictions = predictions,
        addressData = addressData,
        errorMessage = errorMessage;

  SearchAddressFormState.initial() : this._(status: FormStatus.initial);

  SearchAddressFormState.searchingAddress(List<PlacePrediction> predictions)
      : this._(
          status: FormStatus.searchingAddress,
          predictions: predictions,
        );

  SearchAddressFormState.searchingAddressSuccess(
      List<PlacePrediction> predictions)
      : this._(
          status: FormStatus.searchingAddressSuccess,
          predictions: predictions,
        );

  SearchAddressFormState.searchingAddressFailure(String errorMessage)
      : this._(
          status: FormStatus.searchingAddressSuccess,
          errorMessage: errorMessage,
        );

  SearchAddressFormState.cancelSearch()
      : this._(
          status: FormStatus.cancelSearch,
          predictions: [],
        );

  SearchAddressFormState.gettingAddressDetails()
      : this._(
          status: FormStatus.gettingAddressDetails,
        );

  SearchAddressFormState.addressDetailsSuccess(AddressData addressData)
      : this._(
          status: FormStatus.addressDetailsSuccess,
          addressData: addressData,
        );

  SearchAddressFormState.addressDetailsError(String errorMessage)
      : this._(
          status: FormStatus.addressDetailsError,
          errorMessage: errorMessage,
        );

  SearchAddressFormState.addressDetailsZipMismatchError()
      : this._(status: FormStatus.addressDetailsZipMismatchError);

  @override
  List<Object> get props => [
        status,
        predictions,
        addressData,
        errorMessage,
      ];
}
