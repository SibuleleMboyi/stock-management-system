import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stock_management_system/models/models.dart';

class Transaction_ extends Equatable {
  final String transactionNumber;
  final String date;
  final String author;
  final String transactionPdfUrl;
  final List<Product> items;

  const Transaction_({
    this.transactionNumber,
    this.date,
    this.author,
    this.transactionPdfUrl,
    this.items,
  });

  @override
  List<Object> get props =>
      [transactionNumber, date, author, transactionPdfUrl, items];

  factory Transaction_.fromDocument(DocumentSnapshot doc) {
    return Transaction_(
      transactionNumber: doc.id,
      date: doc['date'] ?? '',
      author: doc['author'] ?? '',
      transactionPdfUrl: doc['transactionPdfUrl'],
      //items: doc['items'] ?? [],
    );
  }

  Map<String, dynamic> toDocoment() {
    return {
      'date': date,
      'author': author,
      'transactionNumber': transactionNumber,
      //'items': items,
      'transactionPdfUrl': transactionPdfUrl,
    };
  }
}
