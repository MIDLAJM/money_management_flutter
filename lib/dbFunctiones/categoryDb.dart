import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management_flutter/modeles/categoryModel.dart';

const _CATEGORY_DB_NAME = 'Category DataBase';

abstract class CategoryFunctios {
  Future<void> insertCategory(CategoryModel value);
  Future<List<CategoryModel>> getAllCategory();
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryFunctios {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeListNotifierListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expanseListNotifierListener =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    await _categoryDb.put(value.id, value);
    RefrushUI();
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    return _categoryDb.values.toList();
  }

  Future<void> RefrushUI() async {
    final _allCategoryes = await getAllCategory();
    incomeListNotifierListener.value.clear();
    expanseListNotifierListener.value.clear();
    await Future.forEach(
      _allCategoryes,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeListNotifierListener.value.add(category);
        } else {
          expanseListNotifierListener.value.add(category);
        }
      },
    );
    incomeListNotifierListener.notifyListeners();
    expanseListNotifierListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(_CATEGORY_DB_NAME);
    await _categoryDb.delete(categoryID);
    RefrushUI();
  }
}
