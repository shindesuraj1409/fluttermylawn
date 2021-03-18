part of 'lawn_size_zip_code_form_bloc.dart';

abstract class LawnSizeZipCodeFormEvent extends Equatable {
  const LawnSizeZipCodeFormEvent();

  @override
  List<Object> get props => [];
}

class SetZipCodeFormEvent extends LawnSizeZipCodeFormEvent {
  final String zipCode;
  const SetZipCodeFormEvent(this.zipCode);

  @override
  List<Object> get props => [zipCode];
}

class SetLawnSizeFormEvent extends LawnSizeZipCodeFormEvent {
  final String lawnSize;
  const SetLawnSizeFormEvent(this.lawnSize);

  @override
  List<Object> get props => [lawnSize];
}

class SubmitFormEvent extends LawnSizeZipCodeFormEvent {
  final String lawnSize;
  final String zipCode;
  const SubmitFormEvent({
    @required this.zipCode,
    @required this.lawnSize,
  });
}
