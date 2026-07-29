import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/cliente.dart';
import '../controllers/cliente_controller.dart';

class EditarClientePage extends StatefulWidget {
  final Cliente cliente;

  const EditarClientePage({super.key, required this.cliente});

  @override
  State<EditarClientePage> createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  late final TextEditingController nome;
  late final TextEditingController telefone;
  late final TextEditingController email;
  late final TextEditingController endereco;

  final controller = ClienteController();

  @override
  void initState() {
    super.initState();

    nome = TextEditingController(text: widget.cliente.nome);
    telefone = TextEditingController(text: widget.cliente.telefone);
    email = TextEditingController(text: widget.cliente.email);
    endereco = TextEditingController(text: widget.cliente.endereco);
  }

  @override
  void dispose() {
    nome.dispose();
    telefone.dispose();
    email.dispose();
    endereco.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    widget.cliente.nome = nome.text.trim();
    widget.cliente.telefone = telefone.text.trim();
    widget.cliente.email = email.text.trim();
    widget.cliente.endereco = endereco.text.trim();

    await controller.atualizar(widget.cliente);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Editar Cliente',
      body: Column(
        children: [
          AppTextField(
            controller: nome,
            label: 'Nome',
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: telefone,
            label: 'Telefone',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.phone_outlined,
            inputFormatters: [
              PhoneInputFormatter(
                defaultCountryCode: 'BR',
                allowEndlessPhone: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: email,
            label: 'E-mail',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: endereco,
            label: 'Endereço',
            prefixIcon: Icons.location_on_outlined,
            textCapitalization: TextCapitalization.words,
          ),
          const Spacer(),
          AppButton(label: 'Salvar', onPressed: _salvar),
        ],
      ),
    );
  }
}
