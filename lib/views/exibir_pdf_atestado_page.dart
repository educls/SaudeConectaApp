import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../controllers/save_pdf_controller.dart';
import '../utils/class/Theme.dart';
import '../utils/get_pdf.dart';

class ExibirPdfPage extends StatefulWidget {
  const ExibirPdfPage({required this.nomeArquivo, super.key});
  final String nomeArquivo;

  @override
  State<ExibirPdfPage> createState() => _ExibirPdfPageState();
}

class _ExibirPdfPageState extends State<ExibirPdfPage> {
  late String nomeArquivo;
  late String _caminhoDoArquivo = '';
  SavePdf savePdf = SavePdf();
  FetchPdffromFtp fetchPdffromFtp = FetchPdffromFtp();

  @override
  void initState() {
    super.initState();
    nomeArquivo = widget.nomeArquivo;

    _buscarPdfFromFtp(nomeArquivo);
  }

  void _setCaminho(atestados){
    setState(() {
      _caminhoDoArquivo = atestados;
    });
  }

  Future<void> _buscarPdfFromFtp(nomeArquivo) async{
    String pathArquivo = await fetchPdffromFtp.downloadStepByStep(nomeArquivo);

    _setCaminho(pathArquivo);
  }

  Future<void> _salvarPdf() async{
    await savePdf.savePdfInGalleryAtestado(_caminhoDoArquivo, nomeArquivo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pdf salvo com sucesso!'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vizualizador Atestado'),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
                                      ? const Color.fromARGB(255, 35, 35, 36)
                                      : const Color.fromARGB(255, 54, 158, 255),
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.save),
            ),
            onPressed: () {
              _salvarPdf();
              print("DOC SALVO");
            },
          ),
        ],
      ),
      body: 
        _caminhoDoArquivo.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : PDFView(
            filePath: _caminhoDoArquivo,
          )
    );
  }

}