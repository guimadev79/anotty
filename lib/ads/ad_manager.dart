import 'interstitial_service.dart';

class AdManager {
  AdManager._();

  /// Inicializa todos os anúncios do aplicativo.
  static Future<void> initialize() async {
    await InterstitialService.load();
  }

  /// Registra uma ação importante do usuário.
  static void action() {
    InterstitialService.registerAction();
    InterstitialService.showIfNeeded();
  }

  /// Exibe um anúncio imediatamente.
  static void showInterstitial() {
    InterstitialService.showNow();
  }

  /// Reinicia o contador de ações.
  static void reset() {
    InterstitialService.resetCounter();
  }

  /// Indica se existe um interstitial carregado.
  static bool get isInterstitialReady =>
      InterstitialService.isReady;
}