import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key, required this.bannerAd});

  final BannerAd? bannerAd;

  @override
  Widget build(BuildContext context) {
    if (bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }
}
