import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../templates/main_frame.dart';
import 'models/page_setting_model.dart';
import 'parts/category_management_content.dart';
import 'parts/category_page_content.dart';
import 'parts/category_setting_content.dart';
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
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        ref.read(pageSetting.notifier).state = PageSettingModel(
          listOrTile: prefs.getInt('listOrTile') ?? 0,
          rowQty: prefs.getInt('rowQty') ?? 3,
          accentColor: prefs.getInt('accentColor') ?? 4284955319,
          subColor: prefs.getInt('subColor') ?? 4286336511,
          titleLength: prefs.getString('titleLength') ?? '20',
          exclusions: prefs.getStringList('exclusions') ?? [],
          dispTitle: prefs.getBool('dispTitle') ?? true,
          dispImage: prefs.getBool('dispImage') ?? true,
          dispPrice: prefs.getBool('dispPrice') ?? true,
          dispPoint: prefs.getBool('dispPoint') ?? true,
          sampleWidth: prefs.getString('sampleWidth') ?? '700',
        );
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
              return TextButton(
                onPressed: () {
                  if (!ref.watch(isWorking)) {
                    ref.read(pageindex.notifier).state = e['key'];
                  }
                },
                child: Text(e['value']),
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
