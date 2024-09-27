import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:q10order/pages/item_management/models/update_goods_model.dart';

import '../models/get_all_goods_info_model.dart';

enum ItemStatus {
  waiting,
  discontinuedSeller,
  discontinuedQ10,
  onSale,
  restrictions,
  denied;

  String get text {
    switch (this) {
      case waiting:
        return '承認待ち';
      case discontinuedSeller:
        return '販売中止(販売者)';
      case discontinuedQ10:
        return '販売中止(Qoo10)';
      case onSale:
        return '販売中';
      case restrictions:
        return '販売制限(Qoo10)';
      case denied:
        return '承認拒否';
      default:
        return 'unnown';
    }
  }

  String get val {
    switch (this) {
      case waiting:
        return 'S0';
      case discontinuedSeller:
        return 'S1';
      case discontinuedQ10:
        return 'S3';
      case onSale:
        return 'S2';
      case restrictions:
        return 'S5';
      case denied:
        return 'S8';
      default:
        return 'e';
    }
  }
}

class Q10Apis {
  final String sellerAuthorizationKey;
  Q10Apis({required this.sellerAuthorizationKey});
  Future<Map<String, dynamic>> getAllGoodsInfo(
      {ItemStatus? itemStatus, String? page}) async {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ItemsLookup.GetAllGoodsInfo',
        {'q': '{http}'});
    var client = http.Client();
    int pageIndex = 1;
    var body = {
      "returnType": "application/json",
      "ItemStatus": ItemStatus.onSale.val,
    };
    if (itemStatus != null) {
      body["ItemStatus"] = itemStatus.val;
    }
    if (page != null && page.isNotEmpty) {
      body["Page"] = page;
    }
    Map<String, dynamic> result = {
      "Items": <GetAllGoodsInfoModel>[],
      "ResultCode": 0,
      "ResultMsg": "SUCCESS"
    };
    try {
      do {
        var response = await client.post(
          endpoint,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'QAPIVersion': '1.0',
            'GiosisCertificationKey': sellerAuthorizationKey
          },
          body: body,
        );
        Map<String, dynamic> respons = convert.jsonDecode(response.body);
        if (respons["ResultCode"] == 0) {
          // respons["ResultObject"]["Items"] as List<Map<String, dynamic>>;
          result["Items"].addAll([
            for (var e in respons["ResultObject"]["Items"])
              GetAllGoodsInfoModel.fromMap(e as Map<String, dynamic>)
          ]);
          if (page != null && page.isNotEmpty) {
            break;
          }
          if (int.parse(respons["ResultObject"]["TotalPages"].toString()) >
              int.parse(respons["ResultObject"]["PresentPage"].toString())) {
            body["Page"] = (pageIndex + 1).toString();
          } else {
            break;
          }
        } else {
          result["ResultCode"] = respons["ResultCode"];
          result["ResultMsg"] = respons["ResultMsg"];
          break;
        }
      } while (true);
      return result;
    } catch (e) {
      print(e.toString());
      result["ResultCode"] = 99;
      result["ResultMsg"] = e.toString();
      return result;
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> getItemDetaiInfo(
      {String? itemCode, String? sellerCode}) async {
    if (itemCode == null && sellerCode == null) {
      return {'error': 'argument error'};
    }
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ItemsLookup.GetItemDetailInfo',
        {'q': '{http}'});
    var client = http.Client();
    var body = {
      "returnType": "application/json",
    };
    if (itemCode != null && itemCode.isNotEmpty) {
      body.addAll({"ItemCode": itemCode});
    } else if (sellerCode != null && sellerCode.isNotEmpty) {
      body.addAll({"SellerCode": sellerCode});
    }
    try {
      var response = await client.post(
        endpoint,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'QAPIVersion': '1.2',
          'GiosisCertificationKey': sellerAuthorizationKey
        },
        body: body,
      );
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      if (result["ResultCode"] == 0) {
        return result["ResultObject"][0] as Map<String, dynamic>;
      } else {
        return {'error': '${result["ResultCode"]} : ${result["ResultMsg"]}'};
      }
    } catch (e) {
      print(e.toString());
      return {'error': 'connect_error'};
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> updateGoods(Map<String, dynamic> map) async {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ItemsBasic.UpdateGoods',
        {'q': '{http}'});
    var client = http.Client();
    try {
      var response = await client.post(
        endpoint,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'QAPIVersion': '1.1',
          'GiosisCertificationKey': sellerAuthorizationKey
        },
        body: map,
      );
      Map<String, dynamic> result = convert.jsonDecode(response.body);
      return {
        'ResultCode': result["ResultCode"],
        'ResultMsg': result["ResultMsg"]
      };
    } catch (e) {
      print(e.toString());
      return {'ResultCode': 99, 'ResultMsg': 'connect_error'};
    } finally {
      client.close();
    }
  }
}
