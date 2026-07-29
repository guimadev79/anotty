import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';

class RelatoriosController {
  final Box<Cliente> clientes = Hive.box<Cliente>('clientes');
  final Box<Movimentacao> movimentacoes =
      Hive.box<Movimentacao>('movimentacoes');

  List<Cliente> get listaClientes => clientes.values.toList();

  List<Movimentacao> get listaMovimentacoes => movimentacoes.values.toList();

  int get totalClientes => listaClientes.length;

  int get clientesPendentes =>
      listaClientes.where((c) => c.saldo > 0).length;

  double get totalAReceber => listaClientes.fold(
        0,
        (total, cliente) => total + cliente.saldo,
      );

  double get totalRecebido => listaMovimentacoes.fold(
        0,
        (total, mov) => total + mov.valor,
      );

  double get saldoGeral => totalRecebido - totalAReceber;
}