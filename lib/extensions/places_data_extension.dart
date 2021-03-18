import 'package:my_lawn/data/address_data.dart';
import 'package:my_lawn/data/places/place_details_data.dart';

extension PlacesDetailExtension on PlaceDetails {
  AddressData get addressData {
    // ignore: omit_local_variable_types
    String address1 = '';
    String city;
    String state;
    String zip;
    String country;

    addressComponents.forEach((addressComponent) {
      final types = addressComponent.types;
      if (types.contains('street_number')) {
        address1 = address1 + addressComponent.longName;
      } else if (types.contains('route')) {
        address1 = address1 + ' ' + addressComponent.longName;
      } else if (types.contains('locality')) {
        city = addressComponent.shortName;
      } else if (types.contains('administrative_area_level_1')) {
        state = addressComponent.shortName;
      } else if (types.contains('postal_code')) {
        zip = addressComponent.shortName;
      } else if (types.contains('country')) {
        country = addressComponent.shortName;
      }
    });

    return AddressData(
      address1: address1 ?? '',
      city: city ?? '',
      state: state ?? '',
      zip: zip ?? '',
      country: country ?? '',
    );
  }
}
