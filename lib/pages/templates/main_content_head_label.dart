import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class MainContentHeadLabel extends StatelessWidget {
  const MainContentHeadLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: mainColor,
      ),
    );
  }
}
