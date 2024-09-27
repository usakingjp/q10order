import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/item_management/apis/q10_apis.dart';
import 'package:q10order/pages/item_management/models/get_all_goods_info_model.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';
import 'package:q10order/pages/item_management/models/update_goods_model.dart';

import '../../provider.dart';

class ItemManagementPage extends ConsumerWidget {
  const ItemManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 180,
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  color: Colors.amber,
                  child: FilledButton(
                    onPressed: () async {
                      Q10Apis apis =
                          Q10Apis(sellerAuthorizationKey: ref.watch(sakP));
                      // UpdateGoodsModel updatemodel = getmodel.toUpdateGoods();

                      // Map<String, dynamic> result2 =
                      //     await apis.updateGoods(updatemodel.toMap());
                      var allItems = await apis.getAllGoodsInfo();
                      print(allItems["Items"].length);
                      List<GetItemDetailModel> itemDetails = [];
                      if (allItems["Items"].length > 0) {
                        for (var element in allItems["Items"]
                            as List<GetAllGoodsInfoModel>) {
                          Map<String, dynamic> result = await apis
                              .getItemDetaiInfo(itemCode: element.itemCode);
                          itemDetails.add(GetItemDetailModel.fromMap(result));
                        }
                      }
                      for (var element in itemDetails) {
                        print(element.sellerCode);
                      }
                    },
                    child: Text('test'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.amber,
          ))
        ],
      ),
    );
  }
}
