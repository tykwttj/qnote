import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qnote/core/constants/app_constants.dart';

class AdService {
  BannerAd? _homeBannerAd;
  BannerAd? _editorBannerAd;
  InterstitialAd? _interstitialAd;

  int _returnCount = 0;
  DateTime? _lastInterstitialTime;
  int _memoCount = 0;
  bool _isPro = false;

  bool get isPro => _isPro;

  static String get bannerAdUnitId => Platform.isAndroid
      ? AppConstants.bannerAdUnitIdAndroid
      : AppConstants.bannerAdUnitIdIos;

  static String get interstitialAdUnitId => Platform.isAndroid
      ? AppConstants.interstitialAdUnitIdAndroid
      : AppConstants.interstitialAdUnitIdIos;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  void updateState({required int memoCount, required bool isPro}) {
    _memoCount = memoCount;
    _isPro = isPro;
  }

  bool get _shouldShowAds => !_isPro && _memoCount >= AppConstants.adsFreeMemoCount;

  // --- Banner Ads ---

  BannerAd? get homeBannerAd => _homeBannerAd;
  BannerAd? get editorBannerAd => _editorBannerAd;

  void loadHomeBanner({VoidCallback? onLoaded}) {
    if (!_shouldShowAds) return;
    _homeBannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Home banner failed: $error');
          ad.dispose();
          _homeBannerAd = null;
        },
      ),
    )..load();
  }

  void loadEditorBanner({VoidCallback? onLoaded}) {
    if (!_shouldShowAds) return;
    _editorBannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Editor banner failed: $error');
          ad.dispose();
          _editorBannerAd = null;
        },
      ),
    )..load();
  }

  // --- Interstitial Ads ---

  void preloadInterstitial() {
    if (!_shouldShowAds) return;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Call when user returns to home from editor.
  /// Shows interstitial every [interstitialFrequency] returns
  /// with a minimum [interstitialMinInterval] between shows.
  void onReturnToHome() {
    if (!_shouldShowAds) return;
    _returnCount++;

    if (_returnCount % AppConstants.interstitialFrequency != 0) return;

    final now = DateTime.now();
    if (_lastInterstitialTime != null &&
        now.difference(_lastInterstitialTime!) <
            AppConstants.interstitialMinInterval) {
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitial();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          preloadInterstitial();
        },
      );
      _interstitialAd!.show();
      _lastInterstitialTime = now;
    } else {
      preloadInterstitial();
    }
  }

  void dispose() {
    _homeBannerAd?.dispose();
    _editorBannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
