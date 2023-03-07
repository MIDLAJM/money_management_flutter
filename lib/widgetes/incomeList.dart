import 'package:flutter/material.dart';
import 'package:money_management_flutter/dbFunctiones/categoryDb.dart';
import 'package:money_management_flutter/modeles/categoryModel.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB.instance.incomeListNotifierListener,
      builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final _category =newlist[index];
            return ListTile(
              title: Text(_category.name),
              trailing: IconButton(
                onPressed: () {
                  CategoryDB.instance.deleteCategory(_category.id);
                },
                icon: Icon(Icons.delete),
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
}
