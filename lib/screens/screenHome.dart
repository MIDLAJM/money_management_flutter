import 'package:flutter/material.dart';
import 'package:money_management_flutter/dbFunctiones/categoryDb.dart';
import 'package:money_management_flutter/modeles/categoryModel.dart';
import 'package:money_management_flutter/screens/categoryAddPopUp.dart';
import 'package:money_management_flutter/screens/screenAddTransaction.dart';
import 'package:money_management_flutter/screens/screenCategory.dart';
import 'package:money_management_flutter/screens/screenTransactio.dart';
import 'package:money_management_flutter/widgetes/bottomNavigation.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});
  static ValueNotifier<int> selectedValueNotifier = ValueNotifier(0);
  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: ValueListenableBuilder(
        valueListenable: selectedValueNotifier,
        builder: (BuildContext ctx, int newvalue, Widget? _) {
          return _pages[newvalue];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedValueNotifier.value == 0) {
            print('Add Transaction');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            print('Add category');
            showCategoryAddPopUp(context); 
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
