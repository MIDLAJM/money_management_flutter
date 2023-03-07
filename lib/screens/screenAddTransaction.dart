import 'package:flutter/material.dart';
import 'package:money_management_flutter/dbFunctiones/TransactionDb.dart';
import 'package:money_management_flutter/dbFunctiones/categoryDb.dart';
import 'package:money_management_flutter/modeles/categoryModel.dart';
import 'package:money_management_flutter/modeles/transaction/transactionModal.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add transaction';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  final _purposeEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModal;
  String? _categoryID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD TRANSACTION'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //PURPOSE
            TextFormField(
              controller: _purposeEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'PURPOSE'),
            ),
            //AMOUNT
            TextFormField(
              controller: _amountEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'AMOUNT'),
            ),
            //DATETIME
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'SELECTED DATE'
                  : _selectedDate.toString()),
            ),
            //CATEGORY TYPE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newvalue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.income;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('INCOME'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newvalue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.expense;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('EXPANSE'),
                  ],
                ),
              ],
            ),
            //DROPDOWNBUTTON
            DropdownButton(
              hint: Text('SELECTED CATEGORY'),
              value: _categoryID,
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDB.instance.incomeListNotifierListener
                      : CategoryDB.instance.expanseListNotifierListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    _selectedCategoryModal = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                print(selectedValue);
                setState(() {
                  _categoryID = selectedValue;
                });
              },
            ),
            //submit button
            ElevatedButton(
              onPressed: () {
                addTransaction();
                Navigator.of(context).pop();
              },
              child: Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeEditingController.text;
    final _amountText = _amountEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_selectedCategoryModal == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    final _modal = TransactionModal(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModal!,
    );
    await TransactionDB.instance.addTransaction(_modal);
  }
}
