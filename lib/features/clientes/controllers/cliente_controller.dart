import '../../../models/cliente.dart';

class ClienteController {
  Future<void> atualizar(Cliente cliente) async {
    await cliente.save();
  }

  Future<void> excluir(Cliente cliente) async {
    await cliente.delete();
  }
}