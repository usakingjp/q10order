import 'package:characters/characters.dart';

void adrspl(String text) {
  text = text.codeUnits
      .map((codeUnit) {
        if (codeUnit >= 0xFF10 && codeUnit <= 0xFF19) {
          // 全角の数字の範囲
          return codeUnit - 0xFF10 + 0x30; // 半角の数字に変換
        } else {
          return codeUnit; // 数字以外の文字はそのまま
        }
      })
      .map((codeUnit) => String.fromCharCode(codeUnit))
      .join('');
  var replacedText1 =
      text.replaceAllMapped(RegExp(r'(\d+)[-—–−ー~_\.のノ](\d+)'), (match) {
    return '${match.group(1)}-${match.group(2)}';
  });
  print(replacedText1);

  var replacedText2 = replacedText1
      .replaceAllMapped(RegExp(r'([0-9]+[-0-9]*)(\s*)([^0-9-\s]+)'), (match) {
    return '${match.group(1)}*${match.group(3)}';
  });

  print(replacedText2);

  // var patterns = [
  //   RegExp(r",", unicode: true),
  //   RegExp(r"([0-9])?ー―?‐－", unicode: true),
  //   RegExp(r"([0-9])?ー―?‐－", unicode: true),
  //   RegExp(r"([0-9]+)\s([0-9]+)", unicode: true),
  //   RegExp(r"([0-9]+)\s([0-9]+)", unicode: true),
  //   RegExp(r"([番地])\s([0-9]+)", unicode: true),
  //   RegExp(r"([0-9]+[-0-9地番条室号階のF]*?)([^-\s0-9地番条号階目丁のF].{5,})", unicode: true),
  //   RegExp(r"[\s]{2,}", unicode: true)
  // ];
  // var replacements = [
  //   " ",
  //   "\$1-\$2",
  //   "\$1-\$2",
  //   "\$1-\$2",
  //   "\$1-\$2",
  //   "\$1\$2",
  //   "\$1 \$2",
  //   " "
  // ];

  // for (var i = 0; i < patterns.length; i++) {
  //   text = text.replaceAll(patterns[i], replacements[i]);
  // }

  // var textSplit = RegExp(
  //         r"(.*[0-9]+[F室号地番]+?)\s([^0-9]+.*)|(.*-[0-9]+)\s([^0-9]+.*)|(.*[0-9]{2,})\s([^0-9]+.*)|(.*[0-9])\s([^0-9]+.*)",
  //         unicode: true)
  //     .allMatches(text)
  //     .map((match) => match.group(0))
  //     .toList();

  // print('textSplit: $textSplit');
}
