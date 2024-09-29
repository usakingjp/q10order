import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:q10order/pages/setting/models/seller_authorization_key_model.dart';

import '../../pages/setting/models/config_model.dart';
// https://api.qoo10.jp/GMKT.INC.Front.QAPIService/Document/QAPIGuideIndex.aspx

Future<void> sample() async {
  final Uri endpoint =
      Uri.https('www.a3-llc.net', '/sample.html', {'num': '514'});
  var client = http.Client();
  var response = await client.get(endpoint);
  var result = convert.jsonDecode(response.body) as Map;
  debugPrint(result.toString());
}

Future<SellerAuthorizationKey?> certificationAPI({required ConfigModel configModel}) async {
  // const storage = FlutterSecureStorage();
  // String apiKey = await storage.read(key: 'apiKey') ?? '';
  // String userId = await storage.read(key: 'userId') ?? '';
  // String userPwd = await storage.read(key: 'userPwd') ?? '';
  if (configModel.apiKey.isNotEmpty && configModel.userId.isNotEmpty && configModel.userPwd.isNotEmpty) {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/CertificationAPI.CreateCertificationKey',
        {'q': '{http}'});
    var client = http.Client();
    try {
      var response = await client.post(endpoint, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'QAPIVersion': '1.0',
        'GiosisCertificationKey': configModel.apiKey
      }, body: {
        "returnType": "application/json",
        "user_id": configModel.userId,
        "pwd": configModel.userPwd
      });
      var result = convert.jsonDecode(response.body) as Map;
        print(result);
      if (result['ResultCode']==0) {
          SellerAuthorizationKey sak = SellerAuthorizationKey(value: result['ResultObject']);
          // final setResult = await sak.set();
          // var now = DateTime.now();
          // await storage.write(key: 'sak', value: result['ResultObject']);
          // await storage.write(
          //     key: 'sak_limit',
          //     value: DateFormat('yyyy/MM/dd')
          //         .format(DateTime(now.year + 1, now.month, now.day)));
          return sak;
        }
    } catch (e) {
      print(e);
      return null;
    } finally {
      client.close();
    }
  }
  return null;
}
