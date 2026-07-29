import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../models/cliente.dart';

class ClientesController extends ChangeNotifier {
  final Box<Cliente> box = Hive.box<Cliente>('clientes');

  final TextEditingController pesquisaController =
      TextEditingController();

  List<Cliente> _clientesFiltrados = [];

  ClientesController() {
    _clientesFiltrados = box.values.toList();

    pesquisaController.addListener(_filtrar);

    box.listenable().addListener(_filtrar);
  }

  List<Cliente> get clientes => _clientesFiltrados;

  void _filtrar() {
    final texto =
        pesquisaController.text.trim().toLowerCase();

    final lista = box.values.toList();

    if (texto.isEmpty) {
      _clientesFiltrados = lista;
    } else {
      _clientesFiltrados = lista.where((cliente) {
        return cliente.nome
                .toLowerCase()
                .contains(texto) ||
            cliente.telefone.contains(texto);
      }).toList();
    }

    notifyListeners();
  }

  void adicionar(Cliente cliente) {
    box.put(cliente.id, cliente);
  }

  void atualizar(Cliente cliente) {
    cliente.save();
  }

  void remover(Cliente cliente) {
    cliente.delete();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    box.listenable().removeListener(_filtrar);
    super.dispose();
  }
}