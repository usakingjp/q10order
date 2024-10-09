import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/category_page_generator/providers/providers.dart';

class CategorySettingSort extends ConsumerWidget {
  const CategorySettingSort({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('販売者商品コードで並び替え'),
              IconButton(
                onPressed: () {
                  var copy = [...ref.watch(categoryItems)];
                  copy.sort((a, b) => a.sellerCode.compareTo(b.sellerCode));
                  ref.read(categoryItems.notifier).set(copy);
                },
                icon: Icon(Icons.keyboard_arrow_up_outlined),
              ),
              IconButton(
                onPressed: () {
                  var copy = [...ref.watch(categoryItems)];
                  copy.sort((a, b) => b.sellerCode.compareTo(a.sellerCode));
                  ref.read(categoryItems.notifier).set(copy);
                },
                icon: Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('カテゴリー登録量で並び替え'),
              IconButton(
                onPressed: () {
                  var copy = [...ref.watch(categoryItems)];
                  copy.sort((a, b) => [
                        a.categoryId1,
                        a.categoryId2,
                        a.categoryId3,
                        a.categoryId4,
                        a.categoryId5,
                        a.categoryId6
                      ].whereType<int>().toList().length.compareTo([
                            b.categoryId1,
                            b.categoryId2,
                            b.categoryId3,
                            b.categoryId4,
                            b.categoryId5,
                            b.categoryId6
                          ].whereType<int>().toList().length));
                  ref.read(categoryItems.notifier).set(copy);
                },
                icon: Icon(Icons.keyboard_arrow_up_outlined),
              ),
              IconButton(
                onPressed: () {
                  var copy = [...ref.watch(categoryItems)];
                  copy.sort((a, b) => [
                        b.categoryId1,
                        b.categoryId2,
                        b.categoryId3,
                        b.categoryId4,
                        b.categoryId5,
                        b.categoryId6
                      ].whereType<int>().toList().length.compareTo([
                            a.categoryId1,
                            a.categoryId2,
                            a.categoryId3,
                            a.categoryId4,
                            a.categoryId5,
                            a.categoryId6
                          ].whereType<int>().toList().length));
                  ref.read(categoryItems.notifier).set(copy);
                },
                icon: Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
