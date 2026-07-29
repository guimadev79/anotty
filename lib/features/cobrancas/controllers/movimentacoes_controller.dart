import 'package:anotty/features/movimentacoes/services/movimentacao_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';

class MovimentacoesController extends ChangeNotifier {
  final movimentos = Hive.box<Movimentacao>('movimentacoes');
  final clientes = Hive.box<Cliente>('clientes');

  Future<void> adicionar(Movimentacao movimentacao) async {
    await movimentos.put(movimentacao.id, movimentacao);

    await MovimentacaoService.recalcularSaldo(movimentacao.clienteId);

    notifyListeners();
  }

  Future<void> atualizar(Movimentacao movimentacao) async {
    await movimentos.put(movimentacao.id, movimentacao);

    await MovimentacaoService.recalcularSaldo(
      movimentacao.clienteId,
    );

    notifyListeners();
  }

  Future<void> excluir(Movimentacao movimentacao) async {
    await movimentos.delete(movimentacao.id);

    await MovimentacaoService.recalcularSaldo(
      movimentacao.clienteId,
    );

    notifyListeners();
  }

  List<Movimentacao> listar(String clienteId) {
    return movimentos.values.where((e) => e.clienteId == clienteId).toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }
}