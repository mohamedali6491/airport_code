import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2732592729996145/3644520946'; // real ad unit id
      //'ca-app-pub-3940256099942544/6300978111'; // test ad unit id
    }
    // else if (Platform.isIOS) {
    //   return 'ca-app-pub-3940256099942544/2934735716';
    // }
    return null;
  }

  static BannerAdListener bannerLisrener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opend'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
  );
}
