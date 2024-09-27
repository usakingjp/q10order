import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider.dart';

Text labelText(String txt) {
  return Text(
    txt,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
  );
}

class SortLabelText extends HookConsumerWidget {
  const SortLabelText({super.key, required this.label, required this.column});
  final String label;
  final String column;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asc = useState(true);
    return TextButton(
      child: Text(
        '$label${(asc.value) ? '△' : '▽'}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          // foregroundColor: const Color.fromARGB(255, 78, 78, 78),
          // minimumSize: Size.zero,
          // padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft),
      onPressed: () {
        asc.value = !asc.value;
        ref.read(itemNames.notifier).sort(column: column, asc: asc.value);
      },
    );
  }
}
