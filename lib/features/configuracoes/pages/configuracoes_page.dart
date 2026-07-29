import 'package:flutter/material.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../controllers/configuracoes_controller.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ConfiguracoesController();

    return AppScaffold(
      title: 'Configurações',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(
              title: 'Aplicativo',
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Sobre',
                  subtitle: 'Versão 1.0.0',
                  onTap: () => controller.mostrarSobre(context),
                ),
              ],
            ),
            SettingsSection(
              title: 'Backup',
              children: [
                SettingsTile(
                  icon: Icons.upload_file,
                  title: 'Exportar Backup',
                  subtitle: 'Salvar clientes e cobranças',
                  onTap: () => controller.exportarBackup(context),
                ),
                SettingsTile(
                  icon: Icons.download,
                  title: 'Restaurar Backup',
                  subtitle: 'Importar arquivo',
                  onTap: () => controller.restaurarBackup(context),
                ),
              ],
            ),
            SettingsSection(
              title: 'Financeiro',
              children: [
                SettingsTile(
                  icon: Icons.attach_money,
                  title: 'Moeda',
                  subtitle: 'Real (R\$)',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.calendar_today,
                  title: 'Formato da Data',
                  subtitle: 'dd/MM/yyyy',
                  onTap: () {},
                ),
              ],
            ),
            SettingsSection(
              title: 'Dados',
              children: [
                SettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Apagar Todos os Dados',
                  subtitle: 'Esta ação não pode ser desfeita',
                  onTap: () => controller.apagarTodosOsDados(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Anotty\nVersão 1.0.0",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}