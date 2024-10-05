import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/item_management/providers.dart';

import 'item_title_listview_tile.dart';

class ItemListView extends ConsumerWidget {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
          itemCount: ref.watch(getItemDetailModelsView).length,
          itemBuilder: (c, i) {
            var viewItem = ref.watch(getItemDetailModelsView)[i];
            return ItemTitleListViewTile(viewItem: viewItem);
          }),
    );
  }
}
