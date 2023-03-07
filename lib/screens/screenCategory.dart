import 'package:flutter/material.dart';
import 'package:money_management_flutter/dbFunctiones/categoryDb.dart';
import 'package:money_management_flutter/widgetes/expenes.dart';
import 'package:money_management_flutter/widgetes/incomeList.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB.instance.RefrushUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
          controller: _tabController,
          tabs: [
            Tab(text: 'INCOME'),
            Tab(text: 'EXPENSE'),
          ],
        ),
         Expanded(
           child: TabBarView(
            controller: _tabController,
            children: [
             IncomeCategoryList(),
            ExpanseCategoryList(),
            ],
                 ),
         ),
      ],
    );
  }
}
