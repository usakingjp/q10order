import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../templates/main_content_head_label.dart';
import '../providers.dart';
import 'all_item_edit_button.dart';

class AllItemEditRow extends ConsumerWidget {
  const AllItemEditRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItemTitleEditCtrl = TextEditingController();
    final itemSearchCtrl = TextEditingController();
    final getItems = ref.watch(getItemDetailModels);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 180,
                padding: const EdgeInsets.only(right: 10),
                child: const MainContentHeadLabel('商品検索'),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.only(right: 10),
                child: TextField(
                  controller: itemSearchCtrl,
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    var selected = ref
                        .read(getItemDetailModels.notifier)
                        .select(itemSearchCtrl.text);
                    ref.read(getItemDetailModelsView.notifier).state = selected;
                  },
                  child: Text('検索'))
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              padding: const EdgeInsets.only(right: 10),
              child: const MainContentHeadLabel('商品名の一括編集'),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.only(right: 10),
              child: TextField(
                controller: allItemTitleEditCtrl,
                onChanged: (v) {
                  ref.read(allItemEditText.notifier).state = v;
                },
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AllItemEditButton(type: AllItemEditButtonEnum.beforeAdd),
            ),
            const Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AllItemEditButton(type: AllItemEditButtonEnum.afterAdd),
            ),
            const Padding(
              padding: const EdgeInsets.only(right: 10),
              child: AllItemEditButton(type: AllItemEditButtonEnum.delete),
            ),
            IconButton(
              onPressed: () {
                var getItemsCopy = [...getItems];
                getItemsCopy.sort(
                    (a, b) => a.itemTitle.length.compareTo(b.itemTitle.length));
                // ref.read(getItemDetailModels.notifier).set(getItemsCopy);
                ref.read(getItemDetailModelsView.notifier).state = getItemsCopy;
              },
              icon: const Icon(Icons.keyboard_arrow_up_outlined),
            ),
            IconButton(
              onPressed: () {
                var getItemsCopy = [...getItems];
                getItemsCopy.sort(
                    (a, b) => b.itemTitle.length.compareTo(a.itemTitle.length));
                // ref.read(getItemDetailModels.notifier).set(getItemsCopy);
                ref.read(getItemDetailModelsView.notifier).state = getItemsCopy;
              },
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
