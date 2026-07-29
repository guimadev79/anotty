import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> abrir({
    required String telefone,
    String? mensagem,
  }) async {
    telefone = telefone.replaceAll(RegExp(r'[^0-9]'), '');

    final uri = Uri.parse(
      'https://wa.me/55$telefone'
      '${mensagem != null ? '?text=${Uri.encodeComponent(mensagem)}' : ''}',
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Não foi possível abrir o WhatsApp.');
    }
  }
}