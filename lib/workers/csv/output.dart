import 'dart:io';

import 'package:charset_converter/charset_converter.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';

Future<void> outputCsv(List<List<String>> datas, String path) async {
  final res = const ListToCsvConverter().convert(datas);
  final encoded = await CharsetConverter.encode("Shift_JIS", res);
  await File(path).writeAsBytes(encoded);
}

Future<void> outYamato(String path, List<OrderModel> models) async {
  List<List<String>> datas = [
    [
      'ヘッダ行',
    ]
  ];
  for (var model in models) {
    String desiredDeliveryDate = '最短日';
    String desiredShippingTerm = '';
    if (model.desiredDeliveryDate.isNotEmpty) {
      List<String> sp = model.desiredDeliveryDate.split(' ');
      if (sp.isNotEmpty) {
        for (var element in sp) {
          if (element.contains(':')) {
            desiredShippingTerm =
                element.replaceAll('~', '').replaceAll(':00', '');
          } else if (element.contains('-')) {
            desiredDeliveryDate = element.replaceAll('-', '/');
          }
        }
      }
    }
    String receiverAddress =
        '${model.receiverAddress1}${model.receiverAddress2}'
            .replaceAll(RegExp(r'[ 　]'), '');
    datas.add([
      model.packNo, //お客様管理番号/半角50文字
      '0', //送り状種類/0:元払い、2:コレクト、3:DM、7:ネコポス、8:コンパクト、9:コンパクトコレクト
      '0', //クール区分/0:通常、1:クール冷凍、2:クール冷蔵
      '', //伝票番号//空白
      DateFormat('yyyy/MM/dd').format(DateTime.now()), //出荷予定日//2019/01/01
      desiredDeliveryDate, //お届け予定日//2019/01/02
      desiredShippingTerm, //配達時間帯//0821:午前中、1416,1618,1820,1921
      '', //お届け先コード//空白
      (model.receiverMobile.isNotEmpty)
          ? model.receiverMobile
          : model.receiverTel, //お届け先電話番号//変数
      '', //お届け先電話番号枝番//空白
      model.receiverZipcode, //お届け先郵便番号//ハイフン不要
      receiverAddress, //お届け先住所//
      model.receiverAddress3, //お届け先アパートマンション名//全角16文字
      '', //お届け先会社・部門１//全角25文字
      '', //お届け先会社・部門２//全角25文字
      model.receiverName, //お届け先名//全角16文字
      '', //お届け先名(ｶﾅ)//空白
      '様', //敬称//様
      '', //ご依頼主コード//
      (model.senderTel.isNotEmpty) ? model.senderTel : '0669498323', //ご依頼主電話番号
      '', //ご依頼主電話番号枝番//
      (model.senderZipcode.isNotEmpty)
          ? model.senderZipcode
          : '5400011', //ご依頼主郵便番号//
      (model.senderAddress.isNotEmpty)
          ? model.senderAddress
          : '大阪府大阪市中央区農人橋2-1-31-851', //ご依頼主住所//
      '', //ご依頼主アパートマンション//
      (model.senderName.isNotEmpty) ? model.senderName : 'AC配送センター', //ご依頼主名//
      '', //ご依頼主名(ｶﾅ)//
      '', //品名コード１
      '雑貨', //品名１
      '', //品名コード２
      '', //品名２
      'ワレ物注意', //荷扱い１
      '水濡厳禁', //荷扱い２
      (model.coment.isNotEmpty) ? model.coment : '◆指定日時を厳守◆', //記事
      '', //ｺﾚｸﾄ代金引換額（税込)
      '', //内消費税額等
      '0', //止置き//0:しない、1:する
      '', //営業所コード
      '', //発行枚数
      '2', //個数口表示フラグ//1:印字する、2:印字しない、3:枠と口数を印字する
      '0669498323', //*請求先顧客コード
      '', //*請求先分類コード
      '01', //*運賃管理番号
      '0', //クロネコwebコレクトデータ登録//0:なし、1:あり
      '', //クロネコwebコレクト加盟店番号//半角英数字9字、43がありの場合必須
      '', //クロネコwebコレクト申込受付番号１//半角英数字23字、43がありの場合必須
      '', //クロネコwebコレクト申込受付番号２
      '', //クロネコwebコレクト申込受付番号３
      '0', //お届け予定ｅメール利用区分//0:利用しない、1:利用する
      '', //お届け予定ｅメールe-mailアドレス、48ありの場合は必須
      '', //入力機種//1:PC、2:モバイル
      '', //お届け予定ｅメールメッセージ//全角74文字
      '0', //お届け完了ｅメール利用区分//0:利用しない、1:利用する
      '', //お届け完了ｅメールe-mailアドレス
      '', //お届け完了ｅメールメッセージ
      '0', //クロネコ収納代行利用区分//0:利用しない、1:利用する
      '', //予備
      '', //収納代行請求金額(税込)
      '', //収納代行内消費税額等
      '', //収納代行請求先郵便番号
      '', //半角数字＆ハイフン8文字
      '', //収納代行請求先住所
      '', //収納代行請求先住所（アパートマンション名）
      '', //収納代行請求先会社・部門名１
      '', //収納代行請求先会社・部門名２
      '', //収納代行請求先名(漢字)
      '', //収納代行請求先名(カナ)
      '', //収納代行問合せ先名(漢字)
      '', //収納代行問合せ先郵便番号
      '', //収納代行問合せ先住所
      '', //収納代行問合せ先住所（アパートマンション名）
      '', //収納代行問合せ先電話番号
      '', //収納代行管理番号
      '', //収納代行品名
      '', //収納代行備考
      '', //複数口くくりキー
      '', //検索キータイトル1
      '', //検索キー1
      '', //検索キータイトル2
      '', //検索キー2
      '', //検索キータイトル3
      '', //検索キー3
      '', //検索キータイトル4
      '', //検索キー4
      '', //検索キータイトル5
      '', //検索キー5
      '', //予備
      '', //予備
      '0', //投函予定メール利用区分//0:利用しない、1:利用する
      '', //投函予定メールe-mailアドレス
      '', //投函予定メールメッセージ
      '0', //投函完了メール（お届け先宛）利用区分//0:利用しない、1:利用する
      '', //投函完了メール（お届け先宛）e-mailアドレス
      '', //投函完了メール（お届け先宛）メールメッセージ
      '', //投函完了メール（ご依頼主宛）利用区分//0:利用しない、1:利用する
      '', //投函完了メール（ご依頼主宛）e-mailアドレス
      '', //投函完了メール（ご依頼主宛）メールメッセージ
    ]);
  }
  try {
    await outputCsv(datas, path);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> outSagawa(String path, List<OrderModel> models) async {
  List<List<String>> datas = [];
  for (var model in models) {
    String desiredDeliveryDate = '';
    String desiredShippingTerm = '';
    if (model.desiredDeliveryDate.isNotEmpty) {
      List<String> sp = model.desiredDeliveryDate.split(' ');
      if (sp.isNotEmpty) {
        for (var element in sp) {
          if (element.contains(':')) {
            desiredShippingTerm =
                element.replaceAll('~', '').replaceAll(':00', '');
            switch (desiredShippingTerm) {
              case '0812':
                desiredShippingTerm = '01';
                break;
              case '1214':
                desiredShippingTerm = '12';
                break;
              case '1416':
                desiredShippingTerm = '14';
                break;
              case '1618':
                desiredShippingTerm = '16';
                break;
              case '1821':
                desiredShippingTerm = '04';
                break;
              case '1820':
                desiredShippingTerm = '18';
                break;
              case '1921':
                desiredShippingTerm = '19';
                break;
              default:
                desiredShippingTerm = '';
                break;
            }
          } else if (element.contains('-')) {
            desiredDeliveryDate = element.replaceAll('-', '');
          }
        }
      }
    }
    datas.add([
      '0', //住所録コード
      (model.receiverMobile.isNotEmpty)
          ? model.receiverMobile
          : model.receiverTel, //お届け先電話番号
      model.receiverZipcode, //お届け先郵便番号
      model.receiverAddress1.replaceAll(RegExp(r'[ 　]'), ''), //お届け先住所１*
      model.receiverAddress2.replaceAll(RegExp(r'[ 　]'), ''), //お届け先住所２
      model.receiverAddress3, //お届け先住所３
      model.receiverName, //お届け先名称１*
      '', //お届け先名称２
      model.packNo, //お客様管理番号//半角16
      '136766450021', //お客様コード//半角12
      '', //部署・担当者
      '', //荷送人電話番号
      '', //ご依頼主電話番号
      '', //ご依頼主郵便番号
      '', //ご依頼主住所１
      '', //ご依頼主住所２
      '', //ご依頼主名称１
      '', //ご依頼主名称２
      '001', //荷姿コード//001箱類、004封筒類
      '雑貨', //品名１//全角16、半角32
      (model.coment.isNotEmpty)
          ? model.coment
          : (desiredDeliveryDate.isNotEmpty || desiredShippingTerm.isNotEmpty)
              ? '◆指定日時を厳守◆'
              : '', //品名２
      '', //品名３
      '', //品名4
      '', //品名5
      '1', //出荷個数
      '000', //便種//000宅配便
      '001', //便種//001指定なし、002クール冷蔵、003クール冷凍
      desiredDeliveryDate, //配達日//数字のみ8桁
      desiredShippingTerm, //配達指定時間帯//01、12、14、16、04、18、19
      '', //配達指定時間
      '', //代引き金額
      '', //消費税
      '2', //決済種別//0指定なし、1全て可、2現金のみ、3クレジットカード
      '', //保険金額
      '', //保険金額印字//0しない
      '011', //指定シール１//001クール冷蔵、002クール冷凍、004営業所受取、005指定日配達、007時間帯指定(5時間帯)、008eコレクト現金、009、eコレクトカード、0010eコレクトなんでも、011取扱注意、012貴重品、013天地無用、019時間帯指定(6時間帯)
      (desiredShippingTerm.isNotEmpty) ? '005' : '', //指定シール２
      '', //指定シール３
      '', //営業所止め//0通常出荷、1営業所受取
      '', //SRC区分//0指定なし、1SRC
      '', //営業所コード
      '1', //元着区分//1元払い、2着払
    ]);
  }
  try {
    await outputCsv(datas, path);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> outPacket(String path, List<OrderModel> models) async {
  List<List<String>> datas = [];
  for (var model in models) {
    datas.add([
      '0',
      model.receiverName, //お届け先名//全角16文字
      model.receiverZipcode, //お届け先郵便番号//ハイフン不要
      model.receiverAddress1, //お届け先住所//
      model.receiverAddress2, //お届け先住所//
      model.receiverAddress3, //お届け先住所//
      model.packNo, //お客様管理番号/半角50文字
    ]);
  }
  try {
    await outputCsv(datas, path);
  } catch (e) {
    print(e.toString());
  }
}
