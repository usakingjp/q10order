import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../workers/db/itemnames_db.dart' as itemNameDB;
import '../../../models/item_name.dart';
import '../../../provider.dart';
import 'collection.dart';

class ItemsNameBody extends HookConsumerWidget {
  const ItemsNameBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cordCtrl = useTextEditingController();
    final q10cordCtrl = useTextEditingController();
    final nameCtrl = useTextEditingController();
    final editMode = useState(false);

    return Container(
      child: Column(
        children: [
          Container(
            width: 740,
            padding: const EdgeInsets.fromLTRB(155, 40, 155, 25),
            // color: const Color.fromARGB(255, 248, 248, 248),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      margin: const EdgeInsets.only(
                        right: 30,
                        bottom: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelText('Q10商品番号'),
                          TextField(
                            enabled: (!editMode.value),
                            controller: q10cordCtrl,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelText('商品コード'),
                          TextField(
                            controller: cordCtrl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(
                        right: 25,
                        bottom: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelText('表示する商品名'),
                          TextField(
                            controller: nameCtrl,
                          ),
                        ],
                      ),
                    ),
                    (!editMode.value)
                        ? IconButton(
                            onPressed: () async {
                              ItemName newModel = ItemName(
                                  shopCord: cordCtrl.text,
                                  q10cord: q10cordCtrl.text,
                                  displayName: nameCtrl.text);
                              if (await itemNameDB.exist(newModel)) {
                                //既にq10cordが登録されてる場合
                                //ダイアログで上書きのチェック
                                //OKならupdate
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('重複確認'),
                                        content: const Text(
                                            'Qoo10商品番号が既に登録されています。\n販売者商品コードと表示商品名を上書きしますか？'),
                                        actions: [
                                          FilledButton(
                                              onPressed: () async {
                                                await itemNameDB
                                                    .update(newModel);

                                                ref
                                                    .read(itemNames.notifier)
                                                    .replaceModel(newModel);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('上書きする')),
                                          OutlinedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('キャンセル')),
                                        ],
                                      );
                                    });
                              } else {
                                //登録がない場合
                                //インサート
                                await itemNameDB.insert(newModel);
                                ref.read(itemNames.notifier).add(newModel);
                              }
                              cordCtrl.text = '';
                              q10cordCtrl.text = '';
                              nameCtrl.text = '';
                            },
                            icon: const Icon(Icons.add),
                          )
                        : IconButton(
                            onPressed: () async {
                              ItemName newModel = ItemName(
                                  shopCord: cordCtrl.text,
                                  q10cord: q10cordCtrl.text,
                                  displayName: nameCtrl.text);
                              await itemNameDB.update(newModel);
                              ref
                                  .read(itemNames.notifier)
                                  .replaceModel(newModel);
                              editMode.value = false;
                            },
                            icon: const Icon(Icons.edit),
                          ),
                  ],
                )
              ],
            ),
          ),
          Container(
            // margin: const EdgeInsets.only(top: 20),
            // color: const Color.fromARGB(255, 248, 248, 248),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 700,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 15),
                        child: SortLabelText(
                            label: 'Qoo10商品番号', column: 'q10cord'),
                      ),
                      Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 15),
                        child: SortLabelText(
                            label: '販売者商品コード', column: 'shopCord'),
                      ),
                      Container(
                        width: 300,
                        child: SortLabelText(
                            label: '表示商品名', column: 'displayName'),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 700,
                  height: 400,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      ItemName now = ref.watch(itemNames)[index];
                      Text displayText(String txt) {
                        return Text(
                          txt,
                          style: const TextStyle(fontSize: 16),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(5),
                        color: (index % 2 != 0)
                            ? const Color.fromARGB(200, 255, 255, 255)
                            : const Color.fromARGB(100, 255, 255, 255),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: displayText(now.q10cord),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: 150,
                              child: displayText(now.shopCord),
                            ),
                            Container(
                              width: 300,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: displayText(now.displayName),
                            ),
                            const VerticalDivider(
                              color: Colors.transparent,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 80,
                                  child: IconButton(
                                      onPressed: () {
                                        cordCtrl.text = now.shopCord;
                                        q10cordCtrl.text = now.q10cord;
                                        nameCtrl.text = now.displayName;
                                        editMode.value = true;
                                      },
                                      iconSize: 13,
                                      icon: const Icon(Icons.edit)),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: ref.watch(itemNames).length,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
