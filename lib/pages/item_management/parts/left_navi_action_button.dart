import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/show_loading_dialog.dart';
import '../../setting/providers/config_provider.dart';
import '../apis/q10_apis.dart';
import '../models/get_all_goods_info_model.dart';
import '../models/get_item_detail_model.dart';
import '../providers.dart';

enum LeftNaviActionButtonEnum {
  get,
  update;

  String get defaultText {
    switch (this) {
      case get:
        return '商品データを取得';
      case update:
        return '編集内容を反映';
      default:
        return 'unknown';
    }
  }

  String get workingText {
    switch (this) {
      case get:
        return '取得中...';
      case update:
        return '反映中...';
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
    // final isWorking = ref.watch(itemManagementIsWorking);
    // final thisWorking = useState(false);
    final buttonText = useState<String>(type.defaultText);
    final loadingNotifier = ref.read(loadingText.notifier);
    return FilledButton(
      onPressed: () async {
        await showLoadingDialog(context: context);
        try {
          buttonText.value = type.workingText;
          loadingNotifier.state = type.workingText;
          switch (type.val) {
            case 0:
              var allItems = await apis.getAllGoodsInfo();

              final int allItemLength = allItems["Items"].length;
              List<GetItemDetailModel> itemDetails = [];
              if (allItemLength > 0) {
                buttonText.value = allItemLength.toString();
                int count = 1;
                for (var element
                    in allItems["Items"] as List<GetAllGoodsInfoModel>) {
                  Map<String, dynamic> result =
                      await apis.getItemDetaiInfo(itemCode: element.itemCode);
                  itemDetails.add(GetItemDetailModel.fromMap(result));
                  buttonText.value = '${type.workingText}$count/$allItemLength';
                  loadingNotifier.state =
                      '${type.workingText}$count/$allItemLength';
                  count++;
                }
                buttonText.value = 'done';
                ref.read(getItemDetailModels.notifier).set(itemDetails);
                ref.read(getItemDetailModelsView.notifier).state =
                    ref.watch(getItemDetailModels);
              }
              break;
            case 1:
              var editedList =
                  ref.watch(getItemDetailModels).where((e) => e.edited);
              final int editItemLength = editedList.length;
              int count = 1;
              for (var element in editedList) {
                debugPrint(element.itemTitle);
                Map<String, dynamic> updateResult =
                    await apis.updateGoods(element.toUpdateGoods().toMap());
                if (updateResult["ResultCode"] != 0) {
                  debugPrint(
                      '${element.sellerCode} : ${updateResult["ResultMsg"]}');
                } else {
                  buttonText.value =
                      '${type.workingText}$count/$editItemLength';
                  loadingNotifier.state =
                      '${type.workingText}$count/$editItemLength';
                  count++;
                }
              }
              buttonText.value = 'done';
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
        } catch (e) {
          debugPrint(e.toString());
        } finally {
          buttonText.value = type.defaultText;
          loadingNotifier.state = "";
          Navigator.pop(context);
        }
        // if (!isWorking) {
        //   ref.read(itemManagementIsWorking.notifier).state = true;

        //   ref.read(itemManagementIsWorking.notifier).state = false;
        // }
      },
      child: Text(buttonText.value),
    );
  }
}
