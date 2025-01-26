import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { bills, food, leisure, work, transportation, others }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  String title;
  double amount;
  DateTime date;
  Category category;
}