import 'dart:io';

import 'package:anotty/ads/ad_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/cliente.dart';

class ReportPdfService {
  static Future<File> gerarPdf({required List<Cliente> clientes}) async {
    final pdf = pw.Document();

    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final total = clientes.fold<double>(0, (soma, c) => soma + c.saldo);

    final pendentes = clientes.where((e) => e.saldo > 0).length;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(margin: pw.EdgeInsets.all(32)),
        footer: (context) {
          return pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Página ${context.pageNumber}/${context.pagesCount}',
            ),
          );
        },
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue700,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ANOTTY',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Relatório Financeiro',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 16,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  DateFormat("dd/MM/yyyy 'às' HH:mm").format(DateTime.now()),
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 30),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _card("Clientes", clientes.length.toString()),
              _card("Pendentes", pendentes.toString()),
              _card("A Receber", moeda.format(total)),
            ],
          ),

          pw.SizedBox(height: 30),

          pw.Text(
            "Clientes",
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 12),

          pw.TableHelper.fromTextArray(
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue700),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            headers: const ["Cliente", "Saldo"],
            data: clientes.map((c) => [c.nome, moeda.format(c.saldo)]).toList(),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/relatorio_anotty.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> exportarPdf({required List<Cliente> clientes}) async {
    final file = await gerarPdf(clientes: clientes);

    await Printing.layoutPdf(onLayout: (_) async => file.readAsBytes());

    // Conta a ação somente após finalizar a impressão.
    AdManager.action();
  }

  static Future<void> compartilharPdf({required List<Cliente> clientes}) async {
    final file = await gerarPdf(clientes: clientes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: "Relatório Financeiro - Anotty",
      ),
    );

    // Conta a ação somente após fechar o compartilhamento.
    AdManager.action();
  }

  static pw.Widget _card(String titulo, String valor) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(titulo, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 8),
          pw.Text(
            valor,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
