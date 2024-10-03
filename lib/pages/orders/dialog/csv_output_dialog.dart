import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/provider.dart';
import 'package:q10order/pages/orders/dialog/pdf_preview.dart';

import '../../../models/order_model.dart';
import '../../../workers/csv/output.dart';
import 'address_edit.dart';

class CsvOutputDialog extends ConsumerWidget {
  const CsvOutputDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final models = ref.watch(orders);
    List<OrderModel> updateModels = [];
    for (var element in models) {
      if (element.check) updateModels.add(element);
    }
    for (var model in updateModels) {
      var items = model.itemModels;
      items.sort((a, b) => a.itemCode.compareTo(b.itemCode));
    }
    updateModels
        .sort((a, b) => a.itemModels.length.compareTo(b.itemModels.length));
    updateModels.sort((a, b) => a.itemModels[0].itemOptionCode
        .compareTo(b.itemModels[0].itemOptionCode));
    updateModels.sort(
        (a, b) => a.itemModels[0].itemCode.compareTo(b.itemModels[0].itemCode));
    updateModels.sort((a, b) => a.deliveryCompany.compareTo(b.deliveryCompany));
    Map<String, List<OrderModel>> map = {};
    List<String> list = [];
    for (var model in updateModels) {
      if (!map.containsKey(model.deliveryCompany)) {
        map[model.deliveryCompany] = [];
        list.add(model.deliveryCompany);
      }
      map[model.deliveryCompany]!.add(model);
    }
    Widget dcButton(String dc, List<OrderModel> val) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: 150,
            height: 100,
            child: OutlinedButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AddressEdit(updateModels: val);
                      });
                  String fileName = '';
                  switch (dc) {
                    case 'ヤマト宅急便':
                      fileName = 'Q10_yamato.csv';
                      break;
                    case '佐川急便':
                      fileName = 'Q10_sagawa.csv';
                      break;
                    case 'ゆうパケット':
                      fileName = 'Q10_yupacket.csv';
                      break;
                    default:
                      fileName = 'Q10_output.csv';
                      break;
                  }
                  FileSaveLocation? getPath = await getSaveLocation(
                    acceptedTypeGroups: [
                      const XTypeGroup(label: 'csv', extensions: ['csv'])
                    ],
                    suggestedName: fileName,
                  );
                  if (getPath != null) {
                    if (dc == 'ヤマト宅急便') {
                      await outYamato(getPath.path, val);
                    } else if (dc == '佐川急便') {
                      await outSagawa(getPath.path, val);
                    } else if (dc == 'ゆうパケット') {
                      await outPacket(getPath.path, val);
                    }
                    for (var e in val) {
                      e.invoiceIssue = true;
                      if (e.estimatedShippingDateLock && e.invoiceIssue) {
                        e.statusId = 5;
                      }
                    }
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(dc), Text('(${val.length}件)')],
                ))),
      );
    }

    return AlertDialog(
      title: const Text('CSV出力'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 500,
            height: 120,
            child: (list.isNotEmpty)
                ? Row(children: list.map((e) => dcButton(e, map[e]!)).toList())
                : const Center(
                    child: Text('対象の注文がありません'),
                  ),
          ),
          (list.isNotEmpty)
              ? Row(
                  children: [
                    Container(
                      width: 150,
                      height: 100,
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (_) {
                                return PreviewPage('PickingList',
                                    updateModels: updateModels);
                              });
                        },
                        child: const Text('全商品リスト'),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 100,
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (_) {
                                return PreviewPage('Sheets',
                                    updateModels: updateModels);
                              });
                        },
                        child: const Text('個別シート'),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      actions: <Widget>[
        FilledButton(
            onPressed: () => Navigator.pop(context), child: const Text('閉じる'))
      ],
    );
  }
}
