import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../item_management/models/get_all_goods_info_model.dart';
import '../../setting/providers/config_provider.dart';
import '../apis/q10_apis.dart';
import '../models/category_item_model.dart';
import '../providers/providers.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton(
          onPressed: (ref.watch(isWorking))
              ? () {}
              : () async {
                  ref.read(isWorking.notifier).state = true;
                  Q10Apis apis = Q10Apis(
                      sellerAuthorizationKey: ref.watch(sellerAuthKey).value);
                  Map<String, dynamic> allGoods = await apis.getAllGoodsInfo();
                  print(allGoods["Items"].length);
                  List<Map<String, dynamic>> itemDetails = [
                    for (var goods
                        in allGoods["Items"] as List<GetAllGoodsInfoModel>)
                      await apis.getItemDetaiInfo(itemCode: goods.itemCode)
                  ];
                  ref.read(categoryItems.notifier).state = [
                    for (var item in itemDetails)
                      CategoryItemModel.fromMap(apiResponse: item)
                  ];
                  ref.read(isWorking.notifier).state = false;
                },
          child: (ref.watch(isWorking))
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
          onPressed: (ref.watch(isWorking)) ? () {} : () {},
          child: const Text('一括更新'),
        ),
      ],
    );
  }
}
