import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class MainContentHeadContainer extends StatelessWidget {
  const MainContentHeadContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
        constraints: BoxConstraints(minWidth: 200),
        decoration: BoxDecoration(
            border: Border.all(color: mainColor, width: 3),
            borderRadius: BorderRadius.circular(30)),
        child: child);
  }
}
