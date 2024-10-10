import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q10order/pages/category_page_generator/providers/providers.dart';

import '../../../../consts/brand_list.dart';
import '../../../item_management/models/get_item_detail_model.dart';
import '../../models/category_model.dart';
import '../../models/page_setting_model.dart';

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
    {required PageSettingModel setting, required CategoryModel model}) {
  final String accentColor =
      Color(setting.accentColor).toHexString().replaceFirst('FF', '');
  final String subColor =
      Color(setting.subColor).toHexString().replaceFirst('FF', '');
  return '''
<style>
    #originalArea{max-width:100%;width: 100%; display: flex; gap:1rem calc(100% / 10 / ${setting.rowQty}); flex-wrap: wrap;margin-bottom:5rem}
    #originalArea > img {width: 100%;}
    .oa_itemBox{display: flex;flex-direction: column;border: 1.5px solid #$subColor;border-radius:5px; width: calc((100% / ${setting.rowQty}) - (100% / 10 / ${setting.rowQty}));height:auto;box-sizing: border-box;padding: calc(100% / 10 / ${setting.rowQty} / 2);}
    .oa_itemBox a {text-decoration: none;}
    .oa_itemBox img {width: 100%;margin: 0 auto;}
    .oa_itemInfo {margin-top: 0.5rem;display: flex;flex-direction: column;justify-content: space-between;width:100%;flex-grow:1;letter-spacing: 1px;text-align:left}
    .oa_itemName {font-size:12px;display: block;width:100%;}
    .oa_itemPromotion {font-size:10px;color: #bbb;display: block;width:100%;}
    .oa_itemPrice {padding-top:1rem;font-size:16px;font-weight: bold;display: block;text-align: right;color:#$accentColor;}
</style>

<div id="originalArea">
${(model.headerImageUrl.isNotEmpty) ? '<img src="${model.headerImageUrl}">' : ''}
''';
}

String htmlExport(
    {required PageSettingModel setting, required GetItemDetailModel model}) {
  String title = model.itemTitle;
  for (var element in setting.exclusions) {
    title = title.replaceAll(element, '');
  }
  if (setting.dispBrand) {
    String? brandName;
    if (model.brandNo.isNotEmpty) {
      var b = brandList
          .where((brandModel) => brandModel.code == model.brandNo)
          .toList();
      if (b.isNotEmpty) {
        brandName = b[0].name;
      }
    }
    if (brandName != null) {
      title = '$brandName $title';
    }
  }
  if (title.length > int.parse(setting.titleLength)) {
    title = title.substring(0, int.parse(setting.titleLength));
  }
  var price = NumberFormat("#,###")
      .format(int.parse(model.itemPrice.replaceFirst('.0000', '')));

  String itemImageUrl = model.imageUrl;
  // if (setting.imageUrl.isNotEmpty) {
  //   String imageFormat = '.gif';
  //   switch (setting.imageFormat) {
  //     case 1:
  //       imageFormat = '.jpg';
  //       break;
  //     case 2:
  //       imageFormat = '.png';
  //       break;
  //     default:
  //       break;
  //   }
  //   itemImageUrl = setting.imageUrl + model.sellerCode + imageFormat;
  // }
  return '''
<div class="oa_itemBox">
    <a href="https://www.qoo10.jp/g/${model.itemCode}">
      ${(setting.dispImage) ? '<img src="$itemImageUrl">' : ''}
    </a>
    <div class="oa_itemInfo">
        <div>
          <a href="https://www.qoo10.jp/g/${model.itemCode}">
              ${(setting.dispTitle) ? '<span class="oa_itemName">$title</span>' : ''}
              ${(setting.dispPromotion) ? '<span class="oa_itemPromotion">${model.promotionName}</span>' : ''}
          </a>
        </div>
            ${(setting.dispPrice) ? '<span class="oa_itemPrice">￥$price</span>' : ''}
    </div>
</div>
''';
}
