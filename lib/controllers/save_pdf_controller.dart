import 'dart:io';

class SavePdf {
  Future<void> savePdfInGalleryReceita(String caminhoDoPDF, nomeArquivo) async {
    try {
      final file = File(caminhoDoPDF);

      await file.copy('/storage/emulated/0/Download/$nomeArquivo');

      print('PDF copiado com sucesso para /storage/emulated/0/Download/$nomeArquivo');
    } catch (err) {
      print('Erro ao copiar o PDF: $err');
    }
  }

  Future<void> savePdfInGalleryAtestado(String caminhoDoPDF, nomeArquivo) async {
    try {
      final file = File(caminhoDoPDF);

      await file.copy('/storage/emulated/0/Download/$nomeArquivo');

      print('PDF copiado com sucesso para /storage/emulated/0/Download/$nomeArquivo');
    } catch (err) {
      print('Erro ao copiar o PDF: $err');
    }
  }
}
