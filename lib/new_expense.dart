import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});
  final void Function(Expense) addExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  Expense? newExpense;
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;
  @override
  void dispose() {
    _titleInputController.dispose();
    _amountInputController.dispose();
    super.dispose();
  }

  void onSaveExpense() {
    final title = _titleInputController.text.trim();
    final amount = double.tryParse(_amountInputController.text);
    final amountIsInvalid = (amount == null || amount <= 0) ? true : false;
    if (title.isEmpty || amountIsInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Some fields are empty or the date is not picked...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    newExpense = Expense(
        title: _titleInputController.text,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory);
    widget.addExpense(newExpense!);
    Navigator.pop(context);
  }

  void _pickDate() async {
    final _now = DateTime.now();
    final _firstDate = DateTime(_now.year - 1, _now.month, _now.day);
    var currentDate = await showDatePicker(
        context: context,
        initialDate: _now,
        firstDate: _firstDate,
        lastDate: _now);
    setState(() {
      _selectedDate = currentDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxwidth = constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardHeight + 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (maxwidth > 600)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleInputController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Label'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountInputController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleInputController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Label'),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountInputController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (_selectedDate == null)
                                ? 'No Date Selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _pickDate,
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null) return;
                            _selectedCategory = value;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onSaveExpense();
                      },
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
