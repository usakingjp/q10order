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
            title: const TabBar(
              // labelPadding: EdgeInsets.symmetric(vertical: 30),
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              labelColor: Color.fromARGB(255, 111, 67, 192),
              unselectedLabelColor: Colors.grey,
              // indicatorColor: Colors.red,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              // indicator: BoxDecoration(
              //   color: Colors.purple,
              //   borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              // ),
              dividerHeight: 0,
              tabs: [
                Tab(
                  text: "受注システム",
                ),
                Tab(
                  text: "商品管理システム",
                  // child: Expanded(
                  //   child: Container(
                  //     color: Colors.red,
                  //     child: Text('商品管理システム'),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
          body: TabBarView(
              children: [MainPage(version: "1.1.4"), ItemManagementPage()]),
        ),
      ),
    );
  }
}
