import 'package:flutter/foundation.dart';

class AdIds {
  AdIds._();

  // ===========================
  // PRODUÇÃO
  // ===========================

  static const _androidBanner =
      'ca-app-pub-4998370108053217/9006804623';

  static const _androidInterstitial =
      'ca-app-pub-4998370108053217/3825675843';

  // iOS (quando criar)
  static const _iosBanner = '';
  static const _iosInterstitial = '';

  static String get banner {
    if (kIsWeb) {
      throw UnsupportedError(
        'BannerAd não é suportado na Web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidBanner;
      case TargetPlatform.iOS:
        if (_iosBanner.isEmpty) {
          throw UnsupportedError(
            'ID de Banner para iOS não configurado.',
          );
        }
        return _iosBanner;
      default:
        throw UnsupportedError(
          'Plataforma não suportada.',
        );
    }
  }

  static String get interstitial {
    if (kIsWeb) {
      throw UnsupportedError(
        'InterstitialAd não é suportado na Web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidInterstitial;
      case TargetPlatform.iOS:
        if (_iosInterstitial.isEmpty) {
          throw UnsupportedError(
            'ID de Interstitial para iOS não configurado.',
          );
        }
        return _iosInterstitial;
      default:
        throw UnsupportedError(
          'Plataforma não suportada.',
        );
    }
  }
}