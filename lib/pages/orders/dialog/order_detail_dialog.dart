import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/order_model.dart';

class OrderDetailDialog extends StatelessWidget {
  const OrderDetailDialog({
    super.key,
    required this.thisModel,
  });

  final OrderModel thisModel;

  @override
  Widget build(BuildContext context) {
    Widget textView(String label, String val) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.amber,
              width: 120,
              child: (label == '送付先')
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label),
                        IconButton(
                            iconSize: 14,
                            onPressed: () async {
                              final data = ClipboardData(
                                  text:
                                      '${thisModel.receiverName}\n${thisModel.receiverZipcode}\n${thisModel.receiverAddress1}${thisModel.receiverAddress2}${(thisModel.receiverAddress3.isNotEmpty) ? '\n${thisModel.receiverAddress3}' : ''}\n${(thisModel.receiverMobile.isNotEmpty) ? thisModel.receiverMobile : thisModel.receiverTel}');
                              await Clipboard.setData(data);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('コピーしました'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_sharp)),
                      ],
                    )
                  : (label == '送り状の備考欄')
                      ? Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          child: Text(label),
                        )
                      : Text(label),
            ),
            Container(
              // color: Colors.blue,
              width: 450,
              child: (label == '送付先')
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SelectableText(
                        val,
                        maxLines: 5,
                      ),
                    )
                  : (label == 'コメント')
                      ? SelectableText(
                          val,
                          maxLines: 1,
                        )
                      : (label == '送り状の備考欄')
                          ? TextField(
                              controller: TextEditingController(text: val),
                              onChanged: (value) => thisModel.coment = value,
                            )
                          : Text(
                              val,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
            ),
          ],
        ),
      );
    }

    return AlertDialog(
      title: const Text('注文詳細'),
      content: Container(
        width: 650,
        height: 500,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textView('パッケージNo', thisModel.packNo),
            textView('送付先',
                '${thisModel.receiverName}様\n〒${thisModel.receiverZipcode}\n${thisModel.receiverAddress1}${thisModel.receiverAddress2}${(thisModel.receiverAddress3.isNotEmpty) ? '\n${thisModel.receiverAddress3}' : ''}\n${(thisModel.receiverMobile.isNotEmpty) ? thisModel.receiverMobile : thisModel.receiverTel}'),
            (thisModel.senderName.isNotEmpty)
                ? textView('発送元',
                    '${thisModel.senderName}\n${thisModel.senderZipcode}\n${thisModel.senderAddress}\n${thisModel.senderTel}')
                : Container(),
            textView('希望日時', thisModel.desiredDeliveryDate),
            textView('コメント', thisModel.shippingMessage),
            textView('送り状の備考欄', thisModel.coment),
            Container(
              height: 250,
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                  itemCount: thisModel.itemModels.length,
                  itemBuilder: (context, i) {
                    final thisItem = thisModel.itemModels[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            child: Text('商品${i + 1}'),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      thisItem.itemTitle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    (thisItem.itemOption.isNotEmpty)
                                        ? SelectableText(
                                            thisItem.itemOption,
                                            maxLines: 1,
                                          )
                                        : Container(),
                                    Row(
                                      children: [
                                        const Text('('),
                                        SelectableText(
                                          '${thisItem.itemCode}${thisItem.itemOptionCode}',
                                          maxLines: 1,
                                        ),
                                        const Text(')'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 145, 145, 145),
                                        width: 3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        thisItem.orderQty,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: thisModel.itemModels.map(
              //     (e) {
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 8),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Container(
              //               width: 120,
              //               child: const Text('商品１'),
              //             ),
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   width: 400,
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         e.itemTitle,
              //                         overflow: TextOverflow.ellipsis,
              //                         maxLines: 1,
              //                       ),
              //                       (e.itemOption.isNotEmpty)
              //                           ? SelectableText(
              //                               e.itemOption,
              //                               maxLines: 1,
              //                             )
              //                           : Container(),
              //                       SelectableText(
              //                         '(${e.itemCode}${e.itemOptionCode})',
              //                         maxLines: 1,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.only(left: 16.0),
              //                   child: Container(
              //                     width: 50,
              //                     height: 50,
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(3),
              //                       border: Border.all(
              //                           color: const Color.fromARGB(
              //                               255, 145, 145, 145),
              //                           width: 3),
              //                     ),
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Center(
              //                         child: Text(
              //                           '${e.orderQty}',
              //                           style: const TextStyle(fontSize: 18),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   ).toList(),
              // ),
            ),
          ],
        )),
      ),
      actions: <Widget>[
        FilledButton(
            onPressed: () {
              Navigator.pop(context);
              print(thisModel.coment);
            },
            child: const Text('閉じる'))
      ],
    );
  }
}
