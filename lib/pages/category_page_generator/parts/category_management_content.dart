import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../templates/main_content_head_container.dart';
import '../../templates/main_content_head_label.dart';
import '../models/category_model.dart';
import '../providers/providers.dart';
import 'category_management/listview_tile.dart';

class CategoryManagementContent extends HookConsumerWidget {
  const CategoryManagementContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newCategoryCtrl = useTextEditingController();
    final categoryList = ref.watch(categories);
    bool isWorking = false;
    return Column(children: [
      MainContentHeadContainer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: MainContentHeadLabel('新しいカテゴリー：'),
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.only(right: 15),
              child: TextField(
                controller: newCategoryCtrl,
                autofocus: true,
                // expands: true,
                onSubmitted: (v) async {
                  await ref
                      .read(categories.notifier)
                      .add(CategoryModel(name: newCategoryCtrl.text));
                  newCategoryCtrl.text = "";
                },
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (!isWorking) {
                  isWorking = true;
                  try {
                    await ref
                        .read(categories.notifier)
                        .add(CategoryModel(name: newCategoryCtrl.text));
                    newCategoryCtrl.text = "";
                  } catch (e) {
                    debugPrint(e.toString());
                  } finally {
                    isWorking = false;
                  }
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          child: ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (c, i) {
                var model = categoryList[i];
                return ListviewTile(model: model);
              }),
        ),
      )
    ]);
  }
}
