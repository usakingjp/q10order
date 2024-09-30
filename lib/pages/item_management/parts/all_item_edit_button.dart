import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

enum AllItemEditButtonEnum {
  beforeAdd,
  afterAdd,
  delete;

  String get title {
    switch (this) {
      case beforeAdd:
        return '前方追加';
      case afterAdd:
        return '後方追加';
      case delete:
        return '削除';
      default:
        return 'unknown';
    }
  }

  int get val {
    switch (this) {
      case beforeAdd:
        return 0;
      case afterAdd:
        return 1;
      case delete:
        return 2;
      default:
        return 99;
    }
  }
}

class AllItemEditButton extends ConsumerWidget {
  const AllItemEditButton({super.key, required this.type});
  final AllItemEditButtonEnum type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItemsEditText = ref.watch(allItemEditText);
    return OutlinedButton(
      onPressed: (ref.watch(itemManagementIsWorking))
          ? null
          : () {
              if (!ref.watch(itemManagementIsWorking)) {
                ref.read(itemManagementIsWorking.notifier).state = true;
                var getItemsCopy = [...ref.watch(getItemDetailModels)];
                if (allItemsEditText.isNotEmpty) {
                  for (var item in getItemsCopy) {
                    final beforeItemTitle = item.itemTitle;
                    switch (type.val) {
                      case 0:
                        item.itemTitle = '$allItemsEditText${item.itemTitle}';
                        break;
                      case 1:
                        item.itemTitle = '${item.itemTitle}$allItemsEditText';
                        break;
                      case 2:
                        item.itemTitle =
                            item.itemTitle.replaceAll(allItemsEditText, '');
                        break;
                      default:
                        break;
                    }
                    if (beforeItemTitle != item.itemTitle) {
                      item.edited = true;
                    }
                  }
                  ref.read(getItemDetailModels.notifier).set(getItemsCopy);
                  ref.read(getItemDetailModelsView.notifier).state =
                      ref.watch(getItemDetailModels);
                }
                ref.read(itemManagementIsWorking.notifier).state = false;
              }
            },
      child: Text(type.title),
    );
  }
}
