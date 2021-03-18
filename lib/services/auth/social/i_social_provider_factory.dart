import 'package:my_lawn/services/auth/social/i_social_provider.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';

abstract class SocialProviderFactory {
  SocialProvider createInstance(SocialService socialService);
}
