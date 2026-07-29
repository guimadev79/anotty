import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  AdHelper._();

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();

    debugPrint('✅ Google Mobile Ads inicializado.');
  }
}