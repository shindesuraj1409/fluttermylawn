import 'package:my_lawn/services/auth/social/apple_social_provider.dart';
import 'package:my_lawn/services/auth/social/facebook_social_provider.dart';
import 'package:my_lawn/services/auth/social/google_social_provider.dart';
import 'package:my_lawn/services/auth/social/i_social_provider.dart';

import 'i_social_provider_factory.dart';

enum SocialService { GOOGLE, FB, APPLE }

class SocialProviderFactoryImpl extends SocialProviderFactory {
  @override
  SocialProvider createInstance(SocialService socialService) {
    SocialProvider provider;

    switch (socialService) {
      case SocialService.APPLE:
        provider = AppleSocialProvider();
        break;
      case SocialService.FB:
        provider = FacebookSocialProvider();
        break;
      case SocialService.GOOGLE:
        provider = GoogleSocialProvider();
        break;
    }

    return provider;
  }
}
