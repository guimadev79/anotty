import 'package:hive/hive.dart';

part 'movimentacao.g.dart';

@HiveType(typeId: 1)
class Movimentacao extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String clienteId;

  @HiveField(2)
  String descricao;

  @HiveField(3)
  double valor;

  @HiveField(4)
  TipoMovimentacao tipo;

  @HiveField(5)
  DateTime data;

  @HiveField(6)
  String? observacao;

  @HiveField(7)
  DateTime? dataPrevistaPagamento;

  @HiveField(8)
  bool quitada;

  Movimentacao({
    required this.id,
    required this.clienteId,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.data,
    this.observacao,
    this.dataPrevistaPagamento,
    this.quitada = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'descricao': descricao,
      'valor': valor,
      'tipo': tipo.name,
      'data': data.toIso8601String(),
      'observacao': observacao ?? '',
      'dataPrevistaPagamento':
          dataPrevistaPagamento?.toIso8601String(),
      'quitada': quitada,
    };
  }

  factory Movimentacao.fromJson(Map<String, dynamic> json) {
    return Movimentacao(
      id: json['id'],
      clienteId: json['clienteId'],
      descricao: json['descricao'],
      valor: (json['valor'] as num).toDouble(),
      tipo: TipoMovimentacao.values.firstWhere(
        (e) => e.name == json['tipo'],
      ),
      data: DateTime.parse(json['data']),
      observacao: json['observacao'] ?? '',
      dataPrevistaPagamento:
          json['dataPrevistaPagamento'] != null
              ? DateTime.parse(json['dataPrevistaPagamento'])
              : null,
      quitada: json['quitada'] ?? false,
    );
  }
}

@HiveType(typeId: 2)
enum TipoMovimentacao {
  @HiveField(0)
  venda,

  @HiveField(1)
  pagamento,

  @HiveField(2)
  desconto,
}