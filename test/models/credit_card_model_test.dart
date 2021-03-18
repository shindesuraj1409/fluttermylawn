import 'package:intl/intl.dart';
import 'package:my_lawn/data/credit_card_data.dart';
import 'package:my_lawn/models/credit_card_model.dart';
import 'package:test/test.dart';

void main() {
  final creditCardModel = CreditCardModel();

  group('methods', () {
    test('.hasValidNumber()', () {
      // VISA
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '4111 1111 1111 1111'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '4111 1111 1111 1112'),
        ),
        isFalse,
      );

      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '4999 9999 9999 9996'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '4999 9999 9999 9997'),
        ),
        isFalse,
      );
      // MasterCard
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5165 4050 7470 5808'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5165 4050 7470 5809'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5287 6613 1493 3773'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5287 6613 1493 3774'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5395 0019 7878 9618'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '5395 0019 7878 9619'),
        ),
        isFalse,
      );
      // American Express
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '3464 740545 27627'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '3464 740545 27628'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '3788 885173 86019'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '3788 885173 86010'),
        ),
        isFalse,
      );
      // Unknown
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '6011 7871 3525 9881'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidNumber(
          CreditCardData(number: '6011 7871 3525 9882'),
        ),
        isFalse,
      );
    });

    test('.issuer()', () {
      // VISA
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '4111 1111 1111 1111'),
        ),
        equals(CreditCardIssuer.visa16),
      );
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '4999 9999 9999 9996'),
        ),
        equals(CreditCardIssuer.visa16),
      );
      // MasterCard
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '5165 4050 7470 5808'),
        ),
        equals(CreditCardIssuer.mastercard16),
      );
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '5287 6613 1493 3773'),
        ),
        equals(CreditCardIssuer.mastercard16),
      );
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '5395 0019 7878 9618'),
        ),
        equals(CreditCardIssuer.mastercard16),
      );
      // American Express
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '3464 740545 27627'),
        ),
        equals(CreditCardIssuer.americanExpress15),
      );
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '3788 885173 86019'),
        ),
        equals(CreditCardIssuer.americanExpress15),
      );
      // Unknown
      expect(
        creditCardModel.issuer(
          CreditCardData(number: '6011 7871 3525 9881'),
        ),
        equals(CreditCardIssuer.unknown),
      );
    });

    test('.hasValidExpiration()', () {
      final now = DateTime.now();
      final muchMuchMuchEarlier = now.subtract(Duration(days: 5000));
      final muchMuchEarlier = now.subtract(Duration(days: 2500));
      final muchEarlier = now.subtract(Duration(days: 500));
      final earlier = now.subtract(Duration(days: 50));
      final later = now.add(Duration(days: 50));
      final muchLater = now.add(Duration(days: 500));
      final muchMuchLater = now.add(Duration(days: 2500));
      final muchMuchMuchLater = now.add(Duration(days: 5000));

      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: ''),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '1'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '123D'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '13 / 50'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '1350'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '12 / 50'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: '1250'),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(
              expiration: DateFormat('MM / yy').format(muchMuchMuchEarlier)),
        ),
        isTrue, // this one is so far back, we assume it's in the next century
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(
              expiration: DateFormat('MM / yy').format(muchMuchEarlier)),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: DateFormat('MM / yy').format(muchEarlier)),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: DateFormat('MM / yy').format(earlier)),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: DateFormat('MM / yy').format(now)),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: DateFormat('MM / yy').format(later)),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(expiration: DateFormat('MM / yy').format(muchLater)),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(
              expiration: DateFormat('MM / yy').format(muchMuchLater)),
        ),
        isTrue,
      );
      expect(
        creditCardModel.hasValidExpiration(
          CreditCardData(
              expiration: DateFormat('MM / yy').format(muchMuchMuchLater)),
        ),
        isTrue,
      );
    });

    test('.hasValidCvv()', () {
      expect(
        creditCardModel.hasValidCvv(
          CreditCardData(),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidCvv(
          CreditCardData(cvv: ''),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidCvv(
          CreditCardData(cvv: '1'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidCvv(
          CreditCardData(cvv: '12C'),
        ),
        isFalse,
      );
      expect(
        creditCardModel.hasValidCvv(
          CreditCardData(cvv: '123'),
        ),
        isTrue,
      );
    });
  });
}
