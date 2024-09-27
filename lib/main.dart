import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/item_management/item_management_page.dart';
import 'pages/main/main_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MainPage(
      //   version: '1.1.4',
      // ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(text: "受注システム"),
              Tab(
                text: "商品管理システム",
              )
            ]),
          ),
          body: TabBarView(
              children: [MainPage(version: "1.1.4"), ItemManagementPage()]),
        ),
      ),
    );
  }
}
