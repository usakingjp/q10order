import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.label, required this.widget});

  final String label;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return (widget != null)
        ? Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text(label),
                ),
                widget!
              ],
            ),
          )
        : Container();
  }
}
