import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_flutter/dbFunctiones/TransactionDb.dart';
import 'package:money_management_flutter/dbFunctiones/categoryDb.dart';
import 'package:money_management_flutter/modeles/categoryModel.dart';
import 'package:money_management_flutter/modeles/transaction/transactionModal.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.RefrushUI();
    CategoryDB.instance.RefrushUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactioListNotifier,
      builder: (BuildContext ctx, List<TransactionModal> newlist, Widget? _) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final _transaction = newlist[index];
            return Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _transaction.type == CategoryType.income
                      ? Colors.green
                      : Colors.red,
                  radius: 50,
                  child: Text(
                    parseDate(_transaction.date),
                    textAlign: TextAlign.center,
                  ),
                ),
                title: Text(_transaction.category.name),
                subtitle: Text('RS ${_transaction.amount}'),
                trailing: IconButton(
                  onPressed: () {
                    TransactionDB.instance.deleteTransaction(_transaction.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          itemCount: newlist.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitdate = _date.split(' ');
   return '${_splitdate.last}\n ${_splitdate.first}';
   // return '${date.day}\n ${date.month}';
  }
}
