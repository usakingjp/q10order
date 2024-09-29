import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:q10order/pages/setting/providers/config_provider.dart';

import '../../provider.dart';
//https://api.qoo10.jp/GMKT.INC.Front.QAPIService/Document/QAPIGuideIndex.aspx

Future<Map<String, dynamic>> getShippingInfoV3({
  String shippingStatus = '0',
  String searchStartDate = '',
  String searchEndDate = '',
  String searchCondition = '1',
  required WidgetRef ref,
}) async {
  // String sak = ref.watch(sakP);
  String sak = ref.watch(sellerAuthKey).value;

  var now = DateTime.now();
  if (sak.isNotEmpty) {
    if (searchStartDate.isEmpty) {
      searchStartDate =
          DateFormat('yyyyMMdd').format(now.add(const Duration(days: -30)));
    }
    if (searchEndDate.isEmpty) {
      searchEndDate = DateFormat('yyyyMMdd').format(now);
    }
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/ShippingBasic.GetShippingInfo_v3',
        {'q': '{http}'});
    var client = http.Client();
    try {
      var response = await client.post(endpoint, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'QAPIVersion': '1.0',
        'GiosisCertificationKey': sak
      }, body: {
        "returnType": "application/json",
        "ShippingStatus": shippingStatus,
        "SearchStartDate": searchStartDate,
        "SearchEndDate": searchEndDate,
        "SearchCondition": searchCondition
      });
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print(e.toString());
      return {'error': 'connect_error'};
    } finally {
      client.close();
    }
  }
  return {'error': 'sak_error'};
}
