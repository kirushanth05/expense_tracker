import 'package:expense_tracker/components/expense_card.dart';
import 'package:expense_tracker/components/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Expense> expenses = [
    Expense(
      title: 'Broadband Payment',
      amount: 15.00,
      date: DateTime.now(),
      category: Category.bills,
    ),
    Expense(
      title: 'Bus Fare',
      amount: 5.00,
      date: DateTime.now(),
      category: Category.transportation,
    ),
    Expense(
      title: 'Weekend Meeting',
      amount: 30.00,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title, subtitle and the add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense Tracker',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'manage expenses easily.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _showAddExpenseModalBottomSheet(context);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const Gap(30),

                // expense cards
                ...expenses.map((expense) => ExpenseCard(expense)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addExpense(Expense newExpense) {
    setState(() {
      expenses.add(newExpense);
    });
  }

  //  void addExpense(Expense newExpense) {
  void _showAddExpenseModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: ExpenseForm(
            onAddExpense: addExpense,
          ),
        );
      },
    );
  }
}
