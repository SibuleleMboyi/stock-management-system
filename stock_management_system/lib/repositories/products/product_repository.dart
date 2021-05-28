import 'package:flutter/material.dart';
import 'package:stock_management_system/config/configs.dart';
import 'package:stock_management_system/helpers/helpers.dart';
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

  Future<List<Product>> availableProducts() async {
    final productsSnapShot =
        await _firebaseFirestore.collection(Paths.products).get();

    final productsList =
        productsSnapShot.docs.map((doc) => Product.fromDocument(doc)).toList();

    return productsList;
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
    final doc = await _firebaseFirestore
        .collection(Paths.cart)
        .doc(product.productBarCode)
        .get();
    if (doc.exists) {
      await _firebaseFirestore
          .collection(Paths.cart)
          .doc(product.productBarCode)
          .update({'quantity': product.quantity + doc['quantity']});
    } else {
      await _firebaseFirestore
          .collection(Paths.cart)
          .doc(product.productBarCode)
          .set(product.toDocument());
    }
  }

  @override
  Future<void> removeFromCart({@required productBarCode}) async {
    await _firebaseFirestore
        .collection(Paths.cart)
        .doc(productBarCode)
        .delete();
  }

  /// Returns a list of cart products
  Future<List<Product>> fetchProductsFromCart() async {
    final cartProductsSnapshot =
        await _firebaseFirestore.collection(Paths.cart).get();
    return cartProductsSnapshot.docs
        .map((doc) => Product.fromDocument(doc))
        .toList();
  }

  /// This methods fetches all the products that are available in the cart.
  /// Loops at each product item, checks if it already exists in the sold items,
  /// if yes, updates the 'quantity', the number of times this item has been bought.
  /// Otherwise it adds this
  ///  adds it to the collection of the bought items.
  /// The delete all the items that were in the cart, leaving the cart empty for a new transaction.
  @override
  Future<void> buyProducts(
      {@required String transactionDate, @required String cashierId}) async {
    String date = Formats.dateFormat();
    final productsSnapshot =
        await _firebaseFirestore.collection(Paths.cart).get();

    // adds products from the cart collection into the sold items collection.
    productsSnapshot.docs.forEach((doc) async {
      final docSnapshot = await _firebaseFirestore
          .collection(Paths.purchased_products)
          .doc(cashierId)
          .collection(date)
          .doc(doc.id)
          .get();

      if (docSnapshot.exists) {
        _firebaseFirestore
            .collection(Paths.purchased_products)
            .doc(cashierId)
            .collection(date)
            .doc(doc.id)
            .update(
                {'quantity': docSnapshot.data()['quantity'] + doc['quantity']});
      } else {
        _firebaseFirestore
            .collection(Paths.purchased_products)
            .doc(cashierId)
            .collection(date)
            .doc(doc.id)
            .set(doc.data());
      }

      // deletes this document from the cart
      doc.reference.delete();
    });

    // iterates through the cart snapshot,
    // and deletes each cart product
    //productsSnapshot.docs.forEach((doc) => doc.reference.delete());
  }
}
