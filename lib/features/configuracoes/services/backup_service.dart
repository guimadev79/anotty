import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';

class BackupService {
  static Future<void> exportarBackup() async {
    final clientes =
        Hive.box<Cliente>('clientes').values.toList();

    final movimentacoes =
        Hive.box<Movimentacao>('movimentacoes').values.toList();

    final json = jsonEncode({
      'clientes': clientes.map((e) => e.toJson()).toList(),
      'movimentacoes':
          movimentacoes.map((e) => e.toJson()).toList(),
    });

    final dir = await getTemporaryDirectory();

    final file = File('${dir.path}/backup_anotty.json');

    await file.writeAsString(json);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
      ),
    );
  }

  static Future<bool> restaurarBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return false;

    final file = File(result.files.single.path!);

    final Map<String, dynamic> json =
        jsonDecode(await file.readAsString());

    final clientesBox = Hive.box<Cliente>('clientes');
    final movimentacoesBox =
        Hive.box<Movimentacao>('movimentacoes');

    await clientesBox.clear();
    await movimentacoesBox.clear();

    for (final item in json['clientes']) {
      final cliente = Cliente.fromJson(
        Map<String, dynamic>.from(item),
      );

      await clientesBox.put(cliente.id, cliente);
    }

    for (final item in json['movimentacoes']) {
      final movimentacao = Movimentacao.fromJson(
        Map<String, dynamic>.from(item),
      );

      await movimentacoesBox.put(
        movimentacao.id,
        movimentacao,
      );
    }

    return true;
  }

  static Future<void> limparTudo() async {
    await Hive.box<Cliente>('clientes').clear();
    await Hive.box<Movimentacao>('movimentacoes').clear();
  }
}