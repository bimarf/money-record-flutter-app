import 'package:intl/intl.dart';

class AppFormat {
  static String date(String stringDate) {
    DateTime date = DateTime.parse(stringDate);
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  static String currency(String number) {
    return NumberFormat.currency(
      decimalDigits: 2,
      locale: 'id_ID',
      symbol: 'Rp ',
    ).format(double.parse(number));
  }
}
