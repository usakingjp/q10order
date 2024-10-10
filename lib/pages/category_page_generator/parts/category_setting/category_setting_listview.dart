import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/category_page_generator/models/category_model.dart';

import '../../../../consts/colors.dart';
import '../../providers/providers.dart';
import 'category_select.dart';
import 'functions.dart';

class CategorySettingListView extends ConsumerWidget {
  const CategorySettingListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = [...ref.watch(categories)];
    categoryList.insert(0, CategoryModel(id: null, name: ''));
    return ListView.builder(
      itemCount: ref.watch(categoryItems).length,
      itemBuilder: (c, i) {
        var model = ref.watch(categoryItems)[i];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(model.sellerCode),
                                ),
                                Expanded(
                                    child: Text(
                                  model.itemTitle,
                                  maxLines: 1,
                                )),
                              ],
                            ),
                          ),
                          Container(
                            color: mainColor,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                color: mainContentBackColor,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                        6,
                                        (index) => CategorySelect(
                                            categories: categoryList,
                                            model: model,
                                            index: index))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        print(
                            '${model.categoryId1},${model.categoryId2},${model.categoryId3},${model.categoryId4},${model.categoryId5},');
                        model = categoryIdsOrganize(model);
                        ref.read(categoryItems.notifier).replace(model);
                      },
                      child: const Text('更新'))
                ],
              ),
            ),
            // Divider(),
          ],
        );
      },
    );
  }
}
