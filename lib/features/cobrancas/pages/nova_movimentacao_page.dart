import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/formatters/real_input_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';
import '../controllers/movimentacoes_controller.dart';

class NovaMovimentacaoPage extends StatefulWidget {
  final String? clienteId;

  const NovaMovimentacaoPage({super.key, this.clienteId});

  @override
  State<NovaMovimentacaoPage> createState() => _NovaMovimentacaoPageState();
}

class _NovaMovimentacaoPageState extends State<NovaMovimentacaoPage> {
  final descricao = TextEditingController();
  final valor = TextEditingController();
  final observacao = TextEditingController();
  DateTime data = DateTime.now();
  DateTime? dataPrevistaPagamento;
  bool definirDataPrevista = false;

  final controller = MovimentacoesController();

  TipoMovimentacao tipo = TipoMovimentacao.venda;
  String? clienteSelecionadoId;

  @override
  void initState() {
    super.initState();
    clienteSelecionadoId = widget.clienteId;
  }

  @override
  void dispose() {
    descricao.dispose();
    valor.dispose();
    observacao.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final date = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(data),
    );

    if (time == null) return;

    setState(() {
      data = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _selecionarDataPrevista() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dataPrevistaPagamento ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (date == null) return;

    setState(() {
      dataPrevistaPagamento = date;
    });
  }

  Future<void> _salvar() async {
    if (clienteSelecionadoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um cliente.')));
      return;
    }

    if (descricao.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a descrição da movimentação.')),
      );
      return;
    }

    final texto = toNumericString(valor.text);
    final valorDigitado = texto.isEmpty ? null : double.parse(texto) / 100;

    if (valorDigitado == null || valorDigitado <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe um valor válido.')));
      return;
    }

    await controller.adicionar(
      Movimentacao(
        id: const Uuid().v4(),
        clienteId: clienteSelecionadoId!,
        descricao: descricao.text.trim(),
        valor: valorDigitado,
        tipo: tipo,
        data: data,
        observacao: observacao.text.trim(),
        dataPrevistaPagamento: tipo == TipoMovimentacao.venda
            ? dataPrevistaPagamento
            : null,
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nova Movimentação',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.clienteId == null) ...[
              ValueListenableBuilder<Box<Cliente>>(
                valueListenable: Hive.box<Cliente>('clientes').listenable(),
                builder: (_, box, _) {
                  final clientes = box.values.toList();

                  return DropdownButtonFormField<String>(
                    initialValue: clienteSelecionadoId,
                    decoration: const InputDecoration(labelText: 'Cliente'),
                    items: clientes
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nome),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        clienteSelecionadoId = v;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Tipo da movimentação',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _TipoCard(
                  tipo: TipoMovimentacao.venda,
                  selecionado: tipo,
                  titulo: 'Venda',
                  icon: Icons.shopping_bag,
                  onTap: () {
                    setState(() {
                      tipo = TipoMovimentacao.venda;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _TipoCard(
                  tipo: TipoMovimentacao.pagamento,
                  selecionado: tipo,
                  titulo: 'Pagamento',
                  icon: Icons.payments,
                  onTap: () {
                    setState(() {
                      tipo = TipoMovimentacao.pagamento;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _TipoCard(
                  tipo: TipoMovimentacao.desconto,
                  selecionado: tipo,
                  titulo: 'Abatimento',
                  icon: Icons.discount,
                  onTap: () {
                    setState(() {
                      tipo = TipoMovimentacao.desconto;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: descricao,
              label: 'Descrição',
              maxLength: 80,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: valor,
              label: 'Valor',
              keyboardType: TextInputType.number,
              inputFormatters: [RealInputFormatter()],
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data da movimentação'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(data),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _selecionarData,
              ),
            ),
            if (tipo == TipoMovimentacao.venda) ...[
              const SizedBox(height: 12),
              CheckboxListTile(
                value: definirDataPrevista,
                contentPadding: EdgeInsets.zero,
                title: const Text('Definir data prevista de pagamento'),
                onChanged: (value) {
                  setState(() {
                    definirDataPrevista = value ?? false;

                    if (!definirDataPrevista) {
                      dataPrevistaPagamento = null;
                    }
                  });
                },
              ),
              if (definirDataPrevista)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: const Text('Data prevista'),
                  subtitle: Text(
                    dataPrevistaPagamento == null
                        ? 'Selecione uma data'
                        : DateFormat(
                            'dd/MM/yyyy',
                            'pt_BR',
                          ).format(dataPrevistaPagamento!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _selecionarDataPrevista,
                  ),
                ),
            ],
            const SizedBox(height: 16),
            AppTextField(
              controller: observacao,
              label: 'Observações',
              maxLength: 300,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            AppButton(label: 'Salvar', onPressed: _salvar),
          ],
        ),
      ),
    );
  }
}

class _TipoCard extends StatelessWidget {
  final TipoMovimentacao tipo;
  final TipoMovimentacao selecionado;
  final IconData icon;
  final String titulo;
  final VoidCallback onTap;

  const _TipoCard({
    required this.tipo,
    required this.selecionado,
    required this.icon,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ativo = tipo == selecionado;

    Color cor;

    switch (tipo) {
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

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: ativo ? cor.withValues(alpha: .12) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ativo ? cor : Colors.grey.shade300,
              width: ativo ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: cor, size: 30),
              const SizedBox(height: 8),
              Text(
                titulo,
                style: TextStyle(
                  color: cor,
                  fontWeight: ativo ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
