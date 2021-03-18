import 'package:bus/bus.dart';
import 'package:data/data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/services/store_locator/store_locator_response.dart';
import 'package:my_lawn/services/store_locator/store_locator_service.dart';
import 'package:pedantic/pedantic.dart';

// This is "Scotts" sellerId on PriceSpider which
// can be used to identify "Scotts" from other sellers.
const _scottsSellerId = 6475251;

class OnlineStoreLocatorModel with Bus {
  final StoreLocatorService _locatorService;
  OnlineStoreLocatorModel() : _locatorService = registry<StoreLocatorService>();

  @override
  void onInit() {
    super.onInit();
    publish(data: OnlineStoresData.initial());
  }

  Future<void> searchSellers(String productId) async {
    try {
      publish(data: OnlineStoresData.loading());
      var sellers = await _locatorService.getOnlineStores(productId);

      // Check if "Scotts" is present in list of sellers
      final scotts = sellers.firstWhere(
        (seller) => seller.id != null && seller.id == _scottsSellerId,
        orElse: () => null,
      );

      // If it is present, we move it to top of the sellers list
      if (scotts != null) {
        final restOfSellers =
            sellers.where((seller) => seller.id != scotts.id).toList();

        sellers = [scotts, ...restOfSellers];

        // Set "containScotts" flag to "true" to be used by UI.
        publish(data: OnlineStoresData.success(sellers, containsScotts: true));
      } else {
        publish(data: OnlineStoresData.success(sellers));
      }
    } on StoreLocatorException catch (error) {
      publish(data: OnlineStoresData.error(error.reason));
      unawaited(
          FirebaseCrashlytics.instance.recordError(error, StackTrace.current));
    } catch (error) {
      log.warning('Error fetching online sellers ${error.toString()}');
      publish(
          data:
              OnlineStoresData.error('Something went wrong. Please try again'));
      unawaited(
          FirebaseCrashlytics.instance.recordError(error, StackTrace.current));
    }
  }

  @override
  @override
  List<Channel> get channels => [Channel(OnlineStoresData)];
}

class OnlineStoresData extends Data {
  final List<OnlineSeller> sellers;
  final bool containsScotts;
  final OnlineStoreState state;
  final String errorMessage;

  OnlineStoresData({
    this.sellers,
    this.containsScotts,
    this.state,
    this.errorMessage,
  });

  OnlineStoresData.initial()
      : sellers = null,
        containsScotts = false,
        state = OnlineStoreState.initial,
        errorMessage = null;

  OnlineStoresData.loading()
      : sellers = null,
        containsScotts = false,
        state = OnlineStoreState.loading,
        errorMessage = null;

  OnlineStoresData.error(String errorMessage)
      : sellers = null,
        containsScotts = false,
        state = OnlineStoreState.error,
        errorMessage = errorMessage;

  OnlineStoresData.success(List<OnlineSeller> sellers, {containsScotts = false})
      : sellers = sellers,
        containsScotts = containsScotts,
        state = OnlineStoreState.success,
        errorMessage = null;

  @override
  List<Object> get props => [sellers, state];
}

enum OnlineStoreState { initial, loading, success, error }
