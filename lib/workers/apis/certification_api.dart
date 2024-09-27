import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// https://api.qoo10.jp/GMKT.INC.Front.QAPIService/Document/QAPIGuideIndex.aspx

Future<void> sample() async {
  final Uri endpoint =
      Uri.https('www.a3-llc.net', '/sample.html', {'num': '514'});
  var client = http.Client();
  var response = await client.get(endpoint);
  var result = convert.jsonDecode(response.body) as Map;
  debugPrint(result.toString());
}

Future<String> certificationAPI() async {
  const storage = FlutterSecureStorage();
  String apiKey = await storage.read(key: 'apiKey') ?? '';
  String userId = await storage.read(key: 'userId') ?? '';
  String userPwd = await storage.read(key: 'userPwd') ?? '';
  if (apiKey.isNotEmpty && userId.isNotEmpty && userPwd.isNotEmpty) {
    final Uri endpoint = Uri.https(
        'api.qoo10.jp',
        '/GMKT.INC.Front.QAPIService/ebayjapan.qapi/CertificationAPI.CreateCertificationKey',
        {'q': '{http}'});
    var client = http.Client();
    try {
      var response = await client.post(endpoint, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'QAPIVersion': '1.0',
        'GiosisCertificationKey': apiKey
      }, body: {
        "returnType": "application/json",
        "user_id": userId,
        "pwd": userPwd
      });
      var result = convert.jsonDecode(response.body) as Map;
      if (result.containsKey('ResultObject')) {
        if (result['ResultObject'] != null) {
          var now = DateTime.now();
          await storage.write(key: 'sak', value: result['ResultObject']);
          await storage.write(
              key: 'sak_limit',
              value: DateFormat('yyyy/MM/dd')
                  .format(DateTime(now.year + 1, now.month, now.day)));
          return result['ResultObject'];
        }
      } else if (result.containsKey('ErrorCode')) {}
      return 'error';
    } catch (e) {
      return 'error';
    } finally {
      client.close();
    }
  }
  return 'non-data';
}
