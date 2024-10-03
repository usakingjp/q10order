import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';
import '../models/category_item_model.dart';

final categories = StateProvider<List<CategoryModel>>((ref) => []);
final categoryItems = StateProvider<List<CategoryItemModel>>((ref) => []);
final isWorking = StateProvider<bool>((ref) => false);
