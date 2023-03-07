import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_flutter/modeles/transaction/transactionModal.dart';

const _TRANSACTION_DB_NAME = 'Transaction DataBase';

abstract class TransactionFunction {
  Future<void> addTransaction(TransactionModal obj);
  Future<List<TransactionModal>> getAllTransaction();
  Future<void> deleteTransaction(transactionID);
}

class TransactionDB implements TransactionFunction {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModal>> transactioListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModal obj) async {
    final _TransactioDb =
        await Hive.openBox<TransactionModal>(_TRANSACTION_DB_NAME);
    await _TransactioDb.put(obj.id, obj);
    RefrushUI();
  }

  Future<void> RefrushUI() async {
    final _list = await getAllTransaction();
    _list.sort((first,second)=>second.date.compareTo(first.date));
    transactioListNotifier.value.clear();
    transactioListNotifier.value.addAll(_list);
    transactioListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModal>> getAllTransaction() async {
    final _TransactioDb =
        await Hive.openBox<TransactionModal>(_TRANSACTION_DB_NAME);
    return _TransactioDb.values.toList();
  }

  @override
  Future<void> deleteTransaction(transactionID) async {
    final _TransactioDb =
        await Hive.openBox<TransactionModal>(_TRANSACTION_DB_NAME);
       await _TransactioDb.delete(transactionID.toString());
       RefrushUI();
  }
}
