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

  Future<void> categoryDelete(int categoryId) async {
    final searched = state.where((e) => [
          e.categoryId1,
          e.categoryId2,
          e.categoryId3,
          e.categoryId4,
          e.categoryId5,
          e.categoryId6
        ].contains(categoryId));
    for (var model in searched) {
      List<int?> categoryIds = [
        model.categoryId1,
        model.categoryId2,
        model.categoryId3,
        model.categoryId4,
        model.categoryId5,
        model.categoryId6
      ];
      categoryIds.remove(categoryId);
      categoryIds.whereType<int>().toList();
      model.categoryId1 = null;
      model.categoryId2 = null;
      model.categoryId3 = null;
      model.categoryId4 = null;
      model.categoryId5 = null;
      model.categoryId6 = null;
      for (var i = 0; i < categoryIds.length; i++) {
        switch (i) {
          case 0:
            model.categoryId1 = categoryIds[i];
            break;
          case 1:
            model.categoryId2 = categoryIds[i];
            break;
          case 2:
            model.categoryId3 = categoryIds[i];
            break;
          case 3:
            model.categoryId4 = categoryIds[i];
            break;
          case 4:
            model.categoryId5 = categoryIds[i];
            break;
          case 5:
            model.categoryId6 = categoryIds[i];
            break;
          default:
            break;
        }
      }
      await updateData(DataBaseName.categoryItems, model.toMap(),
          where: 'itemCode=?', whereArgs: [model.itemCode]);
    }
    state = [...state];
  }
}
