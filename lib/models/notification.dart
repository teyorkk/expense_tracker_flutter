import 'dart:convert';

class BudgetNotification {
  final String id;
  final String category;
  final double budget;
  final double spent;
  final DateTime timestamp;
  final bool isRead;

  BudgetNotification({
    required this.id,
    required this.category,
    required this.budget,
    required this.spent,
    required this.timestamp,
    this.isRead = false,
  });

  BudgetNotification copyWith({
    String? id,
    String? category,
    double? budget,
    double? spent,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return BudgetNotification(
      id: id ?? this.id,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'budget': budget,
      'spent': spent,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory BudgetNotification.fromJson(Map<String, dynamic> json) {
    return BudgetNotification(
      id: json['id'] as String,
      category: json['category'] as String,
      budget: (json['budget'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
