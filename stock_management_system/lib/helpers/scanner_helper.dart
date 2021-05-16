import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stock_management_system/models/models.dart';

/// This is a Scanner class for both Barcode and QR code.
class ScannerHelper {
  static Future<String> barcodeScanner({@required BuildContext context}) async {
    try {
      final String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'cancel',
        true,
        ScanMode.DEFAULT,
      );

      if (barcodeScanRes != null) {
        return barcodeScanRes;
      }
    } on Failure catch (err) {
      //context.read<ShippingInCubit>().onFailure(err);
      print(' FJHSDFJHSDFJH  ASDHFJSHDFJSD   DSJHFJSDH' + '$err');
    }
    return null;
  }
}
