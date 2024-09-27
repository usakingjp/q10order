import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../provider.dart';
import '../dialog/order_detail_dialog.dart';

class OrderListView extends HookConsumerWidget {
  const OrderListView({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderModels = ref.watch(orders);
    final thisModel = orderModels[index];
    final dcChanging = useState(false);
    return Container(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Row(
          children: [
            Container(
              width: 50,
              child: Checkbox(
                value: thisModel.check,
                onChanged: (ref.watch(status) == 3)
                    ? null
                    : (v) {
                        thisModel.check = v!;
                        ref.read(orders.notifier).replaceModel(thisModel);
                      },
                // onChanged: (v) {
                //   thisModel.check = v!;
                //   ref.read(orders.notifier).replaceModel(thisModel);
                // },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return OrderDetailDialog(
                                          thisModel: thisModel);
                                    });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: (thisModel.isError)
                                    ? Color.fromARGB(255, 241, 34, 61)
                                    : null,
                              ),
                              child: Text(
                                '${thisModel.packNo}　( ${thisModel.paymentDate} )',
                                style: TextStyle(
                                  color:
                                      (thisModel.isError) ? Colors.white : null,
                                  backgroundColor: (thisModel.isError)
                                      ? Color.fromARGB(255, 241, 34, 61)
                                      : null,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${thisModel.receiverName} 様　( ${thisModel.receiverAddress1} )'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            color: (thisModel.desiredDeliveryDate.isNotEmpty)
                                ? const Color.fromARGB(255, 255, 244, 212)
                                : null,
                            child:
                                Text('希望日時： ${thisModel.desiredDeliveryDate}'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            color: (thisModel.shippingMessage.isNotEmpty)
                                ? const Color.fromARGB(255, 255, 244, 212)
                                : null,
                            child: Text(
                              'コメント： ${thisModel.shippingMessage}',
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Container(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                      width: 120, child: const Text('配達会社：')),
                                  Container(
                                    width: 200,
                                    child: (dcChanging.value)
                                        ? TextField(
                                            controller: TextEditingController(
                                                text:
                                                    thisModel.deliveryCompany),
                                            onChanged: ((value) => thisModel
                                                .deliveryCompany = value),
                                            onEditingComplete: () =>
                                                dcChanging.value = false,
                                            onTapOutside: (v) =>
                                                dcChanging.value = false,
                                          )
                                        : Text(thisModel.deliveryCompany),
                                  ),
                                  (!dcChanging.value &&
                                          !thisModel.trackingNoLock)
                                      ? IconButton(
                                          onPressed: () =>
                                              dcChanging.value = true,
                                          iconSize: 16,
                                          color: Color.fromARGB(
                                              255, 153, 153, 153),
                                          icon: Icon(Icons.edit))
                                      : Container(),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: 120, child: const Text('発送予定日：')),
                                Container(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: (thisModel
                                                .estimatedShippingDateLock)
                                            ? null
                                            : () async {
                                                var now = DateTime.now();
                                                final selectedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        firstDate: now,
                                                        lastDate: now.add(
                                                            const Duration(
                                                                days: 30)));
                                                if (selectedDate != null) {
                                                  thisModel
                                                          .estimatedShippingDate =
                                                      DateFormat('yyyMMdd')
                                                          .format(selectedDate);
                                                  thisModel.check = true;
                                                } else {
                                                  thisModel
                                                      .estimatedShippingDate = '';
                                                  thisModel.check = false;
                                                }
                                                ref
                                                    .read(orders.notifier)
                                                    .replaceModel(thisModel);
                                              },
                                        icon: const Icon(
                                            Icons.calendar_today_rounded),
                                      ),
                                    ),
                                    controller: TextEditingController(
                                        text: thisModel.estimatedShippingDate
                                            .replaceAll(' 00:00:00', '')),
                                    readOnly:
                                        thisModel.estimatedShippingDateLock,
                                    // onChanged: (v) {
                                    //   thisModel.estimatedShippingDate = v;
                                    //   thisModel.check = v.isNotEmpty;
                                    //   ref
                                    //       .read(orders.notifier)
                                    //       .replaceModel(thisModel);
                                    // },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: (thisModel.estimatedShippingDateLock)
                                      ? const Icon(
                                          Icons.task_alt_rounded,
                                          size: 16,
                                          color:
                                              Color.fromARGB(255, 81, 207, 159),
                                        )
                                      : const Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          size: 16,
                                          color: Color.fromARGB(
                                              255, 153, 153, 153),
                                        ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: 120, child: const Text('追跡番号：')),
                                Container(
                                  width: 200,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: thisModel.trackingNo),
                                    readOnly: thisModel.trackingNoLock,
                                    onChanged: (v) {
                                      // v = v.replaceAll('-', '');
                                      thisModel.trackingNo =
                                          v.replaceAll('-', '');
                                      thisModel.check = v.isNotEmpty;
                                    },
                                    onEditingComplete: () => ref
                                        .read(orders.notifier)
                                        .replaceModel(thisModel),
                                    onTapOutside: (v) => ref
                                        .read(orders.notifier)
                                        .replaceModel(thisModel),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: (thisModel.trackingNoLock)
                                      ? const Icon(
                                          Icons.task_alt_rounded,
                                          size: 16,
                                          color:
                                              Color.fromARGB(255, 81, 207, 159),
                                        )
                                      : const Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          size: 16,
                                          color: Color.fromARGB(
                                              255, 153, 153, 153),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (thisModel.statusId != 4) {
                      thisModel.statusId = 4;
                      ref.read(orders.notifier).replaceModel(thisModel);
                    } else {
                      thisModel.statusId = 0;
                      if (thisModel.estimatedShippingDateLock) {
                        thisModel.statusId = 1;
                      }
                      if (DateTime.now().isBefore(
                          DateTime.parse(thisModel.estimatedShippingDate))) {
                        thisModel.statusId = 2;
                      }
                      if (thisModel.trackingNoLock) {
                        thisModel.statusId = 3;
                      }
                      ref.read(orders.notifier).replaceModel(thisModel);
                    }
                  },
                  icon: Icon((thisModel.statusId != 4)
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_rounded)),
            ),
          ],
        ),
      ),
    );
  }
}
