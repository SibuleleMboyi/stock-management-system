import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class SavePdf {
  static String path;
  static Future<File> savePdfToLocalStorage({
    @required String name,
    @required Document document,
  }) async {
    final bytes = await document.save();
    final dir = await getExternalStorageDirectory();
    path = dir.path + '/' + name;
    final file = File(path);

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile({@required File file}) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static String filePath() {
    return (path);
  }
}
