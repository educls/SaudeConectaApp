

import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';


class FetchPdffromFtp {

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

    Future<String> downloadStepByStep(nomeArquivo) async {
      String returnNull = '';
      try {
        await _ftpConnect.connect();

        String fileName = nomeArquivo;

        String downloadedFilePath = await fileMock(fileName: 'downloadStepByStep.pdf');
        File downloadedFile = File(downloadedFilePath);
        await _ftpConnect.downloadFile(fileName, downloadedFile);

        await _ftpConnect.disconnect();

        return downloadedFilePath;

      } catch (e) {
        print('Downloading FAILED: ${e.toString()}');
      }
      return returnNull;
    }
    
}