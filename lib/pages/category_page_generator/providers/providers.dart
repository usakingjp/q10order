import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category_model.dart';
import '../models/category_item_model.dart';
import '../models/page_setting_model.dart';
import 'category_models.dart';
import 'category_item_models.dart';

final categories = StateNotifierProvider<CategoryModels, List<CategoryModel>>(
    (ref) => CategoryModels());
final categoryItems =
    StateNotifierProvider<CategoryItemModels, List<CategoryItemModel>>(
        (ref) => CategoryItemModels());
// final categoryItems = StateProvider<List<CategoryItemModel>>((ref) => []);
final pageSetting =
    StateProvider<PageSettingModel>((ref) => PageSettingModel());
final pageSettingM =
    StateProvider<PageSettingModel>((ref) => PageSettingModel());
final pageindex = StateProvider<int>((ref) => 0);
