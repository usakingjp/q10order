import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:q10order/models/item_name.dart';
import 'package:q10order/pages/setting/setting_page.dart';
import 'package:q10order/provider.dart';

import '../../workers/db/itemnames_db.dart' as item_name_db;
import '../items/items_name.dart';
import 'parts/left_navi.dart';
import 'parts/main_content.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key, required this.version});
  final String version;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> startup() async {
      const storage = FlutterSecureStorage();
      ref.read(sakP.notifier).state = await storage.read(key: 'sak') ?? '';
      List<ItemName> itemnames = await item_name_db.getAll();
      itemnames.sort((a, b) => b.q10cord.compareTo(a.q10cord));
      ref.read(itemNames.notifier).set(itemnames);
      return true;
    }

    return FutureBuilder(
        future: startup(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('snapshot.hasError');
          }
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(255, 111, 67, 192), width: 2))),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeftNavi(
                    version: version,
                  ),
                  const Expanded(
                    child: MainContent(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
