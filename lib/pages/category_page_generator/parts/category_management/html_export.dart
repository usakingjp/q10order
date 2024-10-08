import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/category_page_generator/providers/providers.dart';

import '../../../item_management/models/get_item_detail_model.dart';
import '../../models/category_model.dart';

const String htmlHeader = '''
<style>
    #originalArea{max-width:100%;width: 100%; display: flex; gap:1rem calc(100% / 10 / 4); flex-wrap: wrap;}
    .oa_itemBox{display: block;border: 1.5px solid #333;border-radius:5px; width: calc((100% / 5) - (100% / 10 / 5));height:auto;box-sizing: border-box;padding: calc(100% / 10 / 4 / 2);}
    .oa_itemBox img {width: 100%;margin: 0 auto;}
    .oa_itemInfo {margin-top: 0.5rem;display: flex;flex-direction: column;justify-content: space-between;width:100%;}
    .oa_itemName {font-size:12px;display: block;width:100%;}
    .oa_itemPromotion {font-size:10px;color: #bbb;display: block;width:100%;}
    .oa_itemPrice {font-size:16px;font-weight: bold;display: block;text-align: right;}
</style>

<div id="originalArea">
''';
const String htmlFooter = '''</div>''';

String htmlTileHeaderExport(
    {required WidgetRef ref, required CategoryModel model}) {
  final setting = ref.watch(pageSetting);
  final String accentColor =
      Color(setting.accentColor).toHexString().replaceFirst('FF', '');
  final String subColor =
      Color(setting.subColor).toHexString().replaceFirst('FF', '');
  return '''
<style>
    #originalArea{max-width:100%;width: 100%; display: flex; gap:1rem calc(100% / 10 / ${setting.rowQty}); flex-wrap: wrap;}
    #originalArea > img {width: 100%;margin: 1.5rem auto 3rem;}
    .oa_itemBox{display: flex;flex-direction: column;border: 1.5px solid #$subColor;border-radius:5px; width: calc((100% / ${setting.rowQty}) - (100% / 10 / ${setting.rowQty}));height:auto;box-sizing: border-box;padding: calc(100% / 10 / ${setting.rowQty} / 2);}
    .oa_itemBox a {display:block;height:100%;}
    .oa_itemBox img {width: 100%;margin: 0 auto;}
    .oa_itemInfo {margin-top: 0.5rem;display: flex;flex-direction: column;justify-content: space-between;width:100%;flex-grow:1;}
    .oa_itemName {font-size:12px;display: block;width:100%;}
    .oa_itemPromotion {font-size:10px;color: #bbb;display: block;width:100%;}
    .oa_itemPrice {font-size:16px;font-weight: bold;display: block;text-align: right;color:#$accentColor;}
</style>

<div id="originalArea">
${(model.headerImageUrl.isNotEmpty) ? '<img src="${model.headerImageUrl}">' : ''}
''';
}

String htmlExport({required WidgetRef ref, required GetItemDetailModel model}) {
  final setting = ref.watch(pageSetting);
  String title = model.itemTitle;
  for (var element in setting.exclusions) {
    title = title.replaceAll(element, '');
  }
  if (title.length > int.parse(setting.titleLength)) {
    title = title.substring(0, int.parse(setting.titleLength));
  }
  var price = NumberFormat("#,###")
      .format(int.parse(model.itemPrice.replaceFirst('.0000', '')));
  return '''
<div class="oa_itemBox">
    <a href="https://www.qoo10.jp/g/${model.itemCode}">
        ${(setting.dispImage) ? '<img src="https://www.a3-llc.net/pic/item/png/${model.sellerCode}.png">' : ''}
        <div class="oa_itemInfo">
            <div>
                ${(setting.dispTitle) ? '<span class="oa_itemName">$title</span>' : ''}
                ${(setting.dispPromotion) ? '<span class="oa_itemPromotion">${model.promotionName}</span>' : ''}
            </div>
                ${(setting.dispPrice) ? '<span class="oa_itemPrice">￥$price</span>' : ''}
        </div>
    </a>
</div>
''';
}
