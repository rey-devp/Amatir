import 'package:intl/intl.dart';

class AppFormatter {
  /// Formats a double price into Indonesian Rupiah (Rp) format.
  /// Example: 15000 -> Rp 15.000
  static String formatCurrency(double price) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(price);
  }

  /// Formats a DateTime object into a readable string.
  /// Example: 2024-03-20 10:30 -> 20 Mar 2024, 10:30
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Formats a DateTime object into a short date string.
  /// Example: 2024-03-20 -> 20/03/24
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }
}
