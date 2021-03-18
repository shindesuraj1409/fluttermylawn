import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:local_storage/local_storage.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/user_data.dart';

const String USER = 'user';
const String LAWN_DATA = 'lawn_data';
const String GIGYA_TOKEN = 'gigya_token';
const String SCOTTS_TOKEN = 'scotts_token';
const String LOGGED_IN_PATH = 'logged_in_path';
const String PREVIOUS_RECOMMENDATION_COUNT = 'previous_recommendation_count';

class SessionManager {
  LocalStorage localStorage;
  LocalStorage secureLocalStorage;
  SessionManager(this.localStorage, this.secureLocalStorage);

  void setUser(User user) async {
    try {
      final userMap = await localStorage.readMap(USER);

      var userToSave = user;

      if (userMap != null) {
        final cachedUser = User.fromJson(userMap);
        userToSave = cachedUser.copyWithUser(user);
      }

      await localStorage.writeMap(USER, userToSave.toJson());
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      final userMap = await localStorage.readMap(USER);

      final user = User.fromJson(userMap);
      return user;
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  void setLawnData(LawnData lawnData) async {
    try {
      final lawnDataMap = await localStorage.readMap(LAWN_DATA);

      var lawnDataToSave = lawnData;

      if (lawnDataMap != null && lawnDataMap.isNotEmpty) {
        final cachedLawnData = LawnData.fromJson(lawnDataMap);

        if (lawnData.lawnAddress != null &&
            cachedLawnData.lawnAddress != null) {
          var combinedAddress;
          // Need to check this because we are just getting ZipCode
          // from the server so we need to copy rest of fields if it
          // matches.
          if (lawnData.lawnAddress.zip == cachedLawnData.lawnAddress.zip) {
            combinedAddress = cachedLawnData.lawnAddress
                .copyWith(addressData: lawnData.lawnAddress);
          } else {
            combinedAddress =
                cachedLawnData.lawnAddress.copyNewData(lawnData.lawnAddress);
          }

          lawnData = lawnData.copyWith(lawnAddress: combinedAddress);
        }

        lawnDataToSave = cachedLawnData.copyWithLawnData(lawnData);
      }

      await localStorage.writeMap(LAWN_DATA, lawnDataToSave.toJson());
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<LawnData> getLawnData() async {
    try {
      final lawnProfileMap = await localStorage.readMap(LAWN_DATA);
      return LawnData.fromJson(lawnProfileMap);
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  void setScottsToken(String idToken) async {
    await secureLocalStorage.write(SCOTTS_TOKEN, idToken);
  }

  Future<String> getScottsToken() async {
    return await secureLocalStorage.read(SCOTTS_TOKEN);
  }

  void setGigyaToken(String idToken) async {
    await secureLocalStorage.write(GIGYA_TOKEN, idToken);
  }

  Future<String> getGigyaToken() async {
    return await secureLocalStorage.read(GIGYA_TOKEN);
  }

  void setLoggedInPath(String path) async {
    await secureLocalStorage.write(LOGGED_IN_PATH, path);
  }

  Future<String> getLoggedInPath() async {
    return await secureLocalStorage.read(LOGGED_IN_PATH);
  }

  void setPreviousRecommendationProductCount(int count) async {
    await localStorage.write(PREVIOUS_RECOMMENDATION_COUNT, '$count');
  }

  Future<int> getPreviousRecommendationProductCount() async {
    final countString = await localStorage.read(PREVIOUS_RECOMMENDATION_COUNT);
    return countString == null ? null : int.tryParse(countString);
  }

  void clearAll() async {
    // Get environment value from localstorage
    // before clearing it out entirely.
    final environmentStored = await localStorage.read('environment');

    // Clear storage
    await localStorage.deleteAll();
    await secureLocalStorage.deleteAll();

    // Restore environment value in localstorage
    // if it was not null previously
    if (environmentStored != null) {
      await localStorage.write('environment', environmentStored);
    }
  }
}
