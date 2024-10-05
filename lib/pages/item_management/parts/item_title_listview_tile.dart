import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';
import 'package:q10order/pages/item_management/providers.dart';

class ItemTitleListViewTile extends HookConsumerWidget {
  const ItemTitleListViewTile({
    super.key,
    required this.viewItem,
  });

  final GetItemDetailModel viewItem;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = useState(false);
    final beforeTitle = viewItem.itemTitle;
    void editFinish() {
      ref.read(getItemDetailModels.notifier).change(viewItem);
      editMode.value = false;
    }

    return Container(
        height: 40,
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children: [
            Container(
                width: 150,
                padding: const EdgeInsets.only(left: 10),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    disabledBackgroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                    // overlayColor: Colors.yellow,
                  ),
                  child: Text(viewItem.sellerCode),
                  // statesController:MaterialStateProperty.all<Color>(Colors.teal)
                )),
            IconButton(
              onPressed: () => editMode.value = !editMode.value,
              icon: (editMode.value)
                  ? const Icon(Icons.edit_note)
                  : const Icon(Icons.edit_note_outlined),
            ),
            Expanded(
                child: (editMode.value)
                    ? TextField(
                        controller: TextEditingController(
                          text: viewItem.itemTitle,
                        ),
                        onChanged: (v) {
                          viewItem.itemTitle = v;
                          if (beforeTitle != v) {
                            viewItem.edited = true;
                          } else {
                            viewItem.edited = false;
                          }
                        },
                        onSubmitted: (v) {
                          editFinish();
                        },
                        onTapOutside: (v) {
                          editFinish();
                        },
                      )
                    : Container(
                        color: (viewItem.itemTitle.length > 100)
                            ? Colors.red
                            : null,
                        child: Text(
                          viewItem.itemTitle,
                          maxLines: 1,
                        ),
                      )),
          ],
        ));
  }
}
