import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/credit_card_data.dart';

abstract class RecurlyService {
  Future<String> getToken(
    AddressData billingAddress,
    CreditCardData creditCardData,
  );
}
