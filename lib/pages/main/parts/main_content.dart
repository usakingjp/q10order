import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider.dart';
import 'collection.dart';
import 'order_list_view.dart';

class MainContent extends HookConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderModels = ref.watch(orders);
    return Container(
      width: double.infinity,
      height: 980,
      padding: const EdgeInsets.all(15),
      color: const Color.fromARGB(255, 230, 230, 230),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    statusButton(0, '新規', ref),
                    statusButton(1, '準備中', ref),
                    statusButton(5, 'CSV発行済み', ref),
                    statusButton(2, '指定日待ち', ref),
                    statusButton(3, '発送完了', ref),
                    statusButton(4, '保留', ref),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CheckButton(im: CheckerId.all),
                    CheckButton(
                      im: CheckerId.yamato,
                    ),
                    CheckButton(
                      im: CheckerId.sagawa,
                    ),
                    CheckButton(
                      im: CheckerId.yupacket,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: orderModels.length,
                  itemBuilder: (context, index) {
                    if (orderModels[index].statusId == ref.watch(status)) {
                      return OrderListView(index: index);
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
