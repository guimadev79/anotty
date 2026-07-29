import 'package:anotty/core/theme/app_colors.dart';
import 'package:anotty/core/theme/app_radius.dart';
import 'package:anotty/core/theme/app_spacing.dart';
import 'package:anotty/core/theme/app_text_styles.dart';
import 'package:anotty/models/cliente.dart';
import 'package:flutter/material.dart';

// import '../../../clientes/domain/entities/cliente.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_radius.dart';
// import '../../../core/theme/app_spacing.dart';
// import '../../../core/theme/app_text_styles.dart';

class RecentClients extends StatelessWidget {
  final List<Cliente> clientes;

  const RecentClients({
    super.key,
    required this.clientes,
  });

  @override
  Widget build(BuildContext context) {
    if (clientes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Últimos clientes',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSpacing.md),

        ...clientes.take(5).map(
              (cliente) => ClientTile(
                nome: cliente.nome,
                valor: cliente.saldo,
              ),
            ),
      ],
    );
  }
}

class ClientTile extends StatelessWidget {
  final String nome;
  final double valor;

  const ClientTile({
    super.key,
    required this.nome,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            child: Text(
              nome.isNotEmpty ? nome[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              nome,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            'R\$ ${valor.toStringAsFixed(2)}',
            style: AppTextStyles.title.copyWith(
              color: valor > 0 ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}