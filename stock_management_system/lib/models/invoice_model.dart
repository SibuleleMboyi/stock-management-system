import 'package:flutter/material.dart';
import 'package:stock_management_system/models/models.dart';

class Invoice {
/*   final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer; */
  final List<Product> items;

  const Invoice({
/*     @required this.info,
    @required this.supplier,
    @required this.customer, */
    @required this.items,
  });
}

/* class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    @required this.description,
    @required this.number,
    @required this.date,
    @required this.dueDate,
  }); 
}
*/
