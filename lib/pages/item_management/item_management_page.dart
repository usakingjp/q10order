import 'package:flutter/material.dart';
import 'package:q10order/pages/item_management/parts/left_navi.dart';

import 'parts/all_item_edit_row.dart';
import 'parts/item_list_view.dart';

class ItemManagementPage extends StatelessWidget {
  const ItemManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 111, 67, 192), width: 2))),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const LeftNavi(),
            Expanded(
              child: Container(
                height: 980,
                padding: const EdgeInsets.all(15),
                color: const Color.fromARGB(255, 230, 230, 230),
                child: Container(
                  child: const Column(
                    children: [
                      AllItemEditRow(),
                      Expanded(
                        child: ItemListView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
