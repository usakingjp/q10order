import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/consts/colors.dart';
import '../../templates/main_content_head_container.dart';
import '../../templates/main_content_head_label.dart';
import '../models/category_model.dart';
import '../providers/providers.dart';
import 'category_management/listview_label.dart';
import 'category_management/listview_tile.dart';

class CategoryManagementContent extends HookConsumerWidget {
  const CategoryManagementContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newCategoryCtrl = useTextEditingController();
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
                // expands: true,
                onSubmitted: (v) async {
                  ref.read(isWorking.notifier).state = true;
                  await ref
                      .read(categories.notifier)
                      .add(CategoryModel(name: newCategoryCtrl.text));
                  newCategoryCtrl.text = "";
                  ref.read(isWorking.notifier).state = false;
                },
              ),
            ),
            FilledButton(
              onPressed: (ref.watch(isWorking))
                  ? () {}
                  : () async {
                      ref.read(isWorking.notifier).state = true;
                      await ref
                          .read(categories.notifier)
                          .add(CategoryModel(name: newCategoryCtrl.text));
                      // List<Map<String, dynamic>> result = await insertData(
                      //     DataBaseName.categories,
                      //     CategoryModel(name: newCategoryCtrl.text).toMap());
                      // ref.read(categories.notifier).state = [
                      //   for (Map<String, dynamic> map in result)
                      //     CategoryModel.fromMap(map)
                      // ];
                      newCategoryCtrl.text = "";
                      ref.read(isWorking.notifier).state = false;
                    },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListView.builder(
              itemCount: ref.watch(categories).length,
              itemBuilder: (c, i) {
                var model = ref.watch(categories)[i];
                return ListviewTile(model: model);
              }),
        ),
      )
    ]);
  }
}
