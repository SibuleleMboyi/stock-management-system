import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/helpers/pdf_save_helper.dart';
import 'package:stock_management_system/models/models.dart';

class InvoiceDocument {
  static Future<File> generateDocument({@required Invoice invoice}) async {
    final document = Document();
    document.addPage(MultiPage(
        build: (context) => [
              buildTitle(invoice: invoice),
              buildInvoice(invoice: invoice),
              Divider(),
              buildTotal(invoice: invoice),
            ]));

    return SavePdf.savePdfToLocalStorage(
        name: 'my_pdf_invoice.pdf', document: document);
  }

  /* Widget buildHeader({@required Invoice invoice}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];

    /// TODO:: Change this data accordingly
    final data = <String>[
      info.number,
      Formats.dateFormat(),
      paymentTerms,
      Formats.dateFormat(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  Widget buildCustomerAddress(Customer customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(customer.address),
      ],
    );
  }

  Widget buildSupplierAddress(Supplier supplier) {
    return Column(children: [
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address),
    ]);
  }
 */
  static Widget buildTitle({@required Invoice invoice}) {
    return Column(children: [
      Text(
        'TRANSACTION',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text('Transaction Number: ' + invoice.invoiceNumber),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('Transaction Date: ' + invoice.date),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildInvoice({@required Invoice invoice}) {
    final headers = ['Description', 'Quantity', 'Unit Price', 'VAT', 'Total'];

    //TODO :: Each product must have it's own 'vat' Edit Product model
    //final total = item.unitPrice * item.quantity * (1 + item.vat);

    final data = invoice.items.map((item) {
      final total = item.price * item.quantity * (1 + 0.2);
      final vat = 0.21;
      return [
        item.productName,
        //Formats.dateFormat(),
        '${item.quantity}',
        '\R ${item.price}',
        '$vat %',
        '\R ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal({@required Invoice invoice}) {
    final netTotal = invoice.items
        .map((item) => item.price * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    // TODO : Perform these accounting calculations
    final vatPercent = 1.0;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Formats.priceFormat(netTotal.toDouble()),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Formats.priceFormat(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Formats.priceFormat(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
