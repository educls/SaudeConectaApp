

import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../utils/get_pdf.dart';


class ExibirPdfReceitaPage extends StatefulWidget {
  const ExibirPdfReceitaPage({required this.nomeArquivo, super.key});
  final String nomeArquivo;

  @override
  State<ExibirPdfReceitaPage> createState() => _ExibirPdfReceitaPageState();
}

class _ExibirPdfReceitaPageState extends State<ExibirPdfReceitaPage> {

  FetchPdffromFtp fetchPdffromFtp = FetchPdffromFtp();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vizualizador Receita'),
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