import 'package:flutter/material.dart';
import 'package:q10order/pages/category_page_generator/parts/category_setting_head.dart';
import 'package:q10order/pages/category_page_generator/parts/category_setting_listview.dart';

class CategorySettingContent extends StatelessWidget {
  const CategorySettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CategorySettingHead(),
        Expanded(
          child: CategorySettingListView(),
        ),
      ],
    );
  }
}
