import 'package:intl/intl.dart';
import '../models/expense.dart';

class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    symbol: 'PHP ',
    decimalDigits: 2,
  );

  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');
  static final _monthFormat = DateFormat('MMMM yyyy');

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatMonth(DateTime date) {
    return _monthFormat.format(date);
  }

  static String getCategoryName(ExpenseCategory category) {
    return category.toString().split('.').last.capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
