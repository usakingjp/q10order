import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../provider.dart';

class BulkShippingDateBtn extends ConsumerWidget {
  const BulkShippingDateBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderModels = ref.watch(orders);
    return OutlinedButton(
        onPressed: () async {
          final targetOrders =
              orderModels.where((element) => element.statusId == 0).toList();
          if (targetOrders.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('対象の注文がありません'),
              ),
            );
          } else {
            var now = DateTime.now();
            final selectedDate = await showDatePicker(
                context: context,
                firstDate: now,
                initialDate: now,
                lastDate: now.add(const Duration(days: 30)));
            int count = 0;
            if (selectedDate != null) {
              for (var element in targetOrders) {
                if (element.estimatedShippingDateLock) {
                  element.statusId = 1;
                } else {
                  element.estimatedShippingDate =
                      DateFormat('yyyyMMdd').format(selectedDate);
                  element.check = true;
                }
                ref.read(orders.notifier).replaceModel(element);
                count++;
              }
              if (count > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$count件に発送日(${DateFormat('yyyyMMdd').format(selectedDate)})を入力しました'),
                  ),
                );
              }
            }
          }
        },
        child: const Text('発送日一括入力'));
  }
}

Future<void> bulkShippingDate(BuildContext context, WidgetRef ref) async {
  final orderModels = ref.watch(orders);
  final targetOrders =
      orderModels.where((element) => element.statusId == 0).toList();
  if (targetOrders.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('対象の注文がありません'),
      ),
    );
  } else {
    var now = DateTime.now();
    final selectedDate = await showDatePicker(
        context: context,
        firstDate: now,
        initialDate: now,
        lastDate: now.add(const Duration(days: 30)));
    int count = 0;
    if (selectedDate != null) {
      for (var element in targetOrders) {
        if (element.estimatedShippingDateLock) {
          element.statusId = 1;
        } else {
          element.estimatedShippingDate =
              DateFormat('yyyyMMdd').format(selectedDate);
          element.check = true;
        }
        ref.read(orders.notifier).replaceModel(element);
        count++;
      }
      if (count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '$count件に発送日(${DateFormat('yyyyMMdd').format(selectedDate)})を入力しました'),
          ),
        );
      }
    }
  }
}
