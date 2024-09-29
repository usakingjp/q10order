import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../models/api_result_model.dart';
import '../../models/order_model.dart';
import '../../provider.dart';
//https://api.qoo10.jp/GMKT.INC.Front.QAPIService/Document/QAPIGuideIndex.aspx

Future<ApiResultModel> setSendingInfo({
  required OrderModel model,
  required WidgetRef ref,
}) async {
  String sak = ref.watch(sellerAuthKey).value;
  // String sak = ref.watch(sakP);
  if (sak.isNotEmpty) {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ShippingBasic.SetSendingInfo',
        {'q': '{http}'});
    var client = http.Client();
    try {
      if (model.trackingNo.isEmpty) {
        return ApiResultModel(
            packNo: model.packNo, result: false, message: '追跡番号が入力されていません');
      }
      if (model.trackingNo.length < 12) {
        return ApiResultModel(
            packNo: model.packNo, result: false, message: '追跡番号を確かめてください');
      }
      for (var orderNo in model.orderNos) {
        http.Response response = await client.post(endpoint, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'QAPIVersion': '1.0',
          'GiosisCertificationKey': sak
        }, body: {
          "returnType": "application/json",
          "OrderNo": orderNo,
          "ShippingCorp": model.deliveryCompany,
          "TrackingNo": model.trackingNo
        });
        Map<String, dynamic> decodeResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (decodeResponse['ResultCode'] != 0) {
          //error
          return ApiResultModel(
              packNo: model.packNo,
              result: false,
              message:
                  apiErrorMessage(decodeResponse['ResultCode'].toString()));
        }
      }
      return ApiResultModel(packNo: model.packNo);
    } catch (e) {
      print(e.toString());
      return ApiResultModel(
          packNo: model.packNo, result: false, message: e.toString());
    } finally {
      client.close();
    }
  }
  return ApiResultModel(
      packNo: model.packNo, result: false, message: 'sak_error');
}
