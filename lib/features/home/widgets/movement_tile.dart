import 'package:flutter/material.dart';

import '../../../models/movimentacao.dart';

class MovementTile extends StatelessWidget {
  final Movimentacao mov;

  const MovementTile({
    super.key,
    required this.mov,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (mov.tipo) {
      TipoMovimentacao.venda => Colors.orange,
      TipoMovimentacao.pagamento => Colors.green,
      TipoMovimentacao.desconto => Colors.blue,
    };

    final icon = switch (mov.tipo) {
      TipoMovimentacao.venda => Icons.shopping_cart,
      TipoMovimentacao.pagamento => Icons.payments,
      TipoMovimentacao.desconto => Icons.discount,
    };

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(icon, color: color),
        ),
        title: Text(mov.descricao),
        subtitle: Text(
          '${mov.data.day}/${mov.data.month}/${mov.data.year}',
        ),
        trailing: Text(
          'R\$ ${mov.valor.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}