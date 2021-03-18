part of 'lawn_size_zip_code_form_bloc.dart';

class LawnSizeZipCodeFormState extends Equatable {
  final String zipCodeError;
  final String lawnSizeError;
  final String zipCode;
  final String lawnSize;

  const LawnSizeZipCodeFormState({
    this.zipCodeError,
    this.lawnSizeError,
    this.zipCode,
    this.lawnSize,
  });

  const LawnSizeZipCodeFormState.initial()
      : zipCodeError = null,
        lawnSizeError = null,
        zipCode = '',
        lawnSize = '';

  LawnSizeZipCodeFormState copyWith({
    String zipCodeError,
    String lawnSizeError,
    String zipCode,
    String lawnSize,
  }) {
    return LawnSizeZipCodeFormState(
      zipCodeError: zipCodeError,
      lawnSizeError: lawnSizeError,
      zipCode: zipCode ?? this.zipCode,
      lawnSize: lawnSize ?? this.lawnSize,
    );
  }

  @override
  List<Object> get props => [zipCode, lawnSize, zipCodeError, lawnSizeError];
}

class LawnSizeZipCodeFormSuccessState extends LawnSizeZipCodeFormState {
  @override
  final String zipCode;
  @override
  final String lawnSize;
  const LawnSizeZipCodeFormSuccessState({
    this.zipCode,
    this.lawnSize,
  });

  @override
  List<Object> get props => [zipCode, lawnSize];
}
