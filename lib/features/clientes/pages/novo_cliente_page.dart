import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/cliente.dart';

class NovoClientePage extends StatefulWidget {
  const NovoClientePage({super.key});

  @override
  State<NovoClientePage> createState() => _NovoClientePageState();
}

class _NovoClientePageState extends State<NovoClientePage> {
  final nome = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final endereco = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Novo Cliente',
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(height: 32),
            AppButton(
              label: 'Salvar',
              onPressed: () {
                if (nome.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe o nome do cliente.'),
                    ),
                  );
                  return;
                }

                if (telefone.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe o telefone do cliente.'),
                    ),
                  );
                  return;
                }

                final id = const Uuid().v4();
                Hive.box<Cliente>('clientes').put(
                  id,
                  Cliente(
                    id: id,
                    nome: nome.text,
                    telefone: telefone.text,
                    email: email.text,
                    endereco: endereco.text,
                    saldo: 0,
                    criadoEm: DateTime.now(),
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}