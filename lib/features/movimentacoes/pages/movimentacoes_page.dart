import 'package:anotty/features/movimentacoes/widgets/movimentacao_card.dart';
import 'package:anotty/models/movimentacao.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/empty_state.dart';

class MovimentacoesPage extends StatefulWidget {
  const MovimentacoesPage({super.key});

  @override
  State<MovimentacoesPage> createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState extends State<MovimentacoesPage> {
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Histórico',
      body: ValueListenableBuilder<Box<Movimentacao>>(
        valueListenable: Hive.box<Movimentacao>('movimentacoes').listenable(),
        builder: (context, box, _) {
          final texto = pesquisaController.text.toLowerCase();

          final movimentacoes = box.values.where((m) {
            final pesquisa = texto.trim();

            final descricao = m.descricao.toLowerCase();
            final tipo = m.tipo.name.toLowerCase();
            final valor = m.valor.toStringAsFixed(2).replaceAll('.', ',');
            final data =
                "${m.data.day.toString().padLeft(2, '0')}/"
                "${m.data.month.toString().padLeft(2, '0')}/"
                "${m.data.year}";

            return descricao.contains(pesquisa) ||
                tipo.contains(pesquisa) ||
                valor.contains(pesquisa) ||
                data.contains(pesquisa);
          }).toList()
          ..sort((a, b) => b.data.compareTo(a.data));

          return Column(
            children: [
              AppSearchField(
                controller: pesquisaController,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${movimentacoes.length} movimentações',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Expanded(
                child: movimentacoes.isEmpty
                    ? const EmptyState(
                        icon: Icons.receipt_long_rounded,
                        title: 'Nenhuma movimentação encontrada',
                        subtitle: 'Tente outra pesquisa.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        itemCount: movimentacoes.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (_, index) {
                          return MovimentacaoCard(
                            movimentacao: movimentacoes[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
