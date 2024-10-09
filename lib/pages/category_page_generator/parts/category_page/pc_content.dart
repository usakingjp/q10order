import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/providers.dart';
import '../dialog/color_picker_dialog.dart';
import 'original_check_box.dart';
import 'setting_row.dart';
import 'web_mock_list_style.dart';
import 'web_mock_tile_style.dart';

class PcContent extends HookConsumerWidget {
  const PcContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final psModel = ref.watch(pageSetting);
    //リストかタイルか（スイッチ）
    final listOrTile = useState(psModel.listOrTile);
    //何個並ぶようにするか（セレクト）
    final rowQty = useState(psModel.rowQty);
    //メインカラー（入力）
    //color picker使うか
    final accentColor = useState<Color>(Color(psModel.accentColor));
    //サブカラー（入力）
    final subColor = useState<Color>(Color(psModel.subColor));
    //商品名は何文字まで表示するか（入力）
    final titleLengthText = useTextEditingController(text: psModel.titleLength);
    final titleLength = useState(int.tryParse(psModel.titleLength) ?? 20);
    //商品名の中で除外する文字列（入力）
    final exclusionText = useTextEditingController();
    final exclusions = useState(psModel.exclusions);
    //どの項目を表示するか（スイッチ）
    final dispTitle = useState(psModel.dispTitle);
    final dispBrand = useState(psModel.dispBrand);
    final dispImage = useState(psModel.dispImage);
    final dispPrice = useState(psModel.dispPrice);
    final dispPromotion = useState(psModel.dispPromotion);
    //商品画像URL・形式
    final imageUrl = useTextEditingController(text: psModel.imageUrl);
    final imageFormat = useState(psModel.imageFormat);
    final sampleWidthText = useTextEditingController(text: psModel.sampleWidth);
    final sampleWidth = useState(int.tryParse(psModel.sampleWidth) ?? 700);
    // final disp = useState(false);
    //表示内容のサンプル
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingRow(
            label: '表示形式',
            widget: OutlinedButton(
              child: (listOrTile.value == 0)
                  ? const Text('リスト')
                  : const Text('タイル'),
              onPressed: () async {
                if (listOrTile.value == 0) {
                  listOrTile.value = 1;
                } else {
                  listOrTile.value = 0;
                }
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setInt('listOrTile', listOrTile.value);
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
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(e.toString()),
                        ),
                      );
                    }).toList(),
                    value: rowQty.value,
                    onChanged: (v) async {
                      rowQty.value = v ?? 3;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt('rowQty', v ?? 3);
                    }),
          ),
          SettingRow(
            label: 'アクセントカラー',
            widget: InkWell(
              child: Container(
                width: 80,
                height: 30,
                color: accentColor.value,
              ),
              onTap: () async {
                Color? pickedColor = await showDialog(
                    context: context,
                    builder: (_) {
                      return ColorPickerDialog(accentColor.value);
                    });
                if (pickedColor != null) {
                  accentColor.value = pickedColor;
                  print(pickedColor.value);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setInt('accentColor', pickedColor.value);
                }
              },
            ),
          ),
          SettingRow(
            label: 'サブカラー',
            widget: InkWell(
              child: Container(
                width: 80,
                height: 30,
                color: subColor.value,
              ),
              onTap: () async {
                Color? pickedColor = await showDialog(
                    context: context,
                    builder: (_) {
                      return ColorPickerDialog(subColor.value);
                    });
                if (pickedColor != null) {
                  subColor.value = pickedColor;
                  print(pickedColor.value);
                  // print(pickedColor.toHexString());
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setInt('subColor', pickedColor.value);
                }
              },
            ),
          ),
          SettingRow(
            label: 'タイトルの文字数',
            widget: Container(
              width: 100,
              child: TextFormField(
                keyboardType: TextInputType.number, //数字のキーボードを表示
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], //数字のみ入力可にする
                controller: titleLengthText,
                onTapOutside: (v) async {
                  titleLengthText.text =
                      int.parse(titleLengthText.text).toString();
                  if (int.parse(titleLengthText.text) > 100) {
                    titleLengthText.text = '100';
                  }
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('titleLength', titleLengthText.text);
                  titleLength.value = int.parse(titleLengthText.text);
                },
                onFieldSubmitted: (v) async {
                  titleLengthText.text =
                      int.parse(titleLengthText.text).toString();
                  if (int.parse(titleLengthText.text) > 100) {
                    titleLengthText.text = '100';
                  }
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('titleLength', titleLengthText.text);
                  titleLength.value = int.parse(titleLengthText.text);
                },
              ),
            ),
          ),
          SettingRow(
            label: 'タイトル除外ワード',
            widget: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 15),
                        child: TextFormField(
                          controller: exclusionText,
                          onFieldSubmitted: (v) async {
                            List<String> copy = [...exclusions.value];
                            copy.add(exclusionText.text);
                            exclusions.value = copy;
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setStringList('exclusions', copy);
                            exclusionText.text = '';
                          },
                        )),
                    OutlinedButton(
                        onPressed: () async {
                          if (exclusionText.text.isNotEmpty) {
                            var copy = [...exclusions.value];
                            copy.add(exclusionText.text);
                            exclusions.value = copy;
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setStringList('exclusions', copy);
                            exclusionText.text = '';
                          }
                        },
                        child: const Text('追加'))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: 600,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: exclusions.value
                          .map((e) => Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                        255, 212, 212, 212)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(e),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          var copy = [...exclusions.value];
                                          copy.remove(e);
                                          exclusions.value = copy;
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setStringList(
                                              'exclusions', copy);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 14,
                                        ))
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
          // SettingRow(
          //     label: '商品画像URL',
          //     widget: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: 300,
          //           child: TextFormField(
          //             controller: imageUrl,
          //             style: TextStyle(fontSize: 14),
          //             onTapOutside: (v) async {
          //               final SharedPreferences prefs =
          //                   await SharedPreferences.getInstance();
          //               await prefs.setString('imageUrl', imageUrl.text);
          //             },
          //             onFieldSubmitted: (v) async {
          //               final SharedPreferences prefs =
          //                   await SharedPreferences.getInstance();
          //               await prefs.setString('imageUrl', imageUrl.text);
          //             },
          //           ),
          //         ),
          //         Text('SellerCode'),
          //         DropdownButton(
          //             items: [
          //               {'val': 0, 'text': '.gif'},
          //               {'val': 1, 'text': '.jpg'},
          //               {'val': 2, 'text': '.png'}
          //             ].map((e) {
          //               return DropdownMenuItem(
          //                 value: e['val'] as int,
          //                 child: Padding(
          //                   padding:
          //                       const EdgeInsets.symmetric(horizontal: 8.0),
          //                   child: Text(
          //                     e['text'].toString(),
          //                     style: TextStyle(fontSize: 14),
          //                   ),
          //                 ),
          //               );
          //             }).toList(),
          //             value: imageFormat.value,
          //             onChanged: (v) async {
          //               if (v != null) {
          //                 imageFormat.value = v;
          //                 final SharedPreferences prefs =
          //                     await SharedPreferences.getInstance();
          //                 await prefs.setInt('imageFormat', v);
          //               }
          //             })
          //       ],
          //     )),
          SettingRow(
            label: '表示する項目',
            widget: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                OriginalCheckBox(
                  label: 'タイトル',
                  prefLabel: 'dispTitle',
                  val: dispTitle,
                ),
                OriginalCheckBox(
                  label: 'ブランド名',
                  prefLabel: 'dispBrand',
                  val: dispBrand,
                ),
                OriginalCheckBox(
                  label: '広告文',
                  prefLabel: 'dispPromotion',
                  val: dispPromotion,
                ),
                OriginalCheckBox(
                  label: '画像',
                  prefLabel: 'dispImage',
                  val: dispImage,
                ),
                OriginalCheckBox(
                  label: '価格',
                  prefLabel: 'dispPrice',
                  val: dispPrice,
                ),
              ],
            ),
          ),
          const Divider(),
          SettingRow(
            label: 'サンプル画面幅',
            widget: Container(
              width: 100,
              margin: const EdgeInsets.only(bottom: 15),
              child: TextFormField(
                controller: sampleWidthText,
                keyboardType: TextInputType.number, //数字のキーボードを表示
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], //数字のみ入力可にする),
                onChanged: (v) async {
                  if (int.parse(v) < 1441 && int.parse(v) > 379) {
                    sampleWidth.value = int.parse(v);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('sampleWidth', v);
                  }
                },
              ),
            ),
          ),
          (listOrTile.value == 0)
              ? Column(
                  children: [
                    for (int i = 0; i < 3; i++)
                      WebMockListStyle(
                          dispImage: dispImage,
                          dispTitle: dispTitle,
                          dispBrand: dispBrand,
                          dispPromotion: dispPromotion,
                          dispPrice: dispPrice,
                          accentColor: accentColor,
                          subColor: subColor,
                          titleLength: titleLength,
                          sampleWidth: sampleWidth)
                  ],
                )
              : Row(
                  children: [
                    for (int i = 0; i < rowQty.value; i++)
                      WebMockTileStyle(
                          dispImage: dispImage,
                          dispTitle: dispTitle,
                          dispBrand: dispBrand,
                          dispPromotion: dispPromotion,
                          dispPrice: dispPrice,
                          rowQty: rowQty,
                          accentColor: accentColor,
                          subColor: subColor,
                          titleLength: titleLength,
                          sampleWidth: sampleWidth)
                  ],
                ),
        ],
      ),
    );
  }
}
