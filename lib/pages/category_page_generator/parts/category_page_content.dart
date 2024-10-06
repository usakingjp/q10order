import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/category_page_generator/providers/providers.dart';

class CategoryPageContent extends HookConsumerWidget {
  const CategoryPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //shared_preferences使うか
    final model = ref.watch(pageSetting);
    //リストかタイルか（スイッチ）
    final listOrTile = useState(model.listOrTile);
    //何個並ぶようにするか（セレクト）
    final rowQty = useState(3);
    //メインカラー（入力）
    //color picker使うか
    final mainColor = useState('');
    //サブカラー（入力）
    final subColor = useState('');
    //商品名は何文字まで表示するか（入力）
    final titleLength = useTextEditingController(text: '0');
    //商品名の中で除外する文字列（入力）
    final exclusionText = useTextEditingController();
    final exclusions = useState([]);
    //どの項目を表示するか（スイッチ）
    final dispTitle = useState(false);
    final dispImage = useState(false);
    final dispPrice = useState(false);
    final dispPoint = useState(false);
    // final disp = useState(false);
    //表示内容のサンプル
    return Column(
      children: [
        SettingRow(
          label: '表示形式',
          widget: OutlinedButton(
            child: (listOrTile.value == 0) ? Text('リスト') : Text('タイル'),
            onPressed: () {
              if (listOrTile.value == 0) {
                listOrTile.value = 1;
              } else {
                listOrTile.value = 0;
              }
              model.listOrTile = listOrTile.value;
            },
          ),
        ),
        SettingRow(
          label: '1列の商品数',
          widget: (listOrTile.value == 0)
              ? null
              : DropdownButton(
                  items: [3, 4, 5, 6].map((e) {
                    return DropdownMenuItem(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(e.toString()),
                      ),
                      value: e,
                    );
                  }).toList(),
                  value: rowQty.value,
                  onChanged: (v) {
                    rowQty.value = v!;
                  }),
        ),
        SettingRow(
          label: 'メインカラー',
          widget: OutlinedButton(
            child: (listOrTile.value == 0) ? Text('リスト') : Text('タイル'),
            onPressed: () {
              if (listOrTile.value == 0) {
                listOrTile.value = 1;
              } else {
                listOrTile.value = 0;
              }
              model.listOrTile = listOrTile.value;
            },
          ),
        ),
      ],
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.label, required this.widget});

  final String label;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return (widget != null)
        ? Row(
            children: [
              Container(
                width: 150,
                child: Text(label),
              ),
              widget!
            ],
          )
        : Container();
  }
}
