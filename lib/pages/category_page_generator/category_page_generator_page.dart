import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/templates/main_frame.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/db.dart';
import 'models/category_item_model.dart';
import 'models/category_model.dart';
import 'models/page_setting_model.dart';
import 'parts/category_management_content.dart';
import 'parts/category_page_content.dart';
import 'parts/category_setting_content.dart';
import 'providers/providers.dart';

class CategoryPageGeneratorPage extends HookConsumerWidget {
  const CategoryPageGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<bool> _future = Future.sync(() async {
      try {
        ref.read(categories.notifier).state = [
          for (Map<String, dynamic> map
              in await getData(DataBaseName.categories))
            CategoryModel.fromMap(map)
        ];
        if (ref.watch(categoryItems).isEmpty) {
          ref.read(categoryItems.notifier).state = [
            for (Map<String, dynamic> map
                in await getData(DataBaseName.categoryItems))
              CategoryItemModel.fromMap(queryMap: map)
          ];
        }
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
        print(e);
        return false;
      }
    });
    final tabCtrl = useState(0);
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

    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return MainFrame(
            leftNavi: Column(
                children: tabs.map((e) {
              return TextButton(
                onPressed: () {
                  if (!ref.watch(isWorking)) {
                    tabCtrl.value = e['key'];
                  }
                },
                child: Text(e['value']),
              );
            }).toList()
                // [
                //   TextButton(
                //     onPressed: () {
                //       if (!ref.watch(isWorking)) {
                //         tabCtrl.value = 0;
                //       }
                //     },
                //     child: const Text('カテゴリー管理'),
                //   ),
                //   TextButton(
                //     onPressed: () {
                //       if (!ref.watch(isWorking)) {
                //         tabCtrl.value = 1;
                //       }
                //     },
                //     child: const Text('カテゴリー設定'),
                //   ),
                //   TextButton(
                //     onPressed: () {
                //       if (!ref.watch(isWorking)) {
                //         tabCtrl.value = 2;
                //       }
                //     },
                //     child: const Text('ページ設計'),
                //   ),
                // ],
                ),
            mainContent: mainContentView(tabCtrl.value),
          );
        });
  }
}
