import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stock_management_system/models/models.dart';

class PdfDownload {
  static String urlPath = '';

  static Future<File> getPdfFromUrl(
      {@required String url, @required String transactionNumber}) async {
    try {
      final data = await http.get(Uri.parse(url));
      final bytes = data.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/" + transactionNumber + ".pdf");
      print(dir.path);
      final fileUrl = await file.writeAsBytes(bytes);
      return fileUrl;
    } catch (error) {
      print(error.toString());
      throw Exception("Error opening url file");
    }
  }

  static Future<String> getFilePath(
      {@required String url, @required String transactionNumber}) async {
    return await getPdfFromUrl(url: url, transactionNumber: transactionNumber)
        .then((value) {
      if (value != null) {
        return value.path;
      } else {
        return null;
      }
    });
  }

  static Future<File> storeFile(
      {@required Transaction_ transaction, @required List<int> bytes}) async {
    //final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/${transaction.transactionNumber}' + '.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
