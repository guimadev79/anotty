import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

class InterstitialService {
  InterstitialService._();

  static InterstitialAd? _interstitialAd;

  static bool _isLoading = false;

  /// Contador de ações importantes do usuário.
  static int _actionCounter = 0;

  /// Exibir anúncio a cada X ações.
  static const int _showEvery = 2;

  /// Verifica se existe anúncio carregado.
  static bool get isReady => _interstitialAd != null;

  /// Carrega um anúncio.
  static Future<void> load() async {
    if (_isLoading || _interstitialAd != null) return;

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;

          debugPrint('✅ Intersticial carregado.');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('🎯 Intersticial exibido.');
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('📺 Intersticial fechado.');

              ad.dispose();
              _interstitialAd = null;

              // Pré-carrega o próximo anúncio.
              load();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint(
                '❌ Erro ao exibir intersticial: ${error.message}',
              );

              ad.dispose();
              _interstitialAd = null;

              load();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;

          debugPrint(
            '❌ Erro ao carregar intersticial: ${error.message}',
          );
        },
      ),
    );
  }

  /// Registra uma ação importante.
  static void registerAction() {
    _actionCounter++;

    debugPrint(
      '📊 Ação $_actionCounter de $_showEvery',
    );
  }

  /// Exibe um anúncio somente quando atingir o limite.
  static void showIfNeeded() {
    if (_actionCounter < _showEvery) {
      return;
    }

    _actionCounter = 0;

    if (_interstitialAd == null) {
      debugPrint('⚠️ Intersticial ainda não disponível.');

      load();

      return;
    }

    debugPrint('🎯 Exibindo intersticial.');

    _interstitialAd!.show();
  }

  /// Força a exibição do anúncio.
  static void showNow() {
    if (_interstitialAd == null) {
      debugPrint('⚠️ Intersticial ainda não disponível.');

      load();

      return;
    }

    debugPrint('🎯 Exibindo intersticial.');

    _interstitialAd!.show();
  }

  /// Reinicia o contador de ações.
  static void resetCounter() {
    _actionCounter = 0;
  }
}