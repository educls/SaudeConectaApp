
import 'package:pdf/widgets.dart' as pw;


Future<pw.Document> savePDF(String conteudo) async {
  final pdfNull = pw.Document();
  try {
    // Criando um documento PDF
    final pdf = pw.Document();

    // Adicionando uma página com um texto ao documento
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Olá, mundo!', style: const pw.TextStyle(fontSize: 25)),
        );
      },
    ));

    return pdf;

  } catch (e) {
    print('Erro ao salvar o PDF: $e');
  }
  return pdfNull;
}
