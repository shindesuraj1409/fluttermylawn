import 'package:analytics/analytics.dart';
import 'package:bus/bus.dart';
import 'package:dynamic_links_service/dynamic_links_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_storage/local_storage.dart';
import 'package:localytics_plugin/localytics_plugin.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:my_lawn/blocs/account/update/account_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_bloc.dart';
import 'package:my_lawn/blocs/cart/cart_bloc.dart';
import 'package:my_lawn/blocs/checkout/address/search_address_form_bloc.dart';
import 'package:my_lawn/blocs/checkout/address/shipping_address_bloc.dart';
import 'package:my_lawn/blocs/checkout/confirmation/next_shipment_bloc.dart';
import 'package:my_lawn/blocs/checkout/order/order_bloc.dart';
import 'package:my_lawn/blocs/checkout/payment/payment_bloc.dart';
import 'package:my_lawn/blocs/checkout/summary/summary_bloc.dart';
import 'package:my_lawn/blocs/edit_lawn_profile/edit_lawn_profile_bloc.dart';
import 'package:my_lawn/blocs/faq_bloc/faq_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_bloc.dart';
import 'package:my_lawn/blocs/note/add_note_bloc.dart';
import 'package:my_lawn/blocs/plan_bloc/plan_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/filter/plp_filter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/plp_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_bloc.dart';
import 'package:my_lawn/blocs/product/product_bloc.dart';
import 'package:my_lawn/blocs/single_product/single_product_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancel_subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancelling_reasons/cancelling_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/skipping_reasons/skipping_reasons_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_options/subscription_options_bloc.dart';
import 'package:my_lawn/blocs/subscription/update_billing_info/update_billing_info_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/article_bloc/article_bloc_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/water/water_bloc.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/theme_config.dart';
import 'package:my_lawn/data/app_data.dart';
import 'package:my_lawn/data/connectivity_data.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/models/connectivity_model.dart';
import 'package:my_lawn/models/device_model.dart';
import 'package:my_lawn/models/quiz/quiz_model.dart';
import 'package:my_lawn/models/remote_config_model.dart';
import 'package:my_lawn/models/theme_model.dart';
import 'package:my_lawn/repositories/adobe_user_profile_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_places_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository_impl.dart';
import 'package:my_lawn/services/activities/activities_service.dart';
import 'package:my_lawn/services/activities/i_activities_service.dart';
import 'package:my_lawn/services/analytic/appsflyer_service.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_analytic_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_analytic_service_impl.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_core_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_identity_service.dart';
import 'package:my_lawn/services/analytic/sub_services/adobe_user_profile_service.dart';
import 'package:my_lawn/services/auth/gigya/gigya_service.dart';
import 'package:my_lawn/services/auth/gigya/i_gigya_service.dart';
import 'package:my_lawn/services/auth/i_legacy_user_service.dart';
import 'package:my_lawn/services/auth/legacy_user_service.dart';
import 'package:my_lawn/services/auth/social/i_social_provider_factory.dart';
import 'package:my_lawn/services/auth/social/social_provider_factory.dart';
import 'package:my_lawn/services/cart/cart_service.dart';
import 'package:my_lawn/services/cart/i_cart_service.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';
import 'package:my_lawn/services/contentful/tips/tips_service.dart';
import 'package:my_lawn/services/customer/customer_service.dart';
import 'package:my_lawn/services/customer/i_customer_service.dart';
import 'package:my_lawn/services/deep_links/deep_links.dart';
import 'package:my_lawn/services/deep_links/i_deep_links.dart';
import 'package:my_lawn/services/geo/geo_service.dart';
import 'package:my_lawn/services/geo/i_geo_service.dart';
import 'package:my_lawn/services/localstorage/session_manager.dart';
import 'package:my_lawn/services/notes/i_notes_service.dart';
import 'package:my_lawn/services/notes/notes_service.dart';
import 'package:my_lawn/services/order/i_order_service.dart';
import 'package:my_lawn/services/order/order_service.dart';
import 'package:my_lawn/services/places/adobe_places_monitor.dart';
import 'package:my_lawn/services/places/adobe_places_service.dart';
import 'package:my_lawn/services/places/i_places_service.dart';
import 'package:my_lawn/services/places/places_api_client.dart';
import 'package:my_lawn/services/places/places_service.dart';
import 'package:my_lawn/services/plan/i_plan_service.dart';
import 'package:my_lawn/services/plan/plan_service_imp.dart';
import 'package:my_lawn/services/products/i_products_service.dart';
import 'package:my_lawn/services/products/products_service_impl.dart';
import 'package:my_lawn/services/recommendation/i_recommendation_service.dart';
import 'package:my_lawn/services/recommendation/recommendation_service.dart';
import 'package:my_lawn/services/recurly/i_recurly_service.dart';
import 'package:my_lawn/services/recurly/recurly_service.dart';
import 'package:my_lawn/services/single_product/single_product_service_impl.dart';
import 'package:my_lawn/services/store_locator/store_locator_service.dart';
import 'package:my_lawn/services/subscription/cancel_subscription/cancel_subscription_service.dart';
import 'package:my_lawn/services/subscription/find_subscription_by_customerid/find_subscription_by_customerid_service.dart';
import 'package:my_lawn/services/subscription/modify_subscription/modify_subscription_service.dart';
import 'package:my_lawn/services/subscription/order_details/order_details_service.dart';
import 'package:my_lawn/services/water/i_water_model_service.dart';
import 'package:my_lawn/services/water/water_model_service.dart';
import 'package:my_lawn/utils/CustomLoggingOutput.dart';
import 'package:navigation/navigation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:registry/registry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class RegistryConfig {
  static const TRANS_ID = 'trans_id';
}

final CustomLoggingOutput _customLoggingOutput = CustomLoggingOutput();
final Logger _logger = Logger(
  output: _customLoggingOutput,
  printer: PrettyPrinter(printTime: true),
);

const _storageKeyAppData = 'appData';

Registry get registry => Registry.instance;

B _busRegistry<B extends Bus>({String busName}) => registry<B>(name: busName);

Future<void> configureModels() async {
  // Register log model before we do anything else.
  LogConsole.init();
  registry.register(
    instance: _customLoggingOutput,
  );
  registry.register(
    instance: _logger,
  );

  //
  registry.register<LocalStorage>(
      instance: SecureLocalStorage(), name: 'secure');
  registry.register<LocalStorage>(
      instance: InsecureLocalStorage(), name: 'insecure');

  registry.register<SessionManager>(
      instance: SessionManager(
    registry.call<LocalStorage>(name: 'insecure'),
    registry.call<LocalStorage>(name: 'secure'),
  ));

  await registry.register(
    instance: EnvironmentConfig(
      registry<LocalStorage>(name: 'insecure'),
      registry<SessionManager>(),
    )..registerApiClients(),
  );

  // register analytic before splash building, to be able to send analytic about splash
  registerAdobeAnalytic();
  registerAdobeUserAnalytic();

  // Switch Adobe right away, so it's configured before app restart.
  await registry<EnvironmentConfig>().configureAdobeAnalytics();

  // Configure the global bus registry.
  globalBusRegistry = _busRegistry;

  // --- --  -

  registry.register(
      instance: RemoteConfigModel(
    remoteConfig: await RemoteConfig.instance,
    // https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
    debugMode: kDebugMode,
  ));
  // We must await this here, to later display the correct initial screen.

  await registry<RemoteConfigModel>().updateRemoteConfig();

  // --- --  -

  registry.register(
    instance: ThemeModel(themeData: ThemeConfig.lightTheme),
  );

  // --- --  -

  registry.register(
    instance: DynamicLinksService(),
  );

  // --- --  -

  registry.registerLazy(
    () => Geolocation(),
  );

  // --- --  -

  registry.register(
    instance: Navigation(),
  );

  // --- --  -

  registry.register(
    instance: DeviceModel(),
  );

  // --- --  -

  registry.register<DeepLinks>(
    instance: DeepLinksImpl(),
  );

  // --- --  -

  registry.register(
    instance: AppModel(),
  );

  unawaited(busStream<AppModel, AppData>().distinct().forEach(
    (appData) {
      // Write updates to storage.
      registry.call<LocalStorage>(name: 'secure').writeMap(
            _storageKeyAppData,
            appData.toMap(),
          );
      // Apply chosen app theme.
      busPublish<ThemeModel, ThemeData>(data: ThemeConfig.lightTheme);
    },
  ));

  final appDataMap = await registry
      .call<LocalStorage>(name: 'secure')
      .readMap(_storageKeyAppData);
  busPublish<AppModel, AppData>(
    data: AppData(
      isFirstRun: appDataMap['isFirstRun'],
      isDarkModeEnabled: false,
    ),
  );

  registry.register(instance: ConnectivityModel());

  // Keep track of Internet connectivity.
  unawaited(busStream<ConnectivityModel, ConnectivityData>()
      // Wait until navigation is up and running.
      .skipUntil(busStream<Navigation, NavigationData>())
      .forEach((connectivityData) {
    const connectivityRouteName = '/connectivity';
    if (connectivityData.isValid) {
      if (!connectivityData.hasInternet) {
        registry<Navigation>().push(connectivityRouteName);
      } else if (busSnapshot<Navigation, NavigationData>().currentRouteName ==
          connectivityRouteName) {
        registry<Navigation>().pop();
      }
    }
  }));
  // Wait for first route, then request connectivity update.
  unawaited(busStream<Navigation, NavigationData>()
      .skipWhile((data) => data.currentRouteName == null)
      .first
      .then((_) {
    registry<ConnectivityModel>().requestUpdate();
  }));

  // --- --  -

  registry.register(initializer: () {
    final analytics = Analytics();

    // Don't log /, used to reroute to whichever root screen makes sense.
    analytics.excludeScreen('/');

    return analytics;
  });

  // Lawn Address Screen deps
  registry.register<Geolocator>(instance: Geolocator());
  registry.register<Location>(instance: Location());
  registry.registerFactory<PlacesService>(() => PlacesServiceImpl(
        registry<PlacesApiClient>(),
        registry<Location>(),
        registry<Geolocator>(),
      ));
  registry.registerFactory<GeoService>(() => GeoServiceImpl());
  // --- --  -

  setFirebaseCustomKeys();

  registry.register<LocalyticsService>(instance: LocalyticsService());

  registry.register<AuthenticationBloc>(instance: AuthenticationBloc());
  registry
      .registerFactory<StoreLocatorService>(() => StoreLocatorServiceImpl());

  registry.register<RecommendationService>(
      instance: RecommendationServiceImpl());

  registry.registerFactory<LocalyticsPlugin>(() => LocalyticsPlugin());

  registry.register<ProductsService>(instance: ProductsServiceImpl());
  registry.register<ActivitiesService>(instance: ActivitiesServiceImpl());
  registry.register<TipsService>(instance: TipsServiceImpl());
  registry.register<TipsBloc>(instance: TipsBloc());
  registry.register<TipsFilterBloc>(instance: TipsFilterBloc());

  registry.register<FaqBloc>(instance: FaqBloc());

  registry.register<CancellingReasonsBloc>(instance: CancellingReasonsBloc());

  registry.register<SkippingReasonsBloc>(instance: SkippingReasonsBloc());

  registry.register<HelpBloc>(instance: HelpBloc());

  registry.registerFactory<ActivityBloc>(() => ActivityBloc(
      activitiesService: registry<ActivitiesService>(),
      sessionManager: registry<SessionManager>()));

  registry.register<CustomerService>(instance: CustomerServiceImpl());
  registry.registerFactory<NotesService>(() => NotesServiceImpl());

  registry.register<RecurlyService>(
    instance: RecurlyServiceImpl(),
  );

  registry.register<GigyaService>(instance: GigyaServiceImpl());
  registry.registerFactory<LegacyUserService>(
    () => LegacyUserServiceImpl(
      registry<GigyaService>(),
      registry.call<LocalStorage>(name: 'insecure'),
      registry<Analytics>(),
    ),
  );

  registry.register<SocialProviderFactory>(
      instance: SocialProviderFactoryImpl());
  registerFindSubscriptionByCustomerIdDeps();
  registry.register<LoginBloc>(instance: LoginBloc());

  registry.register<PlanService>(instance: PlanServiceImpl());

  registry.registerFactory<PlpBloc>(() => PlpBloc());
  registry.registerFactory<PlpSearchBloc>(() => PlpSearchBloc());
  registry.registerFactory<PlpFilterBloc>(() =>
      PlpFilterBloc(geoService: registry(), recommendationService: registry()));

  registry.register<AddNoteBloc>(
    instance:
        AddNoteBloc(registry<NotesService>(), registry<AuthenticationBloc>()),
  );

  registry.register<CalendarBloc>(
    instance: CalendarBloc(
      notesService: registry<NotesService>(),
      activitiesService: registry<ActivitiesService>(),
      sessionManager: registry<SessionManager>(),
    ),
  );

  registry.register<AppsFlyerService>(instance: AppsFlyerService());

  registerSubscriptionOptionsScreenDeps();
  registerCartScreenDeps();
  registerCheckOutScreenDeps();
  registerCancelSubscriptionDeps();
  registerWaterBlocDeps();
  registerArticleDeps();
  registerSingleProductDeps();
  registerOrderDetailsDeps();

  //TODO: Punit refactor to bloc
  registry.register<QuizModel>(instance: QuizModel());

  registerEditLawnProfileScreenDeps();
  registerAccountScreenDeps();

  registerUpdateBillingInfoScreenDeps();

  registerAdobePlacesAnalytic();

  registry.register<PlanBloc>(
    instance: PlanBloc(
      recommendationService: registry(),
      subscriptionService: registry(),
      activitiesService: registry(),
      authenticationBloc: registry(),
    ),
  );

  registry.registerFactory<ProductBloc>(
    () => ProductBloc(
      recommendationService: registry(),
      subscriptionService: registry(),
      activitiesService: registry(),
      productService: registry(),
      planService: registry(),
      sessionManager: registry(),
    ),
  );
}

void registerSubscriptionOptionsScreenDeps() {
  registry
      .registerFactory<SubscriptionOptionsBloc>(() => SubscriptionOptionsBloc(
            service: registry(),
            recommendationStream:
                registry<RecommendationService>().recommendationStream,
          ));
}

void registerCartScreenDeps() {
  registry.registerFactory<CartService>(() => CartServiceImpl());
  registry.registerFactory<CartBloc>(() => CartBloc(registry()));
}

void registerCheckOutScreenDeps() {
  registry.registerFactory<OrderService>(() => OrderServiceImpl());
  registry.registerFactory<ShippingAddressBloc>(
      () => ShippingAddressBloc(registry()));
  registry.registerFactory<SearchAddressFormBloc>(
      () => SearchAddressFormBloc(registry<PlacesService>()));
  registry
      .registerFactory<PaymentBloc>(() => PaymentBloc(registry(), registry()));
  registry
      .registerFactory<OrderSummaryBloc>(() => OrderSummaryBloc(registry()));
  registry.registerFactory<OrderBloc>(() => OrderBloc(registry()));
  registry.registerFactory<NextShipmentBloc>(
      () => NextShipmentBloc(service: registry(), adobeRepository: registry()));
}

void registerCancelSubscriptionDeps() {
  registry.registerFactory<CancelSubscriptionService>(
      () => CancelSubscriptionServiceImpl());
  registry.registerFactory<CancelSubscriptionBloc>(
      () => CancelSubscriptionBloc(registry()));
}

void registerArticleDeps() {
  registry.registerFactory<ArticleBloc>(() => ArticleBloc(registry()));
}

void registerSingleProductDeps() {
  registry
      .registerFactory<SingleProductService>(() => SingleProductServiceImpl());
  registry
      .registerFactory<SingleProductBloc>(() => SingleProductBloc(registry()));
}

void registerOrderDetailsDeps() {
  registry
      .registerFactory<OrderDetailsService>(() => OrderDetailsServiceImpl());
  registry.register<OrderDetailsBloc>(instance: OrderDetailsBloc(registry()));
}

void registerFindSubscriptionByCustomerIdDeps() {
  registry.register<FindSubscriptionsByCustomerIdService>(
      instance: FindSubscriptionsByCustomerIdServiceImpl());
  registry.register<ModifySubscriptionService>(
      instance: ModifySubscriptionServiceImpl());
  registry.register<SubscriptionBloc>(
      instance: SubscriptionBloc(registry(), registry()));
}

void registerWaterBlocDeps() {
  registry.registerFactory<WaterModelService>(() => WaterModelServiceImpl());
  registry.register<WaterBloc>(instance: WaterBloc(registry()));
}

void registerAccountScreenDeps() {
  registry.registerFactory<AccountBloc>(() => AccountBloc(
      registry<CustomerService>(),
      registry<SessionManager>(),
      registry<GigyaService>(),
      registry<AuthenticationBloc>().state.user));
}

void registerEditLawnProfileScreenDeps() {
  registry.registerFactory<EditLawnProfileBloc>(
    () => EditLawnProfileBloc(
      registry<Navigation>(),
      registry<SessionManager>(),
      registry<WaterModelService>(),
    ),
  );
}

void registerUpdateBillingInfoScreenDeps() {
  registry.registerFactory<UpdateBillingInfoBloc>(
    () => UpdateBillingInfoBloc(
      customerService: registry<CustomerService>(),
      recurlyService: registry<RecurlyService>(),
      sessionManager: registry<SessionManager>(),
    ),
  );
}

void clearCache() {
  registry.unregister<PlanBloc>();
  registry.register<PlanBloc>(
      instance: PlanBloc(
    recommendationService: registry(),
    subscriptionService: registry(),
    activitiesService: registry(),
    authenticationBloc: registry(),
  ));
}

void setFirebaseCustomKeys() {
  registry.unregister<String>(name: RegistryConfig.TRANS_ID);
  registry.register<String>(
    name: RegistryConfig.TRANS_ID,
    instance: Uuid().v4(),
  );

  unawaited(
    FirebaseCrashlytics.instance.setCustomKey(
      'trans_id',
      registry.call<String>(name: RegistryConfig.TRANS_ID),
    ),
  );
  unawaited(
    FirebaseCrashlytics.instance.setCustomKey('source_service', 'MLA'),
  );

  final environmentSelected =
      registry<EnvironmentConfig>().getSelectedEnvironment();

  environmentSelected.then((environment) => {
        unawaited(
          FirebaseCrashlytics.instance
              .setCustomKey('environment', environment.string),
        )
      });
}

void registerAdobePlacesAnalytic() {
  registry.register<AdobePlacesService>(
    instance: AdobePlacesServiceImpl(),
  );

  registry.register<AdobeMonitorPlacesService>(
    instance: AdobeMonitorPlacesServiceImpl(),
  );

  registry.register<AdobePlacesRepository>(
    instance: AdobePlacesRepositoryImpl(
      registry<AdobePlacesService>(),
      registry<AdobeMonitorPlacesService>(),
      registry<PlacesService>(),
    ),
  );
}

void registerAdobeAnalytic() {
  registry.register<AdobeAnalyticService>(
    instance: AdobeAnalyticServiceImpl(),
  );

  registry.register<AdobeCoreService>(
    instance: AdobeCoreServiceImpl(),
  );

  registry.register<AdobeRepository>(
    instance: AdobeRepositoryImpl(
      registry<AdobeAnalyticService>(),
      registry<AdobeCoreService>(),
    ),
  );
}

void registerAdobeUserAnalytic() {
  registry.register<AdobeUserProfileService>(
    instance: AdobeUserProfileServiceImpl(),
  );

  registry.register<AdobeIdentityService>(
    instance: AdobeIdentityServiceImpl(),
  );

  registry.register<AdobeUserProfileRepository>(
    instance: AdobeUserProfileRepositoryImpl(
      registry<AdobeUserProfileService>(),
      registry<AdobeIdentityService>(),
    ),
  );
}
