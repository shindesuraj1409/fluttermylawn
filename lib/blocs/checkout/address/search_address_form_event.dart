part of 'search_address_form_bloc.dart';

abstract class AddressFormEvent extends Equatable {
  const AddressFormEvent();

  @override
  List<Object> get props => [];
}

class SearchAddressEvent extends AddressFormEvent {
  final String searchText;
  SearchAddressEvent(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class GetAddressDetailsEvent extends AddressFormEvent {
  final String placeId;
  final String validZipCode;
  GetAddressDetailsEvent({
    @required this.placeId,
    @required this.validZipCode,
  });

  @override
  List<Object> get props => [placeId, validZipCode];
}

class CancelSearchEvent extends AddressFormEvent {
  const CancelSearchEvent();
}