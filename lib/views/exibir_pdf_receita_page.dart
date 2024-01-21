

import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../utils/class/Theme.dart';
import '../utils/get_pdf.dart';
import '../controllers/save_pdf_controller.dart';


class ExibirPdfReceitaPage extends StatefulWidget {
  const ExibirPdfReceitaPage({required this.nomeArquivo, Key? key}) : super(key: key);
  final String nomeArquivo;

  @override
  State<ExibirPdfReceitaPage> createState() => _ExibirPdfReceitaPageState();
}

class _ExibirPdfReceitaPageState extends State<ExibirPdfReceitaPage> {

  FetchPdffromFtp fetchPdffromFtp = FetchPdffromFtp();
  SavePdf savePdf = SavePdf();

  late String nomeArquivo;
  late String _caminhoDoArquivo = '';

  @override
  void initState() {
    super.initState();
    nomeArquivo = widget.nomeArquivo;

    _buscarPdfFromFtp(nomeArquivo);
  }

  void _setCaminho(receitas){
    setState(() {
      _caminhoDoArquivo = receitas;
    });
    print(_caminhoDoArquivo);
  }

  Future<void> _buscarPdfFromFtp(nomeArquivo) async{
    String pathArquivo = await fetchPdffromFtp.downloadStepByStep(nomeArquivo);

    _setCaminho(pathArquivo);
  }

  Future<void> _salvarPdf() async{
    await savePdf.savePdfInGalleryReceita(_caminhoDoArquivo, nomeArquivo);

      // ignore: use_build_context_synchronously
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
        title: const Text('Vizualizador Receita'),
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