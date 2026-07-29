import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';

class MovimentacaoService {
  static Future<void> recalcularSaldo(String clienteId) async {
    final clientes = Hive.box<Cliente>('clientes');
    final movimentacoes = Hive.box<Movimentacao>('movimentacoes');

    final cliente = clientes.get(clienteId);

    if (cliente == null) return;

    double saldo = 0;

    for (final m in movimentacoes.values.where((e) => e.clienteId == clienteId)) {
      switch (m.tipo) {
        case TipoMovimentacao.venda:
          saldo += m.valor;
          break;

        case TipoMovimentacao.pagamento:
        case TipoMovimentacao.desconto:
          saldo -= m.valor;
          break;
      }
    }

    cliente.saldo = saldo;
    await cliente.save();
  }
}