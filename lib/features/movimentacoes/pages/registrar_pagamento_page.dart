import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/formatters/real_input_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/movimentacao.dart';

class RegistrarPagamentoPage extends StatefulWidget {
  final Movimentacao venda;

  const RegistrarPagamentoPage({super.key, required this.venda});

  @override
  State<RegistrarPagamentoPage> createState() => _RegistrarPagamentoPageState();
}

class _RegistrarPagamentoPageState extends State<RegistrarPagamentoPage> {
  final valorController = TextEditingController();
  final observacaoController = TextEditingController();

  DateTime data = DateTime.now();

  double get valor {
    final texto = valorController.text
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();

    return double.tryParse(texto) ?? 0;
  }

  @override
  void initState() {
    super.initState();

    valorController.text =
        'R\$ ${widget.venda.valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Registrar Pagamento',
      body: Column(
        children: [
          AppTextField(
            controller: valorController,
            label: 'Valor Pago',
            keyboardType: TextInputType.number,
            inputFormatters: [RealInputFormatter()],
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Data do pagamento'),
            subtitle: Text(
              '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
            ),
            onTap: () async {
              final nova = await showDatePicker(
                context: context,
                initialDate: data,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (nova != null) {
                setState(() => data = nova);
              }
            },
          ),

          const SizedBox(height: 24),

          AppTextField(
            controller: observacaoController,
            label: 'Observação',
            maxLines: 3,
          ),

          const Spacer(),

          AppButton(
            label: 'Salvar',
            icon: Icons.check,
            onPressed: () async {
              final box = Hive.box<Movimentacao>('movimentacoes');

              await box.add(
                Movimentacao(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  clienteId: widget.venda.clienteId,
                  descricao: 'Pagamento',
                  valor: valor,
                  tipo: TipoMovimentacao.pagamento,
                  data: data,
                  observacao: observacaoController.text,
                ),
              );
              widget.venda.quitada = true;

              await widget.venda.save();

              if (mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
    );
  }
}
