import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/setting/models/config_model.dart';
import 'package:q10order/pages/templates/main_frame.dart';

import 'db/db.dart';
import 'models/category_item_model.dart';
import 'models/category_model.dart';
import 'parts/category_management_content.dart';
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
        ref.read(categoryItems.notifier).state = [
          for (Map<String, dynamic> map
              in await getData(DataBaseName.categoryItems))
            CategoryItemModel.fromMap(queryMap: map)
        ];
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    });
    final tabCtrl = useState(0);
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return MainFrame(
              leftNavi: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      tabCtrl.value = 0;
                    },
                    child: Text('カテゴリー管理'),
                  ),
                  TextButton(
                    onPressed: () {
                      tabCtrl.value = 1;
                    },
                    child: Text('カテゴリー設定'),
                  ),
                ],
              ),
              mainContent: (tabCtrl.value == 0)
                  ? CategoryManagementContent()
                  : (tabCtrl.value == 1)
                      ? CategorySettingContent()
                      : Container());
        });
  }
}
