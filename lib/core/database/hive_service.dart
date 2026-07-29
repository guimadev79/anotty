import 'package:hive_flutter/hive_flutter.dart';

import '../../models/cliente.dart';
import '../../models/movimentacao.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(ClienteAdapter())
      ..registerAdapter(MovimentacaoAdapter())
      ..registerAdapter(TipoMovimentacaoAdapter());

    await Hive.openBox<Cliente>('clientes');
    await Hive.openBox<Movimentacao>('movimentacoes');
  }
}