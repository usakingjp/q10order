import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/item_management/apis/q10_apis.dart';
import 'package:q10order/pages/item_management/models/get_all_goods_info_model.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';
import 'package:q10order/pages/item_management/models/update_goods_model.dart';
import 'package:q10order/pages/item_management/parts/all_item_edit_button.dart';
import 'package:q10order/pages/item_management/parts/itemTitleListViewTile.dart';
import 'package:q10order/pages/item_management/providers.dart';
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../provider.dart';

class ItemManagementPage extends ConsumerWidget {
  const ItemManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getItems = ref.watch(getItemDetailModels);
    final allItemTitleEditCtrl = TextEditingController();
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 200,
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: FilledButton(
                    onPressed: () async {
                      Q10Apis apis = Q10Apis(
                          sellerAuthorizationKey:
                              ref.watch(sellerAuthKey).value);
                      // Q10Apis apis =
                      //     Q10Apis(sellerAuthorizationKey: );
                      // UpdateGoodsModel updatemodel = getmodel.toUpdateGoods();

                      // Map<String, dynamic> result2 =
                      //     await apis.updateGoods(updatemodel.toMap());
                      var allItems = await apis.getAllGoodsInfo();
                      print(allItems);
                      List<GetItemDetailModel> itemDetails = [];
                      if (allItems["Items"].length > 0) {
                        for (var element in allItems["Items"]
                            as List<GetAllGoodsInfoModel>) {
                          Map<String, dynamic> result = await apis
                              .getItemDetaiInfo(itemCode: element.itemCode);
                          itemDetails.add(GetItemDetailModel.fromMap(result));
                        }
                        ref.read(getItemDetailModels.notifier).state =
                            itemDetails;
                      }
                      for (var element in itemDetails) {
                        print(element.sellerCode);
                      }
                    },
                    child: Text('商品データを取得'),
                  ),
                ),
                FilledButton(
                    onPressed: () async {
                      var editedList = getItems.where((e) => e.edited);
                      Q10Apis apis = Q10Apis(
                          sellerAuthorizationKey:
                              ref.watch(sellerAuthKey).value);
                      for (var element in editedList) {
                        Map<String, dynamic> updateResult = await apis
                            .updateGoods(element.toUpdateGoods().toMap());
                        if (updateResult["ResultCode"] != 0) {
                          print(updateResult["ResultMsg"]);
                        }
                      }
                    },
                    child: Text('編集内容を反映'))
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.amber,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('商品名の一括編集'),
                    ),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: allItemTitleEditCtrl,
                        onChanged: (v) {
                          ref.read(allItemEditText.notifier).state = v;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AllItemEditButton(
                          type: AllItemEditButtonEnum.beforeAdd),
                      // child: OutlinedButton(
                      //   onPressed: (ref.watch(itemManagementIsWorking))?null:() {
                      //     if(!ref.watch(itemManagementIsWorking)){
                      //     ref.read(itemManagementIsWorking.notifier).state = true;
                      //     var getItemsCopy = [...getItems];
                      //     if (allItemTitleEditCtrl.text.isNotEmpty) {
                      //       for (var item in getItemsCopy) {
                      //         item.itemTitle =
                      //             '${allItemTitleEditCtrl.text}${item.itemTitle}';
                      //         item.edited = true;
                      //       }
                      //       ref.read(getItemDetailModels.notifier).state =
                      //           getItemsCopy;
                      //     }
                      //     ref.read(itemManagementIsWorking.notifier).state = false;
                      //     }
                      //   },

                      //   child: const Text('前方追加'),
                      // ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:
                          AllItemEditButton(type: AllItemEditButtonEnum.delete),
                      // child: OutlinedButton(
                      //   onPressed: () {
                      //     var getItemsCopy = [...getItems];
                      //     if (allItemTitleEditCtrl.text.isNotEmpty) {
                      //       for (var item in getItemsCopy) {
                      //         item.itemTitle = item.itemTitle
                      //             .replaceAll(allItemTitleEditCtrl.text, '');
                      //       }
                      //       ref.read(getItemDetailModels.notifier).state =
                      //           getItemsCopy;
                      //     }
                      //   },
                      //   child: const Text('一致削除'),
                      // ),
                    ),
                    IconButton(
                      onPressed: () {
                        var getItemsCopy = [...getItems];
                        getItemsCopy.sort((a, b) =>
                            a.itemTitle.length.compareTo(b.itemTitle.length));
                        ref.read(getItemDetailModels.notifier).state =
                            getItemsCopy;
                      },
                      icon: Icon(Icons.keyboard_arrow_up_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        var getItemsCopy = [...getItems];
                        getItemsCopy.sort((a, b) =>
                            b.itemTitle.length.compareTo(a.itemTitle.length));
                        ref.read(getItemDetailModels.notifier).state =
                            getItemsCopy;
                      },
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: getItems.length,
                        itemBuilder: (c, i) {
                          var viewItem = getItems[i];
                          return ItemTitleListViewTile(viewItem: viewItem);
                        }),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
