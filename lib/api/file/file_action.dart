import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileAction {
//========== Save File ==========
  static Future<File> saveFile({
    required String name,
    required dynamic document,
  }) async {
    final bytes = await document.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

//========== Open File ==========
  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
