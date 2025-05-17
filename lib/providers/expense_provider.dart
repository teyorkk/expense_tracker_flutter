import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';
import '../services/database_service.dart';

class ExpenseProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Expense> _expenses = [];
  Map<ExpenseCategory, double> _budgets = {};
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  List<Expense> get expenses => _expenses;
  Map<ExpenseCategory, double> get budgets => _budgets;
  DateTime get selectedDate => _selectedDate;

  ExpenseProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadExpenses();
    await loadBudgets();
  }

  Future<void> loadExpenses() async {
    try {
      _expenses = await _databaseService.getExpenses();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    }
  }

  Future<void> loadBudgets() async {
    try {
      final budgetsList = await _databaseService.getBudgets();
      _budgets = Map.fromEntries(
        budgetsList.map((budget) => MapEntry(budget.category, budget.amount)),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading budgets: $e');
    }
  }

  Future<void> addExpense(Expense expense, BuildContext context) async {
    try {
      final newExpense = expense.copyWith(
        id: _uuid.v4(),
        date: DateTime.now(),
      );

      await _databaseService.insertExpense(newExpense);
      await loadExpenses(); // Reload all expenses to ensure consistency

      if (context.mounted) {
        _checkBudgetExceedance(newExpense, context);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding expense: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add expense. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> updateExpense(Expense expense, BuildContext context) async {
    try {
      await _databaseService.updateExpense(expense);
      await loadExpenses(); // Reload all expenses to ensure consistency

      if (context.mounted) {
        _checkBudgetExceedance(expense, context);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating expense: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update expense. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _databaseService.deleteExpense(id);
      await loadExpenses(); // Reload all expenses to ensure consistency
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting expense: $e');
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await _databaseService.insertBudget(budget);
      await loadBudgets(); // Reload all budgets to ensure consistency
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding budget: $e');
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _databaseService.updateBudget(budget);
      await loadBudgets(); // Reload all budgets to ensure consistency
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _databaseService.deleteBudget(id);
      await loadBudgets(); // Reload all budgets to ensure consistency
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting budget: $e');
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Expense> getExpensesForDate(DateTime date) {
    return _expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month &&
              expense.date.day == date.day,
        )
        .toList();
  }

  List<Expense> getExpensesForMonth(DateTime date) {
    return _expenses
        .where(
          (expense) =>
              expense.date.year == date.year &&
              expense.date.month == date.month,
        )
        .toList();
  }

  double getTotalExpensesForMonth(DateTime date) {
    return getExpensesForMonth(date)
        .where((expense) => !expense.isIncome)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double getTotalIncomeForMonth(DateTime date) {
    return getExpensesForMonth(date)
        .where((expense) => expense.isIncome)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<ExpenseCategory, double> getCategoryTotalsForMonth(DateTime date) {
    Map<ExpenseCategory, double> totals = {};
    for (var expense in getExpensesForMonth(date).where((e) => !e.isIncome)) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  Future<void> setBudget(
      ExpenseCategory category, double amount, BuildContext context) async {
    try {
      final budget = Budget(
        category: category,
        amount: amount,
        month: DateTime.now(),
      );
      await addBudget(budget);
      if (context.mounted) {
        _checkAllBudgets(context);
      }
    } catch (e) {
      debugPrint('Error setting budget: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to set budget. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double getCategoryTotal(ExpenseCategory category) {
    return _expenses
        .where((expense) => expense.category == category && !expense.isIncome)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  void _checkBudgetExceedance(Expense expense, BuildContext context) {
    if (expense.isIncome) return;

    final budget = _budgets[expense.category];
    if (budget == null) return;

    final categoryExpenses = _expenses
        .where((e) => e.category == expense.category && !e.isIncome)
        .toList();
    final totalSpent = categoryExpenses.fold<double>(
        0, (sum, expense) => sum + expense.amount);

    if (totalSpent > budget) {
      final notification = BudgetNotification(
        id: _uuid.v4(),
        category: expense.category.toString().split('.').last,
        budget: budget,
        spent: totalSpent,
        timestamp: DateTime.now(),
      );
      context.read<NotificationProvider>().addNotification(notification);
    }
  }

  void _checkAllBudgets(BuildContext context) {
    for (final category in ExpenseCategory.values) {
      final budget = _budgets[category];
      if (budget == null) continue;

      final categoryExpenses = _expenses
          .where((e) => e.category == category && !e.isIncome)
          .toList();
      final totalSpent = categoryExpenses.fold<double>(
          0, (sum, expense) => sum + expense.amount);

      if (totalSpent > budget) {
        final notification = BudgetNotification(
          id: _uuid.v4(),
          category: category.toString().split('.').last,
          budget: budget,
          spent: totalSpent,
          timestamp: DateTime.now(),
        );
        context.read<NotificationProvider>().addNotification(notification);
      }
    }
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
