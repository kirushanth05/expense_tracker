import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
    super.key,
    required this.onAddExpense,
    this.expense,
    this.onEditExpense,
  });

  final void Function(Expense expense) onAddExpense;
  final void Function(Expense expense)? onEditExpense;
  final Expense? expense;

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  DateTime? chosenDate;
  final _expenseTitleController = TextEditingController();
  final _amountController = TextEditingController();
  Category expenseCategory = Category.others;
  String categoryName = Category.others.name;

  List<DropdownMenuItem> dropdownItems = Category.values
      .map(
        (category) => DropdownMenuItem(
          value: category.name,
          child: Text(category.name.toUpperCase()),
        ),
      )
      .toList();

  @override
  void initState() {
    if (widget.expense != null) {
      final receivedExpense = widget.expense!;

      chosenDate = receivedExpense.date;
      _expenseTitleController.text = receivedExpense.title;
      _amountController.text = receivedExpense.amount.toString();
      expenseCategory = receivedExpense.category;
      categoryName = receivedExpense.category.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // title input
        TextField(
          controller: _expenseTitleController,
          decoration: const InputDecoration(
            label: Text('Expense Title'),
            // hintText: 'Expense Title',
          ),
        ),

        const Gap(16),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(1, 2),
                        blurRadius: 3)
                  ]),
              child: GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await _showDatePicker(context);
                  setState(() {
                    chosenDate = pickedDate;
                  });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Choose date :'),
                    Icon(Icons.calendar_month_rounded),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (chosenDate != null)
              Text(
                  'Selected date : ${DateFormat('dd/MM/yyyy').format(chosenDate!)}'),
          ],
        ),

        const Gap(8),

        Row(
          children: [
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                controller: _amountController,
                decoration: const InputDecoration(
                  label: Text('Amount'),
                  // hintText: 'Expense Title',
                ),
              ),
            ),
            const Spacer(),
            DropdownButton(
              value: categoryName,
              items: dropdownItems,
              onChanged: (value) {
                final selectedCategory = Category.values.firstWhere(
                    (category) =>
                        category.name.toLowerCase() ==
                        value.toString().toLowerCase());

                setState(() {
                  expenseCategory = selectedCategory;
                  categoryName = selectedCategory.name;
                });
              },
            ),
          ],
        ),

        const Gap(32),

        TextButton(
          onPressed: widget.expense != null
              ? () {
                  if (!isValidInput()) return;
                  widget.expense!.title = _expenseTitleController.text.trim();
                  widget.expense!.amount =
                      double.parse(_amountController.text.trim());
                  widget.expense!.date = chosenDate!;
                  widget.expense!.category = expenseCategory;

                  widget.onEditExpense!(widget.expense!);
                  Navigator.pop(context);
                }
              : createExpense,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.expense != null ? Icons.edit : Icons.add),
              const Gap(8),
              Text('${widget.expense != null ? 'Edit' : 'Add'} Expense'),
            ],
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    final currentDate = DateTime.now();
    final maxAllowedDate =
        DateTime(currentDate.year - 1, currentDate.month, currentDate.day);

    DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: maxAllowedDate, lastDate: currentDate);

    return pickedDate;
  }

  void createExpense() {
    // validate user input
    if (!isValidInput()) return;

    final expenseObj = Expense(
        title: _expenseTitleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: chosenDate!,
        category: expenseCategory);

    widget.onAddExpense(expenseObj);

    Navigator.pop(context);
  }

  bool isValidInput() {
    final title = _expenseTitleController.text;
    final amount = _amountController.text;

    if (title.trim().isEmpty || amount.trim().isEmpty || chosenDate == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Error!',
              style: TextStyle(color: Colors.red.shade300),
            ),
            content: const Text('Expense Title, Amount and Date are required!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Close'),
              ),
            ],
            // icon: Icon(Icons.warning),
          );
        },
      );

      return false;
    }

    return true;
  }
}