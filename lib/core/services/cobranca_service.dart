import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/movimentacao.dart';

enum StatusCobranca {
  emDia,
  venceHoje,
  vencido,
}

class CobrancaService {
  static StatusCobranca obterStatus(Movimentacao movimentacao) {
    if (movimentacao.tipo != TipoMovimentacao.venda) {
      return StatusCobranca.emDia;
    }

    final vencimento = movimentacao.dataPrevistaPagamento;

    if (vencimento == null) {
      return StatusCobranca.emDia;
    }

    final hoje = DateTime.now();

    final hojeSemHora = DateTime(
      hoje.year,
      hoje.month,
      hoje.day,
    );

    final data = DateTime(
      vencimento.year,
      vencimento.month,
      vencimento.day,
    );

    if (data.isBefore(hojeSemHora)) {
      return StatusCobranca.vencido;
    }

    if (data.isAtSameMomentAs(hojeSemHora)) {
      return StatusCobranca.venceHoje;
    }

    return StatusCobranca.emDia;
  }

  static String texto(StatusCobranca status) {
    switch (status) {
      case StatusCobranca.emDia:
        return 'Em dia';

      case StatusCobranca.venceHoje:
        return 'Vence hoje';

      case StatusCobranca.vencido:
        return 'Vencido';
    }
  }

  static Color cor(StatusCobranca status) {
    switch (status) {
      case StatusCobranca.emDia:
        return Colors.green;

      case StatusCobranca.venceHoje:
        return Colors.orange;

      case StatusCobranca.vencido:
        return Colors.red;
    }
  }

  static IconData icone(StatusCobranca status) {
    switch (status) {
      case StatusCobranca.emDia:
        return Icons.check_circle;

      case StatusCobranca.venceHoje:
        return Icons.warning_rounded;

      case StatusCobranca.vencido:
        return Icons.error;
    }
  }

  static int diasAtraso(Movimentacao movimentacao) {
    final vencimento = movimentacao.dataPrevistaPagamento;

    if (vencimento == null) {
      return 0;
    }

    final hoje = DateTime.now();

    final hojeSemHora = DateTime(
      hoje.year,
      hoje.month,
      hoje.day,
    );

    final data = DateTime(
      vencimento.year,
      vencimento.month,
      vencimento.day,
    );

    if (!data.isBefore(hojeSemHora)) {
      return 0;
    }

    return hojeSemHora.difference(data).inDays;
  }

  static String descricaoCompleta(Movimentacao movimentacao) {
    final status = obterStatus(movimentacao);

    switch (status) {
      case StatusCobranca.emDia:
        return 'Em dia';

      case StatusCobranca.venceHoje:
        return 'Vence hoje';

      case StatusCobranca.vencido:
        final dias = diasAtraso(movimentacao);

        return dias == 1
            ? 'Vencido há 1 dia'
            : 'Vencido há $dias dias';
    }
  }

  static String formatarData(DateTime? data) {
    if (data == null) {
      return '-';
    }

    return DateFormat(
      'dd/MM/yyyy',
      'pt_BR',
    ).format(data);
  }
}