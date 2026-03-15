import '../config/app_config.dart';

/// App-wide constants.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Qnote';
  static const String appVersion = '1.0.0';

  // Memo
  static const int titleMaxLength = 100;
  static const int bodyPreviewLines = 2;

  // Auto-save
  static const Duration autoSaveDuration = Duration(seconds: 1);

  // Search
  static const Duration searchDebounceDuration = Duration(milliseconds: 300);
  static const int maxSearchHistory = 5;

  // Trash
  static const int trashRetentionDays = 30;

  // Ads
  static const int adsFreeMemoCount = 3;
  static const int interstitialFrequency = 3; // Show every N returns
  static const Duration interstitialMinInterval = Duration(seconds: 90);

  // Ad unit IDs — injected via --dart-define-from-file
  static const String bannerAdUnitIdAndroid =
      AppConfig.bannerAdUnitIdAndroid;
  static const String bannerAdUnitIdIos =
      AppConfig.bannerAdUnitIdIos;
  static const String interstitialAdUnitIdAndroid =
      AppConfig.interstitialAdUnitIdAndroid;
  static const String interstitialAdUnitIdIos =
      AppConfig.interstitialAdUnitIdIos;

  // Font sizes
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
}
