import 'package:flutter/material.dart';
import 'package:stock_management_system/config/paths.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/products/base_products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // NOTE:: The unique key of each product is it's barcode or QR code.
  // Throughtout this project, the product's barcode code or QR code use the same variable

  /// Checks if the product is available in the stock
  /// returns it if yes,
  /// Otherwise returns null.
  @override
  Future<Product> isProductAvailable({@required String productBarCode}) async {
    DocumentSnapshot doc = await _firebaseFirestore
        .collection(Paths.products)
        .doc(productBarCode)
        .get();

    if (doc.exists) {
      return Product.fromDocument(doc);
    }
    return null;
  }

  /// This methods adds a new stock product into Firebase Firestore database.
  /// Because it is called after isProductAvailable(),
  /// so there is no need to again check if the
  /// product is already in the database.
  @override
  Future<void> addNewStockProduct({@required Product product}) async {
    await _firebaseFirestore
        .collection(Paths.products)
        .doc(product.productBarCode)
        .set(product.toDocument());
  }

  /// This function updates an already available product in the Firebase Firestore database
  /// Because it is called after isProductAvailable() ?, so there is no need to again check if the
  /// product is in the database.
  @override
  Future<void> updateStockProduct({@required Product product}) async {
    DocumentSnapshot doc = await _firebaseFirestore
        .collection(Paths.products)
        .doc(product.productBarCode)
        .get();
    await _firebaseFirestore
        .collection(Paths.products)
        .doc(product.productBarCode)
        .set({
      'quantity': doc['quantity'] + product.quantity,
      'price': doc['price'] + product.price,
    });
  }

  @override
  Future<void> addProductToCart({@required Product product}) async {
    await _firebaseFirestore
        .collection(Paths.cart)
        .doc(product.productBarCode)
        .set(product.toDocument());
  }

  @override
  Future<void> removeFromCart({@required productBarCode}) async {
    await _firebaseFirestore
        .collection(Paths.cart)
        .doc(productBarCode)
        .delete();
  }

  /// This methods fetches all the products that are available in the cart.
  /// Loops at each product item, adds it to the collection of the bought items.
  /// The delete all the items that were in the cart, leaving the cart empty for a new transaction.
  @override
  Future<void> buyProducts(
      {@required transactionDate, @required String cashierId}) async {
    final productsSnapshot =
        await _firebaseFirestore.collection(Paths.cart).get();

    // adds products from the cart collection into the bought items collection.
    productsSnapshot.docs.map((doc) => _firebaseFirestore
        .collection(Paths.purchased_products)
        .doc(cashierId)
        .collection(Paths.transactions)
        .add(doc.data()));

    // iterates through the returned query snapshot,
    // and deletes each document
    productsSnapshot.docs.map((doc) => doc.reference.delete());
  }
}
