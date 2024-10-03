import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:q10order/pages/setting/models/seller_authorization_key_model.dart';

import '../models/config_model.dart';

Future<SellerAuthorizationKey?> certificationAPI(
    {required ConfigModel configModel}) async {
  if (configModel.apiKey.isNotEmpty &&
      configModel.userId.isNotEmpty &&
      configModel.userPwd.isNotEmpty) {
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
      if (result['ResultCode'] == 0) {
        SellerAuthorizationKey sak =
            SellerAuthorizationKey(value: result['ResultObject']);
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
