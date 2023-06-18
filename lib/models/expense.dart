import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
var formatter = DateFormat.yMd();

enum Category { food, leisure, travel, work }

class Expense {
  final icons = {
    Category.food: Icons.lunch_dining,
    Category.leisure: Icons.movie,
    Category.travel: Icons.flight_takeoff,
    Category.work: Icons.work
  };
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  String get formattedDate {
    return formatter.format(date);
  }
}
