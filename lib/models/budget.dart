import 'package:flutter/material.dart';
import 'expense.dart';

class Budget {
  final int? id;
  final ExpenseCategory category;
  final double amount;
  final DateTime month;

  Budget({
    this.id,
    required this.category,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toString().split('.').last,
      'amount': amount,
      'month': month.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == 'ExpenseCategory.${json['category']}',
      ),
      amount: json['amount'].toDouble(),
      month: DateTime.parse(json['month']),
    );
  }

  Budget copyWith({
    int? id,
    ExpenseCategory? category,
    double? amount,
    DateTime? month,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      month: month ?? this.month,
    );
  }
}
