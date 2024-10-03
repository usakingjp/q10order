import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/item_management/parts/left_navi_action_button.dart';

class LeftNavi extends ConsumerWidget {
  const LeftNavi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LeftNaviActionButton(type: LeftNaviActionButtonEnum.get),
        LeftNaviActionButton(type: LeftNaviActionButtonEnum.update),
      ],
    );
    return Container(
      width: 200,
      padding: const EdgeInsets.all(15),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LeftNaviActionButton(type: LeftNaviActionButtonEnum.get),
          LeftNaviActionButton(type: LeftNaviActionButtonEnum.update),
        ],
      ),
    );
  }
}
