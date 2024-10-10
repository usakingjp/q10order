import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/show_loading_dialog.dart';
import '../../../item_management/models/get_all_goods_info_model.dart';
import '../../../setting/providers/config_provider.dart';
import '../../apis/q10_apis.dart';
import '../../models/category_item_model.dart';
import '../../providers/providers.dart';
import 'functions.dart';

class CategorySettingHead extends HookConsumerWidget {
  const CategorySettingHead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime =
        useAnimationController(duration: const Duration(milliseconds: 800));
    useAnimation(anime);
    useEffect(() {
      anime.repeat();
      return () {};
    }, const []);
    final loadingNotifer = ref.read(loadingText.notifier);
    final isWorking = useState(false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton(
          onPressed: () async {
            isWorking.value = true;
            loadingNotifer.state = "取得中...";
            await showLoadingDialog(context: context);
            try {
              Q10Apis apis = Q10Apis(
                  sellerAuthorizationKey: ref.watch(sellerAuthKey).value);
              Map<String, dynamic> allGoods = await apis.getAllGoodsInfo();
              debugPrint(allGoods["Items"].length.toString());
              List<Map<String, dynamic>> itemDetails = [];
              int count = 1;
              for (var goods
                  in allGoods["Items"] as List<GetAllGoodsInfoModel>) {
                itemDetails
                    .add(await apis.getItemDetaiInfo(itemCode: goods.itemCode));
                loadingNotifer.state =
                    "取得中...$count/${allGoods["Items"].length}";
                count++;
              }
              count = 1;
              List<CategoryItemModel> categoryItemList = [];
              for (var item in itemDetails) {
                CategoryItemModel? model = ref
                    .watch(categoryItems)
                    .where((e) => e.itemCode == item['ItemCode'])
                    .firstOrNull;
                if (model != null) {
                  categoryItemList.add(
                      CategoryItemModel.fromMap(update: [item, model.toMap()]));
                } else {
                  categoryItemList
                      .add(CategoryItemModel.fromMap(apiResponse: item));
                }
                loadingNotifer.state = "処理中...$count/${itemDetails.length}";
                count++;
              }
              if (categoryItemList.isNotEmpty) {
                ref.read(categoryItems.notifier).set(categoryItemList);
              }
              loadingNotifer.state = "done";
            } catch (e) {
              debugPrint(e.toString());
            } finally {
              loadingNotifer.state = "";
              isWorking.value = false;
              Navigator.pop(context);
            }
          },
          child: (isWorking.value)
              ? AnimatedBuilder(
                  animation: anime,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: anime.value * 2 * -3.14,
                      child: child,
                    );
                  },
                  child: const Icon(Icons.cached_rounded),
                )
              : const Tooltip(
                  message: 'Qoo10から商品データを取得します',
                  child: Icon(Icons.cached_rounded)),
        ),
        FilledButton(
          onPressed: () async {
            loadingNotifer.state = "更新中...";
            await showLoadingDialog(context: context);
            try {
              for (var element in ref.watch(categoryItems)) {
                element = categoryIdsOrganize(element);
              }
              await ref.read(categoryItems.notifier).allEdit();
              loadingNotifer.state = "done";
            } catch (e) {
              loadingNotifer.state = "error";
              debugPrint(e.toString());
            } finally {
              loadingNotifer.state = "";
              Navigator.pop(context);
            }
          },
          child: const Text('一括更新'),
        ),
      ],
    );
  }
}
