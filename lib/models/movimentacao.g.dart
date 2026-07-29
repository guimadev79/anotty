// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimentacao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovimentacaoAdapter extends TypeAdapter<Movimentacao> {
  @override
  final int typeId = 1;

  @override
  Movimentacao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movimentacao(
      id: fields[0] as String,
      clienteId: fields[1] as String,
      descricao: fields[2] as String,
      valor: fields[3] as double,
      tipo: fields[4] as TipoMovimentacao,
      data: fields[5] as DateTime,
      observacao: fields[6] as String?,
      dataPrevistaPagamento: fields[7] as DateTime?,
      quitada: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Movimentacao obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clienteId)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.valor)
      ..writeByte(4)
      ..write(obj.tipo)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.observacao)
      ..writeByte(7)
      ..write(obj.dataPrevistaPagamento)
      ..writeByte(8)
      ..write(obj.quitada);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovimentacaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipoMovimentacaoAdapter extends TypeAdapter<TipoMovimentacao> {
  @override
  final int typeId = 2;

  @override
  TipoMovimentacao read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoMovimentacao.venda;
      case 1:
        return TipoMovimentacao.pagamento;
      case 2:
        return TipoMovimentacao.desconto;
      default:
        return TipoMovimentacao.venda;
    }
  }

  @override
  void write(BinaryWriter writer, TipoMovimentacao obj) {
    switch (obj) {
      case TipoMovimentacao.venda:
        writer.writeByte(0);
        break;
      case TipoMovimentacao.pagamento:
        writer.writeByte(1);
        break;
      case TipoMovimentacao.desconto:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoMovimentacaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}