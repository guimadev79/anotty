import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';
import 'nova_movimentacao_page.dart';

class CobrancasPage extends StatelessWidget {
  const CobrancasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Cobranças',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovaMovimentacaoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<Movimentacao>>(
        valueListenable: Hive.box<Movimentacao>('movimentacoes').listenable(),
        builder: (context, box, _) {
          final movimentacoes = box.values.toList().reversed.toList();

          if (movimentacoes.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Nenhuma movimentação',
              subtitle: 'Cadastre sua primeira cobrança.',
            );
          }

          final clientes = Hive.box<Cliente>('clientes');

          return ListView.separated(
            itemCount: movimentacoes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final mov = movimentacoes[index];

              Cliente? cliente;

              try {
                cliente = clientes.values.firstWhere(
                  (c) => c.id == mov.clienteId,
                );
              } catch (_) {
                cliente = null;
              }

              Color cor;

              switch (mov.tipo) {
                case TipoMovimentacao.venda:
                  cor = Colors.green;
                  break;
                case TipoMovimentacao.pagamento:
                  cor = Colors.blue;
                  break;
                case TipoMovimentacao.desconto:
                  cor = Colors.orange;
                  break;
              }

              return AppCard(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cor.withValues(alpha: .12),
                    child: Icon(Icons.receipt_long, color: cor),
                  ),
                 title: Text(cliente?.nome ?? 'Cliente removido'),
                  subtitle: Text(mov.descricao),
                  trailing: Text(
                    'R\$ ${mov.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
