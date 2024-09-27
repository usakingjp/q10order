import 'dart:io';

import 'package:charset/charset.dart';
import 'package:fast_csv/fast_csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../workers/csv/import.dart';
import '../../../workers/db/itemnames_db.dart' as itemNameDB;
import '../../../models/item_name.dart';
import '../../../provider.dart';
import '../dialog/exist_dialog.dart';

class CsvUploadButton extends ConsumerWidget {
  const CsvUploadButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['csv'],
          );
          List<ItemName> importNames = [];
          if (result != null) {
            // String csvData = await File(result.paths.first!)
            //     .readAsString(encoding: shiftJis);
            // List<List<String>> csvList = parse(csvData);
            var res = await importCsv(result.paths.first!, 'Shift_JIS');
            for (var data in res) {
              //data[0] is q10cord. this place is number only. required.
              //data[1] is shopCord. not required.
              //data[2] is displayName. required.
              if (data[0].toString().isEmpty || data[2].toString().isEmpty) {
                continue;
              }
              int? q10cord = int.tryParse(data[0].toString());
              if (q10cord == null) {
                continue;
              }
              importNames.add(ItemName(
                  q10cord: data[0].toString(),
                  shopCord: data[1].toString(),
                  displayName: data[2].toString()));
            }
            print(importNames.length);
            if (importNames.isNotEmpty) {
              List<ItemName> exists = await itemNameDB.exists(importNames);
              if (exists.isNotEmpty) {
                //重複に対する確認、上書きorスキップ
                bool? dialogResult = await showDialog(
                    context: context,
                    builder: (context) {
                      return ExistDialog(data: importNames, exists: exists);
                    });
                List<String> existCords = [
                  for (var i = 0; i < exists.length; i++) exists[i].q10cord
                ];
                if (dialogResult != null) {
                  if (dialogResult) {
                    await itemNameDB.insertAll(importNames,
                        updates: existCords);
                  } else {
                    await itemNameDB.insertAll(importNames, skips: existCords);
                  }
                }
              } else {
                //重複がない場合
                await itemNameDB.insertAll(importNames);
              }

              List<ItemName> dbdata = await itemNameDB.getAll();
              if (dbdata.isNotEmpty) {
                ref.read(itemNames.notifier).set(dbdata);
              }
            } else {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                          width: 300,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text('対象のデータがありません')),
                      actions: [
                        OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('閉じる'))
                      ],
                    );
                  });
            }
          }
        },
        icon: const Icon(Icons.upload_file));
  }
}
