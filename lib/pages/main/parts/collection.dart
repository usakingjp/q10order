import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider.dart';

TextButton statusButton(int statusId, String text, WidgetRef ref) {
  return TextButton(
    style: (ref.watch(status) == statusId)
        ? TextButton.styleFrom(
            backgroundColor: (ref
                    .watch(orders)
                    .where((element) => element.statusId == statusId)
                    .where((element) => element.isError)
                    .isNotEmpty)
                ? const Color.fromARGB(255, 241, 34, 61)
                : const Color.fromARGB(255, 111, 67, 192),
          )
        : null,
    onPressed: () {
      for (var element in ref.watch(orders)) {
        element.check = false;
      }
      ref.read(status.notifier).state = statusId;
      ref.read(checkers.notifier).state = [];
    },
    child: Text(
      '$text: ${ref.watch(orders).where((element) => element.statusId == statusId).length} 件',
      style: (ref.watch(status) == statusId)
          ? TextStyle(color: Colors.white)
          : null,
    ),
  );
}

enum CheckerId {
  all(displayName: '全て', val: 1),
  yamato(displayName: 'ヤマト宅急便', val: 2),
  sagawa(displayName: '佐川急便', val: 3),
  yupacket(displayName: 'ゆうパケット', val: 4),
  ;

  final String displayName;
  final int val;
  const CheckerId({required this.displayName, required this.val});
}

class CheckButton extends HookConsumerWidget {
  const CheckButton({required this.im, super.key});
  final CheckerId im;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int count = (im == CheckerId.all)
        ? ref
            .watch(orders)
            .where(
              (e) => e.statusId == ref.watch(status),
            )
            .toList()
            .length
        : ref
            .watch(orders)
            .where(
              (e) =>
                  e.statusId == ref.watch(status) &&
                  im.displayName == e.deliveryCompany,
            )
            .toList()
            .length;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        style: (ref.watch(checkers).contains(im.val))
            ? TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 148, 120, 199),
              )
            : TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 194, 194, 194),
              ),
        onPressed: () {
          final bool checkersChecked =
              ref.watch(checkers).contains(im.val); //true->既チェック,false->未チェック
          List<int> clone = [...ref.watch(checkers)];
          bool execution = false;
          switch (im) {
            case CheckerId.all:
              execution = true;
              clone = [];
              for (var element in ref.watch(orders)) {
                element.check = false;
              }
              if (!checkersChecked) {
                execution = false;
                print('${im.displayName}:ON');
                clone.add(im.val);
                // ref.read(checkers.notifier).state = [im.val];
                for (var element in ref.watch(orders)) {
                  if (element.statusId == ref.watch(status)) {
                    element.check = true;
                    execution = true;
                    if (!checkersChecked) {
                      switch (element.deliveryCompany) {
                        case 'ヤマト宅急便':
                          if (!clone.contains(CheckerId.yamato.val)) {
                            print('${CheckerId.yamato.displayName}:ON');
                            clone.add(CheckerId.yamato.val);
                          }
                          break;
                        case '佐川急便':
                          if (!clone.contains(CheckerId.sagawa.val)) {
                            print('${CheckerId.sagawa.displayName}:ON');
                            clone.add(CheckerId.sagawa.val);
                          }
                          break;
                        case 'ゆうパケット':
                          if (!clone.contains(CheckerId.yupacket.val)) {
                            print('${CheckerId.yupacket.displayName}:ON');
                            clone.add(CheckerId.yupacket.val);
                          }
                          break;
                      }
                    }
                  }
                }
              }
              break;
            case CheckerId.yamato:
            case CheckerId.sagawa:
            case CheckerId.yupacket:
              if (!checkersChecked) {
                clone.add(im.val);
                print('${im.displayName}:ON');
              } else {
                clone.remove(im.val);
                print('${im.displayName}:OFF');
                if (clone.contains(CheckerId.all.val)) {
                  clone.remove(CheckerId.all.val);
                  print('${CheckerId.all.displayName}:OFF');
                }
              }
              for (var element in ref.watch(orders)) {
                if (element.statusId == ref.watch(status)) {
                  if (element.deliveryCompany == im.displayName) {
                    execution = true;
                    element.check = !checkersChecked;
                  }
                }
              }
              break;
            default:
              break;
          }
          if (execution) {
            print('execution');
            ref.read(orders.notifier).refresh();
            ref.read(checkers.notifier).state = clone;
          } else {
            print('canceled');
          }
        },
        child: Text(
          '${im.displayName} ( $count )',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
