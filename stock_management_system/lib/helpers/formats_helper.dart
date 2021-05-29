import 'package:intl/intl.dart';

class Formats {
  /// returns price containing only 2 numbers after the comma
  static priceFormat(double price) => '\R ${price.toStringAsFixed(2)}';

  /// returns date in format, '/day/month/year
  static dateFormat() {
    final dateTime = DateTime.now();
    final dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }
}
