import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/category_page_generator/models/category_model.dart';
import 'package:q10order/pages/category_page_generator/providers/providers.dart';
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../item_management/models/get_all_goods_info_model.dart';
import '../apis/q10_apis.dart';
import '../models/category_item_model.dart';

class CategorySelect extends HookConsumerWidget {
  const CategorySelect(
      {super.key,
      required this.categories,
      required this.model,
      required this.index});

  final List<CategoryModel> categories;
  final CategoryItemModel model;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int? thisCategory;
    switch (index) {
      case 0:
        thisCategory = model.categoryId1;
        break;
      case 1:
        thisCategory = model.categoryId2;
        break;
      case 2:
        thisCategory = model.categoryId3;
        break;
      case 3:
        thisCategory = model.categoryId4;
        break;
      case 4:
        thisCategory = model.categoryId5;
        break;
      case 5:
        thisCategory = model.categoryId6;
        break;
      default:
        break;
    }
    final categoryId = useState<int?>(thisCategory);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButton(
        items: categories
            .map((f) => DropdownMenuItem(
                  child: Text(f.name),
                  value: f.id,
                ))
            .toList(),
        value: categoryId.value,
        onChanged: (v) {
          categoryId.value = v;
          switch (index) {
            case 0:
              model.categoryId1 = v;
              break;
            case 1:
              model.categoryId2 = v;
              break;
            case 2:
              model.categoryId3 = v;
              break;
            case 3:
              model.categoryId4 = v;
              break;
            case 4:
              model.categoryId5 = v;
              break;
            case 5:
              model.categoryId6 = v;
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class CategorySettingContent extends HookConsumerWidget {
  const CategorySettingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final categoryItemsMock = useState<List<Categor
    final anime = useAnimationController(duration: Duration(milliseconds: 800));
    useAnimation(anime);
    useEffect(() {
      anime.repeat();
      return () {};
    }, const []);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton(
              onPressed: (ref.watch(isWorking))
                  ? () {}
                  : () async {
                      ref.read(isWorking.notifier).state = true;
                      Q10Apis apis = Q10Apis(
                          sellerAuthorizationKey:
                              ref.watch(sellerAuthKey).value);
                      Map<String, dynamic> allGoods =
                          await apis.getAllGoodsInfo();
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
                  : Tooltip(
                      message: 'Qoo10から商品データを取得します',
                      child: Icon(Icons.cached_rounded)),
            ),
            FilledButton(
              onPressed: (ref.watch(isWorking)) ? () {} : () {},
              child: Text('一括更新'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: ref.watch(categoryItems).length,
            itemBuilder: (c, i) {
              var model = ref.watch(categoryItems)[i];
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(model.sellerCode),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(model.itemTitle),
                  ),
                  Row(
                      children: List.generate(
                          6,
                          (index) => CategorySelect(
                              categories: ref.watch(categories),
                              model: model,
                              index: index))),
                  TextButton(
                      onPressed: () {
                        print(
                            '${model.categoryId1},${model.categoryId2},${model.categoryId3},${model.categoryId4},${model.categoryId5},');
                      },
                      child: Text('更新'))
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
