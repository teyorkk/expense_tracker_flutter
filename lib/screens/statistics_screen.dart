import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final expenses = provider.expenses;
          final monthlyExpenses = provider.getTotalExpensesForMonth(
            DateTime.now(),
          );
          final monthlyIncome = provider.getTotalIncomeForMonth(DateTime.now());
          final categoryTotals = provider.getCategoryTotalsForMonth(
            DateTime.now(),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, monthlyIncome, monthlyExpenses),
                const SizedBox(height: 24),
                Text(
                  'Spending by Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: categoryTotals.isEmpty
                      ? Center(
                          child: Text(
                            'No expenses this month',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : PieChart(
                          PieChartData(
                            sections: _createPieChartSections(
                              context,
                              categoryTotals,
                              monthlyExpenses,
                            ),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Category Breakdown',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...categoryTotals.entries.map(
                  (entry) => _buildCategoryBar(
                    context,
                    entry.key,
                    entry.value,
                    monthlyExpenses,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double income,
    double expenses,
  ) {
    final savings = income - expenses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              context,
              'Income',
              Formatters.formatCurrency(income),
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              context,
              'Expenses',
              Formatters.formatCurrency(expenses),
              Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              context,
              'Savings',
              Formatters.formatCurrency(savings),
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createPieChartSections(
    BuildContext context,
    Map<ExpenseCategory, double> categoryTotals,
    double totalExpenses,
  ) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return categoryTotals.entries.map((entry) {
      final index = entry.key.index % colors.length;
      return PieChartSectionData(
        value: entry.value,
        title: Formatters.getCategoryName(entry.key),
        color: colors[index],
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryBar(
    BuildContext context,
    ExpenseCategory category,
    double amount,
    double totalExpenses,
  ) {
    final percentage = (amount / totalExpenses) * 100;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.getCategoryName(category),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: amount / totalExpenses,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatCurrency(amount),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
