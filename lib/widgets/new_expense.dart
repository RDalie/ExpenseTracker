import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.addExpenseToList, super.key});
  final void Function(Expense expense) addExpenseToList;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _expenseAmountController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_expenseAmountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text.isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //throw error
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and country are entered'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Ok'))
                ],
              ));
      return;
    }

    Expense newExpense = Expense(
        amount: enteredAmount,
        category: _selectedCategory,
        date: _selectedDate!,
        title: _titleController.text);

    widget.addExpenseToList(newExpense);
    Navigator.pop(context);
  }

  Future<void> _presentDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 1095)),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(children: [
              if (width >= 600)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(label: Text('Title')),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _expenseAmountController,
                        maxLength: 20,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          label: Text('Expense Amount'),
                        ),
                      ),
                    )
                  ],
                )
              else
                TextField(
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Title')),
                ),
              if (width >= 600)
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase())))
                          .toList(),
                      onChanged: (value) => setState(() {
                        if (value == null) {
                          return;
                        }
                        _selectedCategory = value;
                      }),
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? 'No selected date'
                            : DateFormat.yMd().format(_selectedDate!)),
                        IconButton(
                            onPressed: () async {
                              await _presentDatePicker(context);
                            },
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ))
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _expenseAmountController,
                        maxLength: 20,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          label: Text('Expense Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? 'No selected date'
                            : DateFormat.yMd().format(_selectedDate!)),
                        IconButton(
                            onPressed: () async {
                              await _presentDatePicker(context);
                            },
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ))
                  ],
                ),
              if (width >= 600)
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _submitExpense();
                        },
                        child: const Text('Save Expense'))
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase())))
                          .toList(),
                      onChanged: (value) => setState(() {
                        if (value == null) {
                          return;
                        }
                        _selectedCategory = value;
                      }),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _submitExpense();
                        },
                        child: const Text('Save Expense'))
                  ],
                )
            ]),
          ),
        ),
      );
    });
  }
}
