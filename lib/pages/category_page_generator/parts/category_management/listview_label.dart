import 'package:flutter/material.dart';

import '../../../../consts/colors.dart';

class ListviewLabel extends StatelessWidget {
  const ListviewLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: mainColor),
            borderRadius: BorderRadius.circular(30)),
        child: Text(
          label,
          style: TextStyle(
              color: mainColor, fontSize: 12, fontWeight: FontWeight.bold),
        ));
  }
}
