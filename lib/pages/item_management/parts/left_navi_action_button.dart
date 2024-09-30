import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../setting/providers/config_provider.dart';
import '../apis/q10_apis.dart';
import '../models/get_all_goods_info_model.dart';
import '../models/get_item_detail_model.dart';
import '../providers.dart';

enum LeftNaviActionButtonEnum {
  get,
  update;

  String get text {
    switch (this) {
      case get:
        return '商品データを取得';
      case update:
        return '編集内容を反映';
      default:
        return 'unknown';
    }
  }

  int get val {
    switch (this) {
      case get:
        return 0;
      case update:
        return 1;
      default:
        return 99;
    }
  }
}

class LeftNaviActionButton extends HookConsumerWidget {
  const LeftNaviActionButton({super.key, required this.type});

  final LeftNaviActionButtonEnum type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Q10Apis apis =
        Q10Apis(sellerAuthorizationKey: ref.watch(sellerAuthKey).value);
    final isWorking = ref.watch(itemManagementIsWorking);
    final thisWorking = useState(false);
    return FilledButton(
      onPressed: (isWorking)
          ? null
          : () async {
              if (!isWorking) {
                ref.read(itemManagementIsWorking.notifier).state = true;
                thisWorking.value = true;
                switch (type.val) {
                  case 0:
                    var allItems = await apis.getAllGoodsInfo();
                    List<GetItemDetailModel> itemDetails = [];
                    if (allItems["Items"].length > 0) {
                      for (var element
                          in allItems["Items"] as List<GetAllGoodsInfoModel>) {
                        Map<String, dynamic> result = await apis
                            .getItemDetaiInfo(itemCode: element.itemCode);
                        itemDetails.add(GetItemDetailModel.fromMap(result));
                      }
                      ref.read(getItemDetailModels.notifier).set(itemDetails);
                      ref.read(getItemDetailModelsView.notifier).state =
                          ref.watch(getItemDetailModels);
                    }
                    break;
                  case 1:
                    var editedList =
                        ref.watch(getItemDetailModels).where((e) => e.edited);
                    for (var element in editedList) {
                      print(element.itemTitle);
                      Map<String, dynamic> updateResult = await apis
                          .updateGoods(element.toUpdateGoods().toMap());
                      if (updateResult["ResultCode"] != 0) {
                        print(
                            '${element.sellerCode} : ${updateResult["ResultMsg"]}');
                      }
                    }
                    var copy = [...ref.watch(getItemDetailModels)];
                    for (var e in copy) {
                      e.edited = false;
                    }
                    ref.read(getItemDetailModels.notifier).set(copy);
                    ref.read(getItemDetailModelsView.notifier).state =
                        ref.watch(getItemDetailModels);
                    break;
                  default:
                    break;
                }
                thisWorking.value = false;
                ref.read(itemManagementIsWorking.notifier).state = false;
              }
            },
      child: (thisWorking.value)
          ? const CircularProgressIndicator(
              strokeWidth: 6,
            )
          : Text(type.text),
    );
  }
}
