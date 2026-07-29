import 'package:anotty/features/relatorios/controllers/report_pdf_service.dart';
import 'package:anotty/features/relatorios/widgets/report_actions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/dashboard_card.dart';

import '../controllers/relatorios_controller.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = RelatoriosController();
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return AppScaffold(
      title: 'Relatórios',
      body: ValueListenableBuilder(
        valueListenable: controller.clientes.listenable(),
        builder: (_, _, _) {
          return ValueListenableBuilder(
            valueListenable: controller.movimentacoes.listenable(),
            builder: (_, _, _) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total a Receber',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            moeda.format(controller.totalAReceber),
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: [
                        Expanded(
                          child: DashboardCard(
                            title: 'Clientes',
                            value: controller.totalClientes.toString(),
                            icon: Icons.people,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DashboardCard(
                            title: 'Pendentes',
                            value: controller.clientesPendentes.toString(),
                            icon: Icons.warning_amber,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DashboardCard(
                            title: 'Recebido',
                            value: moeda.format(controller.totalRecebido),
                            icon: Icons.payments,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DashboardCard(
                            title: 'Saldo',
                            value: moeda.format(controller.saldoGeral),
                            icon: Icons.account_balance_wallet,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text('Exportar', style: AppTextStyles.h3),

                    const SizedBox(height: AppSpacing.md),

                    ReportActions(
                      onPdf: () async {
                        await ReportPdfService.exportarPdf(
                          clientes: controller.listaClientes,
                        );
                      },

                      onShare: () async {
                        await ReportPdfService.compartilharPdf(
                          clientes: controller.listaClientes,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
