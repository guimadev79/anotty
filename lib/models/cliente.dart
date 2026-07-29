import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nome;

  @HiveField(2)
  String telefone;

  @HiveField(3)
  String email;

  @HiveField(4)
  String endereco;

  @HiveField(5)
  double saldo;

  @HiveField(6)
  DateTime criadoEm;

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    this.email = '',
    this.endereco = '',
    this.saldo = 0,
    required this.criadoEm,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'saldo': saldo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'] ?? '',
      endereco: json['endereco'] ?? '',
      saldo: (json['saldo'] as num).toDouble(),
      criadoEm: DateTime.parse(json['criadoEm']),
    );
  }
}