import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';

class ExibirPdfPage extends StatefulWidget {
  const ExibirPdfPage({required this.nomeArquivo, super.key});
  final String nomeArquivo;

  @override
  State<ExibirPdfPage> createState() => _ExibirPdfPageState();
}

class _ExibirPdfPageState extends State<ExibirPdfPage> {
  late String nomeArquivo;
  late String _caminhoDoArquivo = '';

  @override
  void initState() {
    super.initState();
    nomeArquivo = widget.nomeArquivo;

    buscarPdfFromFtp(nomeArquivo);
  }

  void _setCaminho(atestados){
    setState(() {
      _caminhoDoArquivo = atestados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vizualizador Atestado'),
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


  void buscarPdfFromFtp(nomeArquivo) async {
    final FTPConnect _ftpConnect = FTPConnect(
      "192.168.1.23",
      user: "api",
      pass: "1234",
      showLog: true,
    );

    Future<String> fileMock({fileName = 'FlutterTest.txt', content = ''}) async {
      final Directory directory = await getTemporaryDirectory();
      final File file = File('${directory.path}/$fileName');
      await file.writeAsString(content);
      return file.path;
    }

    Future<void> downloadStepByStep(nomeArquivo) async {
      try {
        await _ftpConnect.connect();

        String fileName = nomeArquivo;

        String downloadedFilePath = await fileMock(fileName: 'downloadStepByStep.pdf');
        File downloadedFile = File(downloadedFilePath);
        await _ftpConnect.downloadFile(fileName, downloadedFile);

        await _ftpConnect.disconnect();
        _setCaminho(downloadedFilePath);
      } catch (e) {
        print('Downloading FAILED: ${e.toString()}');
      }
    }
    await downloadStepByStep(nomeArquivo);
  }
}