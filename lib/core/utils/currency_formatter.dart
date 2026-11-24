import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _indianFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _compactIndianFormat = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
  );

  static String format(double amount, {bool showDecimals = true}) {
    if (!showDecimals) {
      return NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      ).format(amount);
    }
    return _indianFormat.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactIndianFormat.format(amount);
  }

  static String formatRate(double rate, String unit) {
    return '${format(rate)} / $unit';
  }
}

