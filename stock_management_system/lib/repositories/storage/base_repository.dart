import 'dart:io';

abstract class BaseStorageRepository {
  Future<String> uploadPdfToDatabase();
  Future<File> pdfs();
}
