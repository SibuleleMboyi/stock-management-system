import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_system/config/configs.dart';
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
      {@required File pdf, @required Invoice invoice}) async {
    final downloadUrl = await _firebaseStorage
        .ref('invoices/' +
            invoice.invoiceNumber +
            '.pdf') //TODO: store invoice by Invoice Number
        .putFile(pdf)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

    final invoiceDocument = Invoice(
      invoiceNumber: invoice.invoiceNumber,
      date: invoice.date,
      author: invoice.author,
      invoicePdfUrl: downloadUrl,
    );
    await _firebaseFirestore
        .collection(Paths.invoices)
        .doc(invoiceDocument.invoiceNumber)
        .set(invoiceDocument.toDocoment());

    return downloadUrl;
  }
}
