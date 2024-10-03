import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../consts/colors.dart';
import '../../templates/main_content_head_container.dart';
import '../../templates/main_content_head_label.dart';
import '../db/db.dart';
import '../models/category_model.dart';
import '../providers/providers.dart';

class CategoryManagementContent extends HookConsumerWidget {
  const CategoryManagementContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final categoriesMock = useState<List<CategoryModel>>([
    //   CategoryModel(id: 0, name: "hoge", parentId: null),
    //   CategoryModel(id: 1, name: "hoge1", parentId: null),
    //   CategoryModel(id: 2, name: "hoge2", parentId: 1),
    //   CategoryModel(id: 3, name: "hoge3", parentId: 0)
    // ]);
    final newCategoryCtrl = useTextEditingController();
    return Column(children: [
      MainContentHeadContainer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: MainContentHeadLabel('新しいカテゴリー：'),
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.only(right: 15),
              child: TextField(
                controller: newCategoryCtrl,
                // expands: true,
              ),
            ),
            FilledButton(
              onPressed: (ref.watch(isWorking))
                  ? () {}
                  : () async {
                      ref.read(isWorking.notifier).state = true;
                      List<Map<String, dynamic>> result = await insertData(
                          DataBaseName.categories,
                          CategoryModel(name: newCategoryCtrl.text).toMap());
                      ref.read(categories.notifier).state = [
                        for (Map<String, dynamic> map in result)
                          CategoryModel.fromMap(map)
                      ];
                      newCategoryCtrl.text = "";
                      ref.read(isWorking.notifier).state = false;
                    },
              child: Text('追加'),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(
            itemCount: ref.watch(categories).length,
            itemBuilder: (c, i) {
              var model = ref.watch(categories)[i];
              return Text('id:${model.id}, name:${model.name}');
            }),
      )
    ]);
  }
}
