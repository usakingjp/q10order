import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/category_item_model.dart';
import '../models/category_model.dart';

class CategorySelect extends HookConsumerWidget {
  const CategorySelect(
      {super.key,
      required this.categories,
      required this.model,
      required this.index});

  final List<CategoryModel> categories;
  final CategoryItemModel model;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? thisCategory;
    switch (index) {
      case 0:
        thisCategory = model.categoryId1;
        break;
      case 1:
        thisCategory = model.categoryId2;
        break;
      case 2:
        thisCategory = model.categoryId3;
        break;
      case 3:
        thisCategory = model.categoryId4;
        break;
      case 4:
        thisCategory = model.categoryId5;
        break;
      case 5:
        thisCategory = model.categoryId6;
        break;
      default:
        break;
    }
    final categoryId = useState<int?>(thisCategory);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButton(
        items: categories
            .map((f) => DropdownMenuItem(
                  value: f.id,
                  child: Text(f.name),
                ))
            .toList(),
        value: categoryId.value,
        onChanged: (v) {
          categoryId.value = v;
          switch (index) {
            case 0:
              model.categoryId1 = v;
              break;
            case 1:
              model.categoryId2 = v;
              break;
            case 2:
              model.categoryId3 = v;
              break;
            case 3:
              model.categoryId4 = v;
              break;
            case 4:
              model.categoryId5 = v;
              break;
            case 5:
              model.categoryId6 = v;
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
