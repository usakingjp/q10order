import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'category_select.dart';

class CategorySettingListView extends ConsumerWidget {
  const CategorySettingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: ref.watch(categoryItems).length,
      itemBuilder: (c, i) {
        var model = ref.watch(categoryItems)[i];
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(model.sellerCode),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(model.itemTitle),
            ),
            Row(
                children: List.generate(
                    6,
                    (index) => CategorySelect(
                        categories: ref.watch(categories),
                        model: model,
                        index: index))),
            TextButton(
                onPressed: () {
                  print(
                      '${model.categoryId1},${model.categoryId2},${model.categoryId3},${model.categoryId4},${model.categoryId5},');
                },
                child: const Text('更新'))
          ],
        );
      },
    );
  }
}
