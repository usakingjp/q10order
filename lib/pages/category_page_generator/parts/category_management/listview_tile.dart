import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/category_page_generator/apis/q10_apis.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../models/category_model.dart';
import '../../providers/providers.dart';
import 'html_export.dart';
import 'listview_label.dart';

class ListviewTile extends HookConsumerWidget {
  const ListviewTile({super.key, required this.model});

  final CategoryModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editing = useState<bool>(false);
    final categoryNameCtrl = useTextEditingController(text: model.name);
    final categoryName = model.name;
    final imageUrlCtrl = useTextEditingController(text: model.headerImageUrl);
    final imageUrl = model.headerImageUrl;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 50,
              height: double.infinity,
              // margin: EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey))),
              child: Text('${model.id}'),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          ListviewLabel('カテゴリー名'),
                          (editing.value)
                              ? Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: categoryNameCtrl,
                                    style: TextStyle(fontSize: 14),
                                    onTapOutside: (v) {
                                      if (categoryName !=
                                          categoryNameCtrl.text) {
                                        ref.read(categories.notifier).replace(
                                            CategoryModel(
                                                id: model.id,
                                                name: categoryNameCtrl.text,
                                                parentId: model.parentId,
                                                headerImageUrl:
                                                    model.headerImageUrl));
                                      }
                                      editing.value = false;
                                    },
                                    onFieldSubmitted: (v) {
                                      if (categoryName !=
                                          categoryNameCtrl.text) {
                                        ref.read(categories.notifier).replace(
                                            CategoryModel(
                                                id: model.id,
                                                name: categoryNameCtrl.text,
                                                parentId: model.parentId,
                                                headerImageUrl:
                                                    model.headerImageUrl));
                                      }
                                      editing.value = false;
                                    },
                                  ),
                                )
                              : Text(
                                  model.name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      )),
                  Row(
                    children: [
                      ListviewLabel('ヘッダ画像URL'),
                      Container(
                        width: 320,
                        child: TextFormField(
                          controller: imageUrlCtrl,
                          style: TextStyle(fontSize: 14),
                          onTapOutside: (v) {
                            if (imageUrlCtrl.text != imageUrl) {
                              ref.read(categories.notifier).replace(
                                  CategoryModel(
                                      id: model.id,
                                      name: model.name,
                                      parentId: model.parentId,
                                      headerImageUrl: imageUrlCtrl.text));
                            }
                          },
                          onFieldSubmitted: (v) {
                            if (imageUrlCtrl.text != imageUrl) {
                              ref.read(categories.notifier).replace(
                                  CategoryModel(
                                      id: model.id,
                                      name: model.name,
                                      parentId: model.parentId,
                                      headerImageUrl: imageUrlCtrl.text));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return AlertDialog(
                              title: Text('カテゴリーの削除'),
                              content: Text(
                                  'カテゴリーを削除すると復元できません。\n設定中の商品からもカテゴリーが削除されます。\nQoo10ページには連動しませんので、手動でカテゴリーページを削除してください。'),
                              actions: [
                                FilledButton(
                                    onPressed: () async {
                                      ref
                                          .read(categories.notifier)
                                          .delete(model);
                                      ref
                                          .read(categoryItems.notifier)
                                          .categoryDelete(model.id!);
                                      Navigator.pop(context);
                                    },
                                    child: Text('はい')),
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('キャンセル'))
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete_forever_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      editing.value = !editing.value;
                    },
                    icon: Icon(Icons.edit_attributes_outlined),
                  ),
                  IconButton(
                    onPressed: () async {
                      var picked = ref
                          .watch(categoryItems)
                          .where((e) => [
                                e.categoryId1,
                                e.categoryId2,
                                e.categoryId3,
                                e.categoryId4,
                                e.categoryId5,
                                e.categoryId6
                              ].contains(model.id))
                          .toList();
                      Q10Apis apis = Q10Apis(
                          sellerAuthorizationKey:
                              ref.watch(sellerAuthKey).value);
                      List<GetItemDetailModel> items = [
                        for (final e in picked)
                          GetItemDetailModel.fromMap(
                              await apis.getItemDetaiInfo(itemCode: e.itemCode))
                      ];
                      items.sort((a, b) => b.itemQty.compareTo(a.itemQty));

                      String html = '';
                      if (ref.watch(pageSetting).listOrTile == 0) {
                      } else {
                        html = htmlTileHeaderExport(ref: ref, model: model);
                      }
                      for (var item in items) {
                        String itemHtml = htmlExport(ref: ref, model: item);
                        html = html + itemHtml;
                      }
                      html = html + htmlFooter;
                      showDialog(
                          context: context,
                          builder: (c) {
                            return AlertDialog(
                              content: SelectableText(html),
                            );
                          });
                    },
                    icon: Icon(Icons.share_outlined),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
