import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/cliente.dart';
import '../../../models/movimentacao.dart';

class ExtratoPdfService {
  static Future<void> gerar({
    required Cliente cliente,
    required List<Movimentacao> movimentacoes,
  }) async {
    final pdf = pw.Document();

    final moeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    final data = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.now());

    final cobrancasPendentes = movimentacoes.where((m) {
      return m.tipo == TipoMovimentacao.venda && !m.quitada;
    }).toList();

    final cobrancasVencidas = cobrancasPendentes.where((m) {
      return m.dataPrevistaPagamento != null &&
          m.dataPrevistaPagamento!.isBefore(DateTime.now());
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [

          pw.Header(
            level: 0,
            child: pw.Text(
              'Extrato do Cliente',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 16),

          pw.Text(
            'Cliente: ${cliente.nome}',
          ),

          pw.Text(
            'Telefone: ${cliente.telefone}',
          ),

          pw.Text(
            'Email: ${cliente.email}',
          ),

          pw.Text(
            'Endereço: ${cliente.endereco}',
          ),

          pw.SizedBox(height: 20),

          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: PdfColors.grey300,
            child: pw.Text(
              'Saldo Atual: ${moeda.format(cliente.saldo)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          pw.SizedBox(height: 24),

          pw.Text(
            'Cobranças Pendentes',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),
          pw.SizedBox(height: 10),
          if (cobrancasPendentes.isEmpty)
            pw.Text('Nenhuma cobrança pendente.')
          else
            ...cobrancasPendentes.map(
              (m) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      m.descricao,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('Valor: ${moeda.format(m.valor)}'),
                    pw.Text(
                      'Vencimento: ${m.dataPrevistaPagamento != null ? DateFormat('dd/MM/yyyy').format(m.dataPrevistaPagamento!) : '-'}',
                    ),
                  ],
                ),
              ),
            ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Cobranças Vencidas',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),
          pw.SizedBox(height: 10),
          if (cobrancasVencidas.isEmpty)
            pw.Text('Nenhuma cobrança vencida.')
          else
            ...cobrancasVencidas.map(
              (m) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      m.descricao,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('Valor: ${moeda.format(m.valor)}'),
                    pw.Text(
                      'Vencimento: ${m.dataPrevistaPagamento != null ? DateFormat('dd/MM/yyyy').format(m.dataPrevistaPagamento!) : '-'}',
                    ),
                  ],
                ),
              ),
            ),

          pw.SizedBox(height: 24),

          pw.Text(
            'Histórico Financeiro',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),

          pw.SizedBox(height: 12),

          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            headers: const [
              'Data',
              'Descrição',
              'Valor',
            ],
            data: movimentacoes.map((m) {
              return [
                DateFormat(
                  'dd/MM/yyyy',
                ).format(m.data),
                m.descricao,
                moeda.format(m.valor),
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 24),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total de movimentações: ${movimentacoes.length}',
            ),
          ),

          pw.SizedBox(height: 40),

          pw.Divider(),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Emitido em $data',
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: 'Extrato_${cliente.nome}.pdf',
    );
  }
}