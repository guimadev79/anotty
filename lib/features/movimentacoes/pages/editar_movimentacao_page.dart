import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/movimentacao.dart';
import '../services/movimentacao_service.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class EditarMovimentacaoPage extends StatefulWidget {
  final Movimentacao movimentacao;

  const EditarMovimentacaoPage({super.key, required this.movimentacao});

  @override
  State<EditarMovimentacaoPage> createState() => _EditarMovimentacaoPageState();
}

class _EditarMovimentacaoPageState extends State<EditarMovimentacaoPage> {
  late final TextEditingController descricaoController;
  late final TextEditingController valorController;
  late final TextEditingController observacaoController;

  late DateTime data;

  @override
  void initState() {
    super.initState();

    descricaoController = TextEditingController(
      text: widget.movimentacao.descricao,
    );

    valorController = TextEditingController(
      text: toCurrencyString(
        widget.movimentacao.valor.toString(),
        leadingSymbol: 'R\$ ',
        thousandSeparator: ThousandSeparator.Period,
        mantissaLength: 2,
      ),
    );

    observacaoController = TextEditingController(
      text: widget.movimentacao.observacao,
    );

    data = widget.movimentacao.data;
  }

  @override
  void dispose() {
    descricaoController.dispose();
    valorController.dispose();
    observacaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final novaData = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (novaData == null) return;

    setState(() {
      data = DateTime(
        novaData.year,
        novaData.month,
        novaData.day,
        data.hour,
        data.minute,
      );
    });
  }

  Future<void> _salvar() async {
    widget.movimentacao.descricao = descricaoController.text.trim();

    widget.movimentacao.valor = toNumericString(valorController.text).isEmpty
        ? 0
        : double.parse(toNumericString(valorController.text)) / 100;

    widget.movimentacao.observacao = observacaoController.text.trim();

    widget.movimentacao.data = data;

    await widget.movimentacao.save();

    await MovimentacaoService.recalcularSaldo(widget.movimentacao.clienteId);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Movimentação')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: valorController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyInputFormatter(
                leadingSymbol: 'R\$ ',
                useSymbolPadding: true,
                thousandSeparator: ThousandSeparator.Period,
                mantissaLength: 2,
              ),
            ],
            decoration: const InputDecoration(
              labelText: 'Valor',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: observacaoController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observações (opcional)',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),

          const SizedBox(height: 16),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_month),
            title: const Text('Data'),
            subtitle: Text(DateFormat('dd/MM/yyyy', 'pt_BR').format(data)),
            trailing: FilledButton(
              onPressed: _selecionarData,
              child: const Text('Alterar'),
            ),
          ),

          const SizedBox(height: 32),

          FilledButton.icon(
            onPressed: _salvar,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }
}
