import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/category_page_generator/db/db.dart';
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
                      // List<Map<String, dynamic>> itemDetails = [];
                      // print('itemDetails.length:${itemDetails.length}');
                      // int count = 0;
                      // for (var goods
                      //     in allGoods["Items"] as List<GetAllGoodsInfoModel>) {
                      //   if (ref
                      //       .watch(categoryItems)
                      //       .where(
                      //           (element) => element.itemCode == goods.itemCode)
                      //       .isEmpty) {
                      //     itemDetails.add(await apis.getItemDetaiInfo(
                      //         itemCode: goods.itemCode));
                      //   }
                      //   count += 1;
                      //   if (count > 20) break;
                      // }
                      // print('itemDetails.length:${itemDetails.length}');
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
              onPressed: (ref.watch(isWorking))
                  ? null
                  : () async {
                      ref.read(isWorking.notifier).state = true;
                      var copy = [...ref.watch(categoryItems)];
                      print(copy.length);
                      ref.read(categoryItems.notifier).state = copy;
                      // List<Map<String, dynamic>> resultList = [];
                      // for (var item in ref.watch(categoryItems)) {
                      //   resultList = await insertOrReplaceData(
                      //       DataBaseName.categoryItems, item.toMap());
                      // }
                      // ref.read(categoryItems.notifier).state = [
                      //   for (var result in resultList)
                      //     CategoryItemModel.fromMap(queryMap: result)
                      // ];
                      ref.read(isWorking.notifier).state = false;
                    },
              child: Text('一括更新'),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 15),
          color: Colors.amber,
          height: 500,
          child: ListView.builder(
            itemCount: ref.watch(categoryItems).length,
            itemBuilder: (c, i) {
              var model = ref.watch(categoryItems)[i];
              return Text(model.itemTitle);
              // return Container(
              //   padding: EdgeInsets.only(bottom: 8),
              //   color: Colors.grey,
              //   // width: double.infinity,
              //   height: 80,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(right: 10),
              //                 child: Text(model.sellerCode),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(right: 10),
              //                 child: Container(
              //                     width: 400,
              //                     child: Text(
              //                       model.itemTitle,
              //                       maxLines: 1,
              //                     )),
              //               ),
              //             ],
              //           ),
              //           Row(
              //             children: List.generate(
              //               6,
              //               (index) => CategorySelect(
              //                   categories: ref.watch(categories),
              //                   model: model,
              //                   index: index),
              //             ),
              //           ),
              //         ],
              //       ),
              //       TextButton(
              //         onPressed: () async {
              //           ref.read(isWorking.notifier).state = true;
              //           List<Map<String, dynamic>> resultList =
              //               await insertOrReplaceData(
              //                   DataBaseName.categoryItems, model.toMap());
              //           ref.read(categoryItems.notifier).state = [
              //             for (var result in resultList)
              //               CategoryItemModel.fromMap(queryMap: result)
              //           ];
              //           ref.read(isWorking.notifier).state = false;
              //           print(
              //               '${model.categoryId1},${model.categoryId2},${model.categoryId3},${model.categoryId4},${model.categoryId5},');
              //         },
              //         child: Text('更新'),
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }
}
