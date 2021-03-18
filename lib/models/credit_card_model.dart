import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:my_lawn/data/credit_card_data.dart';

enum CreditCardIssuer {
  unknown,
  americanExpress15,
  dinersClub16,
  mastercard16,
  visa16,
}

class CreditCardValidity extends Data {
  final bool isNumberValid;
  final bool isExpirationValid;
  final bool isCvvValid;

  CreditCardValidity({
    this.isNumberValid = false,
    this.isExpirationValid = false,
    this.isCvvValid = false,
  });

  bool get isValid => isNumberValid && isExpirationValid && isCvvValid;

  @override
  List<Object> get props => [isNumberValid, isExpirationValid, isCvvValid];
}

extension _StringToDigits on String {
  List<int> get digits =>
      codeUnits.map((codeUnit) => codeUnit - 0x0030).toList();
  int prefix(int length) =>
      length > this.length ? null : int.tryParse(substring(0, length));
}

class CreditCardModel with Bus {
  final CreditCardData initialCreditCardData;

  CreditCardModel({this.initialCreditCardData});

  @override
  void onInit() {
    publish(data: initialCreditCardData ?? CreditCardData());
    publish(data: CreditCardIssuer.unknown);
    publish(data: CreditCardValidity());

    stream<CreditCardData>().takeWhile((_) => isInitialized).forEach(
      (creditCard) {
        publish(data: issuer(creditCard));
        publish(
          data: CreditCardValidity(
            isNumberValid: hasValidNumber(creditCard),
            isExpirationValid: hasValidExpiration(creditCard),
            isCvvValid: hasValidCvv(creditCard),
          ),
        );
      },
    );
  }

  // https://en.wikipedia.org/wiki/Payment_card_number
  // This really should use a trie instead, at least if we wanted to evaluate
  // more issuer identification numbers, but this gets the job done.
  CreditCardIssuer issuer(CreditCardData creditCard) {
    final prefix1 = creditCard.number.prefix(1);
    if (prefix1 == 4) {
      return CreditCardIssuer.visa16;
    }

    final prefix2 = creditCard.number.prefix(2);
    switch (prefix2) {
      case 34:
      case 37:
        return CreditCardIssuer.americanExpress15;
      case 51:
      case 52:
      case 53:
        return CreditCardIssuer.mastercard16;
      case 54:
      case 55:
        return CreditCardIssuer.dinersClub16;
    }

    final prefix4 = creditCard.number.prefix(4);
    if (prefix4 != null && prefix4 >= 2221 && prefix4 <= 2720) {
      return CreditCardIssuer.mastercard16;
    }

    return CreditCardIssuer.unknown;
  }

  /// Uses the Luhn algorithm to verify the credit card number.
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  bool hasValidNumber(CreditCardData creditCard) {
    final digits = creditCard.number.digits.reversed.toList();

    if (digits.isEmpty || digits.length < 13) {
      return false;
    }

    final checkDigit = digits.first;

    var sum = 0;

    for (var i = 1; i < digits.length; i++) {
      var digit = digits[i];
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
    }

    sum *= 9;
    sum %= 10;

    return sum == checkDigit;
  }

  bool hasValidExpiration(CreditCardData creditCard) {
    if (creditCard.expiration.length != 4) {
      return false;
    }
    final month = int.tryParse(creditCard.expiration.substring(0, 2));
    if (month == null || month < 1 || month > 12) {
      return false;
    }
    final year = int.tryParse(creditCard.expiration.substring(2));
    if (year == null) {
      return false;
    }

    final now = DateTime.now();
    final fullYear = (now.year ~/ 100) * 100 + year;

    // If year is more than ten years behind, assume next century.
    if (now.year - fullYear > 10) {
      return true;
    }

    if (now.year < fullYear) {
      return true;
    } else if (now.year > fullYear) {
      return false;
    } else {
      return now.month <= month;
    }
  }

  bool hasValidCvv(CreditCardData creditCard) => creditCard.cvv.length == 3;

  @override
  List<Channel> get channels => [
        Channel(CreditCardData),
        Channel(CreditCardIssuer),
        Channel(CreditCardValidity),
      ];
}
