import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_system/models/models.dart';

class Invoice extends Equatable {
  final String invoiceNumber;
  final String date;
  final String author;
  final String invoicePdfUrl;
  final List<Product> items;

  const Invoice({
    this.invoiceNumber,
    this.date,
    this.author,
    this.invoicePdfUrl,
    this.items,
  });

  @override
  List<Object> get props => [invoiceNumber, date, author, invoicePdfUrl, items];

  factory Invoice.fromDoc(DocumentSnapshot doc) {
    return Invoice(
      invoiceNumber: doc.id,
      date: doc['date'] ?? '',
      author: doc['author'] ?? '',
      invoicePdfUrl: doc['invoicePdfUrl'],
      //items: doc['items'] ?? [],
    );
  }

  Map<String, dynamic> toDocoment() {
    return {
      'date': date,
      'author': author,
      'invoiceNumber': invoiceNumber,
      //'items': items,
      'invoicePdfUrl': invoicePdfUrl,
    };
  }
}
