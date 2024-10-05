import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class MainFrame extends StatelessWidget {
  const MainFrame(
      {super.key, required this.leftNavi, required this.mainContent});
  final Widget leftNavi;
  final Widget mainContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: mainColor, width: 2))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 220,
              padding: const EdgeInsets.all(15),
              child: leftNavi,
            ),
            Expanded(
                child: Container(
                    height: 980,
                    padding: const EdgeInsets.all(15),
                    color: mainContentBackColor,
                    child: mainContent)),
          ],
        ),
      ),
    );
  }
}
