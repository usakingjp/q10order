import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OriginalCheckBox extends StatelessWidget {
  const OriginalCheckBox(
      {super.key,
      required this.label,
      required this.prefLabel,
      required this.val});

  final String label;
  final String prefLabel;
  final ValueNotifier<bool> val;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      child: InkWell(
        onTap: () {
          val.value = !val.value;
        },
        child: Row(
          children: [
            Text(label),
            Checkbox(
              value: val.value,
              onChanged: (v) async {
                if (v != null) {
                  val.value = v;
                } else {
                  val.value = false;
                }
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool(prefLabel, v ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
