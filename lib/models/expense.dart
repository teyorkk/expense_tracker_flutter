import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  transport,
  entertainment,
  shopping,
  bills,
  health,
  education,
  other,
}

class Expense {
  final String? id;
  final String description;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final bool isIncome;

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    this.isIncome = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.toString().split('.').last,
      'isIncome': isIncome ? 1 : 0,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == 'ExpenseCategory.${json['category']}',
      ),
      isIncome: json['isIncome'] == 1,
    );
  }

  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    ExpenseCategory? category,
    bool? isIncome,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}
