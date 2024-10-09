import 'package:flutter/material.dart';

import 'category_setting/category_setting_head.dart';
import 'category_setting/category_setting_listview.dart';
import 'category_setting/category_setting_sort.dart';

class CategorySettingContent extends StatelessWidget {
  const CategorySettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CategorySettingHead(),
        CategorySettingSort(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: CategorySettingListView(),
          ),
        ),
      ],
    );
  }
}
