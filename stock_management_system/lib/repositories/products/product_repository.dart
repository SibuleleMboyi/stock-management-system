import 'package:flutter/material.dart';
import 'package:stock_management_system/config/paths.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/base_products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addNewStockProduct({@required Product product}) async {
    await _firebaseFirestore
        .collection(Paths.products)
        .add(product.toDocument());
  }

  @override
  Future<void> addToCart({@required Product product}) async {
    await _firebaseFirestore.collection(Paths.cart).add(product.toDocument());
  }
}
