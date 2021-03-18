import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'package:my_lawn/services/auth/refresh/i_refresh_token_service.dart';

class RefreshTokenRetryPolicy extends RetryPolicy {
  final RefreshTokenService refreshTokenService;

  RefreshTokenRetryPolicy({RefreshTokenService refreshTokenService})
      : refreshTokenService = refreshTokenService;

  @override
  int get maxRetryAttempts => 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      try {
        await refreshTokenService.refresh();
        return true;
      } catch (e) {
        await FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
        return false;
      }
    }

    return false;
  }
}
