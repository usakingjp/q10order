import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/colors.dart';
import '../templates/main_frame.dart';
import 'models/page_setting_model.dart';
import 'parts/category_management_content.dart';
import 'parts/category_page_content.dart';
import 'parts/category_setting_content.dart';
import 'parts/function/get_settings.dart';
import 'providers/providers.dart';

class CategoryPageGeneratorPage extends ConsumerWidget {
  const CategoryPageGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> startup() async {
      try {
        debugPrint("categoriesQuery");
        await ref.read(categories.notifier).get();
        debugPrint("categoryItemsQuery");
        await ref.read(categoryItems.notifier).get();
        debugPrint("SharedPreferences");
        ref.read(pageSetting.notifier).state = await getSettings();
        ref.read(pageSettingM.notifier).state = await getSettings(isMob: true);
        return true;
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    }

    return FutureBuilder(
        future: startup(),
        builder: (context, snapshot) {
          Widget mainContentView(int id) {
            switch (id) {
              case 0:
                return const CategoryManagementContent();
              case 1:
                return const CategorySettingContent();
              case 2:
                return const CategoryPageContent();
              default:
                return Container();
            }
          }

          List<Map<String, dynamic>> tabs = [
            {'key': 0, 'value': 'カテゴリー管理'},
            {'key': 1, 'value': 'カテゴリー設定'},
            {'key': 2, 'value': 'ページ設計'},
          ];

          Column leftnavi = Column(
            children: tabs.map((e) {
              return Container(
                // padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.only(
                    right: (ref.watch(pageindex) != e['key']) ? 3 : 0),
                decoration: (ref.watch(pageindex) != e['key'])
                    ? null
                    : BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 3, color: mainColor))),
                child: TextButton(
                  onPressed: () {
                    if (ref.watch(pageindex) != e['key']) {
                      ref.read(pageindex.notifier).state = e['key'];
                    }
                  },
                  child: Text(e['value']),
                ),
              );
            }).toList(),
          );

          return MainFrame(
            leftNavi: leftnavi,
            mainContent: mainContentView(ref.watch(pageindex)),
          );
        });
  }
}
