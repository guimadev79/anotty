import 'package:anotty/core/services/cobranca_service.dart';
import 'package:anotty/features/clientes/pages/editar_cliente_page.dart';
import 'package:anotty/features/whatsapp/services/whatsapp_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';
import '../../relatorios/services/extrato_pdf_service.dart';
import '../../movimentacoes/widgets/movimentacao_card.dart';
import '../../movimentacoes/pages/registrar_pagamento_page.dart';

class ClienteDetalhesPage extends StatelessWidget {
  final Cliente cliente;

  const ClienteDetalhesPage({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

    return AppScaffold(
      title: cliente.nome,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Movimentacao>('movimentacoes').listenable(),
        builder: (_, Box<Movimentacao> box, _) {
          final movimentacoes =
              box.values.where((m) => m.clienteId == cliente.id).toList()
                ..sort((a, b) => b.data.compareTo(a.data));

          final vendas = movimentacoes
              .where(
                (m) =>
                    m.tipo == TipoMovimentacao.venda &&
                    !m.quitada &&
                    m.dataPrevistaPagamento != null,
              )
              .toList()
            ..sort(
              (a, b) => a.dataPrevistaPagamento!
                  .compareTo(b.dataPrevistaPagamento!),
            );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        child: Text(
                          cliente.nome.trim().isNotEmpty
                              ? cliente.nome[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        cliente.nome,
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _info(Icons.phone, cliente.telefone),

                      _info(
                        Icons.email,
                        cliente.email.isEmpty ? "-" : cliente.email,
                      ),

                      _info(
                        Icons.location_on,
                        cliente.endereco.isEmpty ? "-" : cliente.endereco,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Saldo Atual",
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        moeda.format(cliente.saldo),
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Cobranças pendentes logo abaixo do card de saldo
                if (vendas.isNotEmpty) ...[
                  Text(
                    "Cobranças pendentes",
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...vendas.map((venda) {
                    final dataPrevista = venda.dataPrevistaPagamento!;
                    final status = CobrancaService.obterStatus(venda);
                    final chipColor = CobrancaService.cor(status);
                    final statusTexto = CobrancaService.descricaoCompleta(venda);
                    final icone = CobrancaService.icone(status);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    venda.descricao,
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Chip(
                                  avatar: Icon(
                                    icone,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  label: Text(
                                    statusTexto,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: chipColor,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              moeda.format(venda.valor),
                              style: AppTextStyles.title.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Vencimento: ',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(dateFormat.format(dataPrevista)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                icon: const Icon(Icons.payments),
                                label: const Text('Registrar Pagamento'),
                                onPressed: () async {
                                  final ok = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegistrarPagamentoPage(
                                        venda: venda,
                                      ),
                                    ),
                                  );

                                  if (ok == true && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pagamento registrado com sucesso!'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Movimentações',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              movimentacoes.length.toString(),
                              style: AppTextStyles.title.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Saldo',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                moeda.format(cliente.saldo),
                                style: AppTextStyles.title.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarClientePage(cliente: cliente),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Cliente'),
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    await WhatsAppService.abrir(
                      telefone: cliente.telefone,
                      mensagem:
                          'Olá ${cliente.nome}!\n\n'
                          'Seu saldo atual é de ${moeda.format(cliente.saldo)}.\n\n'
                          'Qualquer dúvida estou à disposição.\n\n'
                          'Obrigado!',
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Cobrar pelo WhatsApp'),
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    await ExtratoPdfService.gerar(
                      cliente: cliente,
                      movimentacoes: movimentacoes,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Extrato em PDF'),
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Excluir"),
                        content: const Text("Deseja excluir este cliente?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancelar"),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Excluir"),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      await cliente.delete();

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Excluir Cliente"),
                ),

                const SizedBox(height: 28),

                Text(
                  "Histórico de movimentações",
                  style: AppTextStyles.title.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                if (movimentacoes.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("Nenhuma movimentação."),
                    ),
                  ),

                ...movimentacoes.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MovimentacaoCard(movimentacao: m),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _info(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(texto, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}