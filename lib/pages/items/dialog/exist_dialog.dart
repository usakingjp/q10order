import 'package:flutter/material.dart';

import '../../../models/item_name.dart';
import '../parts/collection.dart';

class ExistDialog extends StatelessWidget {
  const ExistDialog({super.key, required this.data, required this.exists});

  final List<ItemName> data;
  final List<ItemName> exists;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('重複データ'),
      content: Container(
        margin: const EdgeInsets.only(top: 20),
        color: const Color.fromARGB(255, 248, 248, 248),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 630,
              child: Row(
                children: [
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 15),
                    child: labelText('Qoo10商品番号'),
                  ),
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 15),
                    child: labelText('販売者商品コード'),
                  ),
                  Container(
                    width: 300,
                    child: labelText('表示商品名'),
                  ),
                ],
              ),
            ),
            Container(
              width: 630,
              height: 400,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  ItemName now = exists[index];
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
                          child: displayText(now.q10cord),
                        ),
                        Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 15),
                          child: displayText(now.shopCord),
                        ),
                        Container(
                          width: 290,
                          child: displayText(now.displayName),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: exists.length,
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('上書き'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('スキップ'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
