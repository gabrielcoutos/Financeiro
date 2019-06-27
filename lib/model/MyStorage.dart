import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MyStorage{
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localFile async{
    final path = await localPath;
    return File('$path/contrato.txt');
  }

  Future<File> writeContrato(String contrato) async{
    final file = await localFile;
    return file.writeAsString(contrato);
  }
}