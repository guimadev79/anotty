import 'package:anotty/features/cobrancas/controllers/movimentacoes_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/movimentacao.dart';
import '../pages/editar_movimentacao_page.dart';

class MovimentacaoCard extends StatelessWidget {
  final Movimentacao movimentacao;

  const MovimentacaoCard({
    super.key,
    required this.movimentacao,
  });

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    IconData icone;
    Color cor;

    switch (movimentacao.tipo) {
      case TipoMovimentacao.venda:
        icone = Icons.shopping_cart_rounded;
        cor = Colors.orange;
        break;

      case TipoMovimentacao.pagamento:
        icone = Icons.payments_rounded;
        cor = Colors.green;
        break;

      case TipoMovimentacao.desconto:
        icone = Icons.discount_rounded;
        cor = Colors.red;
        break;
    }

    return AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditarMovimentacaoPage(
              movimentacao: movimentacao,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: cor.withValues(alpha: .12),
            child: Icon(
              icone,
              color: cor,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movimentacao.descricao,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(movimentacao.data),
                        style: AppTextStyles.caption,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        moeda.format(movimentacao.valor),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: cor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  splashRadius: 18,
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'editar',
                      child: Text('Editar'),
                    ),
                    PopupMenuItem(
                      value: 'excluir',
                      child: Text('Excluir'),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'editar') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarMovimentacaoPage(
                            movimentacao: movimentacao,
                          ),
                        ),
                      );
                    } else {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Excluir movimentação'),
                          content: const Text(
                            'Deseja realmente excluir esta movimentação?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await MovimentacoesController().excluir(movimentacao);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}