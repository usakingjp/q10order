import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/provider.dart';

import '../../../workers/csv/import.dart';

class CsvImportDialog extends HookConsumerWidget {
  const CsvImportDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(orders);
    final counter = useState<int>(0);
    final updateModels = models
        .where((element) =>
            (element.statusId == 1 || element.statusId == 5) &&
            element.trackingNoLock == false)
        .toList();

    List<String> dcList = [];
    for (var model in updateModels) {
      if (dcList.contains(model.deliveryCompany)) continue;
      dcList.add(model.deliveryCompany);
    }

    Widget dcButton(String dc) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: 150,
            height: 100,
            child: OutlinedButton(
                onPressed: () async {
                  const XTypeGroup typeGroup = XTypeGroup(
                    label: 'csv',
                    extensions: <String>['csv'],
                  );
                  final XFile? file = await openFile(
                      acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                  Map<String, String> csvResult = {};
                  if (file != null) {
                    if (dc == 'ヤマト宅急便') {
                      csvResult = await importYamato(file.path);
                    } else if (dc == '佐川急便') {
                      csvResult = await importSagawa(file.path);
                    } else if (dc == 'ゆうパケット') {
                      csvResult = await importPacket(file.path);
                    }
                  }
                  for (var element in updateModels) {
                    if (csvResult.containsKey(element.packNo)) {
                      element.trackingNo = csvResult[element.packNo]!;
                      element.check = true;
                      ref.read(orders.notifier).replaceModel(element);
                      counter.value++;
                    }
                  }
                },
                child: Text(dc))),
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('CSV出力'),
          (counter.value > 0)
              ? Text(
                  '${counter.value}件の追跡番号を入力',
                  style: const TextStyle(fontSize: 14),
                )
              : Container(),
        ],
      ),
      content: Container(
        width: 500,
        height: 120,
        child: (dcList.isNotEmpty)
            ? Row(children: dcList.map((e) => dcButton(e)).toList())
            : const Center(
                child: Text('対象の注文がありません'),
              ),
      ),
      actions: <Widget>[
        FilledButton(
            onPressed: () {
              counter.value = 0;
              Navigator.pop(context);
            },
            child: const Text('閉じる'))
      ],
    );
  }
}
