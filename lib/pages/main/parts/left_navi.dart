import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/models/api_result_model.dart';

import '../../../models/order_model.dart';
import '../../../provider.dart';
import '../../../workers/apis/get_shipping_info_v3.dart';
import '../../../workers/apis/set_seller_check_yn_v2.dart';
import '../../../workers/apis/set_sending_info.dart';
import '../../items/items_name.dart';
import '../../setting/setting_page.dart';
import '../dialog/csv_import_dialog.dart';
import '../dialog/csv_output_dialog.dart';
import 'bulk_shipping_date_btn.dart';

class LeftNavi extends ConsumerWidget {
  const LeftNavi({super.key, required this.version});
  final String version;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderModels = ref.watch(orders);
    final working = ref.watch(workingProvider);
    final workingN = ref.read(workingProvider.notifier);

    Padding leftFilledButton(String label, Function()? func) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: (working) ? null : func,
            child: Text(label),
          ),
        ),
      );
    } //leftFilledButton

    Padding leftOutLinedButton(String label, Function()? func) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: (working) ? null : func,
            child: Text(label),
          ),
        ),
      );
    } //leftOutLinedButton

    Future<void> getOrderFunction() async {
      var result = await getShippingInfoV3(ref: ref);
      var sended = await getShippingInfoV3(ref: ref, shippingStatus: '4');
      var models = ref.read(orders.notifier);
      if (result.containsKey('ResultObject')) {
        var resModels = toOrderModels(result['ResultObject']);
        for (var resModel in resModels) {
          if (!models.isContain(resModel)) {
            models.addModel(resModel);
            ref.read(status.notifier).state = 0;
          }
        }
        if (sended.containsKey('ResultObject')) {
          // for (var element in sended['ResultObject']) {
          //   print(element['BuyerEmail']);
          // }
          var senModels = toOrderModels(sended['ResultObject']);
          resModels.addAll(senModels);
          for (var model in ref.watch(orders)) {
            if (resModels.where((e) => e.packNo == model.packNo).isEmpty) {
              model.isError = true;
            }
          }
        }
      }
    } //getOrderFunction

    Future<void> setSendingFunction() async {
      workingN.state = true;
      int count = 0;
      List<OrderModel> updateModels =
          orderModels.where((orderModel) => orderModel.check).toList();
      // List<OrderModel> updateModels = [];
      // for (var element in orderModels) {
      //   if (element.check) updateModels.add(element);
      // }
      if (updateModels.isNotEmpty) {
        for (var element in updateModels) {
          ApiResultModel result =
              await setSendingInfo(ref: ref, model: element);
          if (result.result) {
            element.check = false;
            element.trackingNoLock = true;
            element.statusId = 3;
            ref.read(orders.notifier).replaceModel(element);
            count++;
          } else {
            //エラー
            print(result.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${result.packNo} : ${result.message}'),
              ),
            );
          }
        }
      }
      workingN.state = false;
      String snackComent = '';
      if (updateModels.isEmpty) {
        snackComent = '注文が選択されていません';
      } else if (count > 0) {
        snackComent = '$count件の発送報告に成功';
      }
      if (snackComent.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackComent),
          ),
        );
      }
    } //setSendingFunction

    Future<void> setSellerCheckFuction() async {
      workingN.state = true;
      int count = 0;
      List<OrderModel> updateModels = orderModels
          .where((orderModel) =>
              orderModel.check && orderModel.statusId == ref.watch(status))
          .toList();
      // List<OrderModel> updateModels = [];
      // for (var orderModel in orderModels) {
      //   if (orderModel.check) updateModels.add(orderModel);
      // }orderModels[index].statusId == ref.watch(status)
      if (updateModels.isNotEmpty) {
        for (var updateModel in updateModels) {
          ApiResultModel result =
              await setSellerChackYnV2(ref: ref, model: updateModel);
          if (result.result) {
            updateModel.check = false;
            updateModel.estimatedShippingDateLock = true;
            updateModel.statusId = 1;
            if (updateModel.estimatedShippingDateLock &&
                updateModel.invoiceIssue) {
              updateModel.statusId = 5;
            }
            if (DateTime.now()
                .isBefore(DateTime.parse(updateModel.estimatedShippingDate))) {
              updateModel.statusId = 2;
            }
            ref.read(orders.notifier).replaceModel(updateModel);
            count++;
          } else {
            //エラー
            print(result.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${result.packNo} : ${result.message}'),
              ),
            );
          }
        }
      }
      workingN.state = false;
      String snackComent = '';
      if (updateModels.isEmpty) {
        snackComent = '注文が選択されていません';
      } else if (count > 0) {
        snackComent = '$count件の発送日反映に成功';
      }
      if (snackComent.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackComent),
          ),
        );
      }
    } //setSellerCheckFuction

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (working)
                          ? null
                          : () async {
                              workingN.state = true;
                              await getOrderFunction();
                              workingN.state = false;
                            },
                      child: const Icon(Icons.autorenew_rounded),
                    ),
                  ),
                ),
                //発送日一括入力ボタン
                (ref.watch(status) == 0)
                    // ? const BulkShippingDateBtn()
                    ? leftOutLinedButton('発送日一括入力', () async {
                        await bulkShippingDate(context, ref);
                      })
                    : Container(),
                //発送日反映ボタン
                leftFilledButton('発送日反映', setSellerCheckFuction),
                //未発送を選択ボタン
                (ref.watch(status) == 1)
                    ? leftOutLinedButton('未発送を選択', () {
                        for (var element in orderModels) {
                          if (element.statusId != 1) {
                            continue;
                          }
                          if (element.trackingNo.isEmpty) {
                            element.check = true;
                            ref.read(orders.notifier).replaceModel(element);
                          }
                        }
                      })
                    : Container(),
                //送り状CSV発行ボタン
                leftFilledButton('送り状CSV発行', () async {
                  workingN.state = true;
                  try {
                    await showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return const CsvOutputDialog();
                        });

                    for (var element in ref.watch(orders)) {
                      element.check = false;
                      ref.read(orders.notifier).replaceModel(element);
                    }
                    ref.read(checkers.notifier).state = [];
                  } catch (e) {
                    print(e.toString());
                  }
                  workingN.state = false;
                }),
                //追跡番号インポートボタン
                leftFilledButton('追跡番号インポート', () async {
                  workingN.state = true;
                  //CSV読み込み
                  for (var model in orderModels) {
                    if (model.check) {
                      model.check = false;
                      ref.read(orders.notifier).replaceModel(model);
                    }
                  }
                  ref.read(checkers.notifier).state = [];
                  await showDialog(
                      context: context,
                      builder: (_) {
                        return const CsvImportDialog();
                      });
                  workingN.state = false;
                }),
              ],
            ),
            //発送完了ボタン
            Column(
              children: [
                leftFilledButton('発送完了', setSendingFunction),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingPage()));
                        },
                        icon: const Icon(Icons.settings)),
                    IconButton(
                        onPressed: () {
                          // sample();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ItemsName()));
                        },
                        icon: const Icon(Icons.abc)),
                  ],
                ),
                Text('version : $version'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
