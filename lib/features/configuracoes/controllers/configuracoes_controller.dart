import 'package:anotty/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';
import '../services/backup_service.dart';

class ConfiguracoesController {
  final clientes = Hive.box<Cliente>('clientes');
  final movimentacoes = Hive.box<Movimentacao>('movimentacoes');

  Future<void> apagarTodosOsDados(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Apagar dados',
        ),
        content: const Text(
          'Essa ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await BackupService.limparTudo();

    if (!context.mounted) return;

    AppSnackBar.success(
      context,
      'Todos os dados foram apagados.',
    );
  }

  Future<void> exportarBackup(BuildContext context) async {
    try {
      await BackupService.exportarBackup();

      if (!context.mounted) return;

      AppSnackBar.success(
        context,
        'Backup exportado com sucesso!',
      );
    } catch (e) {
      if (!context.mounted) return;

      AppSnackBar.error(
        context,
        'Erro ao exportar backup.',
      );
    }
  }

  Future<void> restaurarBackup(BuildContext context) async {
    try {
      final ok = await BackupService.restaurarBackup();

      if (!context.mounted) return;

      if (ok) {
        AppSnackBar.success(
          context,
          'Backup restaurado com sucesso!',
        );
      } else {
        AppSnackBar.error(
          context,
          'Operação cancelada.',
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      AppSnackBar.error(
        context,
        'Erro ao restaurar backup.',
      );
    }
  }

  void mostrarSobre(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Anotty',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 JeanDev',
      children: const [
        SizedBox(height: 12),
        Text(
          'Aplicativo para gerenciamento de clientes, cobranças e controle financeiro.',
        ),
      ],
    );
  }
}