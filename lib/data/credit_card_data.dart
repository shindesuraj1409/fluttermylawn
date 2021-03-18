import 'package:data/data.dart';

class CreditCardData extends Data {
  final String number;
  final String expiration;
  final String cvv;

  CreditCardData({
    String number,
    String expiration,
    String cvv,
  })  : number = _ensureDigitsOnly(number),
        expiration = _ensureDigitsOnly(expiration),
        cvv = _ensureDigitsOnly(cvv);

  static String _ensureDigitsOnly(String string) =>
      string?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';

  bool isNotEmpty() =>
      number.isNotEmpty && expiration.isNotEmpty && cvv.isNotEmpty;

  CreditCardData copyWith({
    String number,
    String expiration,
    String cvv,
  }) =>
      CreditCardData(
        number: number ?? this.number,
        expiration: expiration ?? this.expiration,
        cvv: cvv ?? this.cvv,
      );

  @override
  List<Object> get props => [
        number,
        expiration,
        cvv,
      ];
}
