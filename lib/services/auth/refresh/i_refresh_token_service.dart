abstract class RefreshTokenService {
  Future<void> refresh();
  Future<void> refreshGigyaToken();
  Future<void> authenticate();
}
