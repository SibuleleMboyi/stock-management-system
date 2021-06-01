import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_system/config/configs.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/storage/base_repository.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  StorageRepository({
    FirebaseStorage firebaseStorage,
    FirebaseFirestore firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<String> uploadPdfToDatabase(
      {@required File pdf, @required Transaction_ transaction}) async {
    final downloadUrl = await _firebaseStorage
        .ref('invoices/' + transaction.transactionNumber + '.pdf')
        .putFile(pdf)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

    final invoiceDocument = Transaction_(
      transactionNumber: transaction.transactionNumber,
      date: transaction.date,
      author: transaction.author,
      transactionPdfUrl: downloadUrl,
    );
    await _firebaseFirestore
        .collection(Paths.transactions)
        .doc(invoiceDocument.transactionNumber)
        .set(invoiceDocument.toDocoment());

    return downloadUrl;
  }

  @override
  Future<File> pdfs({@required Transaction_ transaction}) async {
    final refPDF = _firebaseStorage.ref('invoices/').child('11.pdf');
    final bytes = await refPDF.getData();
    return PdfDownload.storeFile(
      transaction: transaction,
      bytes: bytes,
    );
  }
}
