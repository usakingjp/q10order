import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../models/api_result_model.dart';
import '../../models/order_model.dart';
//https://api.qoo10.jp/GMKT.INC.Front.QAPIService/Document/QAPIGuideIndex.aspx

Future<ApiResultModel> setSellerChackYnV2({
  required OrderModel model,
  required WidgetRef ref,
}) async {
  // String sak = ref.watch(sakP);
  String sak = ref.watch(sellerAuthKey).value;
  if (sak.isNotEmpty) {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ShippingBasic.SetSellerCheckYN_V2',
        {'q': '{http}'});
    var client = http.Client();
    try {
      if (model.estimatedShippingDate.isEmpty) {
        return ApiResultModel(
            packNo: model.packNo, result: false, message: 'お届け予定日が入力されていません');
      }
      for (var orderNo in model.orderNos) {
        http.Response response = await client.post(endpoint, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'QAPIVersion': '1.0',
          'GiosisCertificationKey': sak
        }, body: {
          "returnType": "application/json",
          "OrderNo": orderNo,
          "EstShipDt": model.estimatedShippingDate
        });
        Map<String, dynamic> decodeResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(decodeResponse.toString());
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
      packNo: model.packNo, result: false, message: 'sak error');
}
