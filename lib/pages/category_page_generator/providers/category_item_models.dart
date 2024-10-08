import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db.dart';
import '../models/category_item_model.dart';

class CategoryItemModels extends StateNotifier<List<CategoryItemModel>> {
  CategoryItemModels() : super([]);

  Future<void> get() async {
    if (state.isEmpty) {
      List<Map<String, dynamic>> results =
          await getData(DataBaseName.categoryItems);
      state = [
        for (Map<String, dynamic> map in results)
          CategoryItemModel.fromMap(queryMap: map)
      ];
    }
  }

  Future<void> add(CategoryItemModel model) async {
    List<Map<String, dynamic>> results =
        await insertData(DataBaseName.categoryItems, model.toMap());
    state = [
      for (Map<String, dynamic> map in results)
        CategoryItemModel.fromMap(queryMap: map)
    ];
    // state = [...state, model];
  }

  void set(List<CategoryItemModel> models) {
    state = [...models];
  }

  Future<void> replace(CategoryItemModel model) async {
    await insertOrReplaceData(DataBaseName.categoryItems, model.toMap());
    state = [for (final s in state) (s.itemCode == model.itemCode) ? model : s];
  }

  Future<void> allEdit() async {
    List<Map<String, dynamic>> results = [];
    for (var element in state) {
      results = await insertOrReplaceData(
          DataBaseName.categoryItems, element.toMap());
    }
    debugPrint(results.length.toString());
    state = [for (var map in results) CategoryItemModel.fromMap(queryMap: map)];
  }
}
