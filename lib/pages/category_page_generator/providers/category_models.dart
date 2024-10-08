import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db.dart';
import '../models/category_model.dart';

class CategoryModels extends StateNotifier<List<CategoryModel>> {
  CategoryModels() : super([]);

  Future<void> get() async {
    List<Map<String, dynamic>> results = await getData(DataBaseName.categories);
    state = [
      for (Map<String, dynamic> map in results) CategoryModel.fromMap(map)
    ];
  }

  Future<void> add(CategoryModel model) async {
    List<Map<String, dynamic>> results =
        await insertData(DataBaseName.categories, model.toMap());
    state = [
      for (Map<String, dynamic> map in results) CategoryModel.fromMap(map)
    ];
    // state = [...state, model];
  }

  void set(List<CategoryModel> models) {
    state = [...models];
  }

  Future<void> replace(CategoryModel model) async {
    await updateData(DataBaseName.categories, model.toMap(),
        where: 'id=?', whereArgs: [model.id]);
    state = [for (final s in state) (s.id == model.id) ? model : s];
  }

  Future<void> delete(CategoryModel model) async {
    await deleteData(DataBaseName.categories, where: 'id', args: [model.id!]);
    state = [
      for (final s in state)
        if (s.id != model.id) s
    ];
  }
}
