import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_system/repositories/storage/base_repository.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadPdfToDatabase({@required File pdf}) async {
    final downloadUrl = await _firebaseStorage
        .ref('invoices/invoice.pdf') //TODO: store invoice by Invoice Number
        .putFile(pdf)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

    return downloadUrl;
  }
}
