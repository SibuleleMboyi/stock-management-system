import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewPageScreen extends StatelessWidget {
  final String transactionPdfUrl;

  const PdfViewPageScreen({Key key, @required this.transactionPdfUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
      ),
      body: PDF().fromUrl(
        transactionPdfUrl,
        placeholder: (double progress) => const LinearProgressIndicator(),
      ),
    );
  }
}
