import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'category_page/pc_content.dart';

class CategoryPageContent extends HookConsumerWidget {
  const CategoryPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            width: double.infinity / 2,
            color: Colors.deepPurple,
            child: const TabBar(
              tabs: [
                Tab(
                  text: "ＰＣ",
                ),
                Tab(
                  text: "スマホ",
                ),
              ],
              // controller: tabCtrl,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              labelColor: Color.fromARGB(255, 111, 67, 192),
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0,
            ),
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: TabBarView(
              children: [
                PcContent(),
                PcContent(),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
