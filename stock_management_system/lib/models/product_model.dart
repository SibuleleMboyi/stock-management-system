import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String productBarCode;
  final String productName;
  final String productBrand;
  final int quantity;
  final int price;

  Product({
    this.productBarCode,
    this.productName,
    this.productBrand,
    this.quantity,
    this.price,
  });

  @override
  List<Object> get props =>
      [productBarCode, productName, productBrand, quantity];

  Map<String, dynamic> toDocument() {
    return {
      'productBarCode': productBarCode,
      'productName': productName,
      'productBrand': productBrand,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Product.fromDocument(DocumentSnapshot doc) => Product(
        productBarCode: doc['productBarCode'] ?? '',
        productName: doc['productName'] ?? '',
        productBrand: doc['productBrand'] ?? '',
        quantity: (doc['quantity'] ?? 0).toInt(),
        price: (doc['price'] ?? 0).toInt(),
      );

  Product copyWith({
    String productBarCode,
    String productName,
    String productBrand,
    int quantity,
    int price,
  }) {
    return Product(
      productBarCode: productBarCode ?? this.productBarCode,
      productName: productName ?? this.productName,
      productBrand: productBrand ?? this.productBrand,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
