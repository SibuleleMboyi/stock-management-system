import 'package:flutter/material.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/helpers/pdf_save_helper.dart';
import 'package:stock_management_system/models/models.dart';

/// Contains historical transactions that can be filtered according to the user preferences

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/transactions';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('PDF View')),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: [
          TextButton(
            child: Center(child: Text('Invoice PDF')),
            onPressed: () async {
              final invoice = Invoice(items: [
                Product(
                  productBarCode: '000000000',
                  productName: 'Java',
                  productBrand: 'IDE',
                  quantity: 5,
                  price: 10,
                ),
                Product(
                  productBarCode: '0098730000',
                  productName: 'Java',
                  productBrand: 'IDE',
                  quantity: 5,
                  price: 7,
                ),
                Product(
                  productBarCode: '123400000',
                  productName: 'Green',
                  productBrand: 'Salad',
                  quantity: 5,
                  price: 1,
                ),
                Product(
                  productBarCode: '000232000',
                  productName: 'Olive',
                  productBrand: 'Light',
                  quantity: 5,
                  price: 2,
                ),
              ]);
              final pdfFile =
                  await InvoiceDocument.generateDocument(invoice: invoice);
              SavePdf.openFile(file: pdfFile);
            },
          )
        ]),
      ),
    );
  }
}
