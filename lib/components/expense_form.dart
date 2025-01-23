import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  DateTime? chosenDate;
  @override
  Widget build(BuildContext context) {
    final _expenseTitleController = TextEditingController();
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

        const Gap(24),

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
        )
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
}