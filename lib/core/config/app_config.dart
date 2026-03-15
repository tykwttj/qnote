/// Compile-time environment configuration.
///
/// Values are injected via `--dart-define-from-file`.
/// Defaults fall back to test ad IDs (safe for dev).
class AppConfig {
  AppConfig._();

  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static const String admobAppIdIos = String.fromEnvironment(
    'ADMOB_APP_ID_IOS',
    defaultValue: 'ca-app-pub-3940256099942544~1458002511',
  );

  static const String admobAppIdAndroid = String.fromEnvironment(
    'ADMOB_APP_ID_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544~3347511713',
  );

  static const String bannerAdUnitIdAndroid = String.fromEnvironment(
    'BANNER_AD_UNIT_ID_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  static const String bannerAdUnitIdIos = String.fromEnvironment(
    'BANNER_AD_UNIT_ID_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );

  static const String interstitialAdUnitIdAndroid = String.fromEnvironment(
    'INTERSTITIAL_AD_UNIT_ID_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/1033173712',
  );

  static const String interstitialAdUnitIdIos = String.fromEnvironment(
    'INTERSTITIAL_AD_UNIT_ID_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/4411468910',
  );

  static bool get isDev => env == 'dev';
  static bool get isProd => env == 'prod';
}
