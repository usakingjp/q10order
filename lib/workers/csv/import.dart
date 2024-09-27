import 'dart:io';
import 'package:charset_converter/charset_converter.dart';

import 'package:csv/csv.dart';

Future<List<List<dynamic>>> importCsv(String path, String charset) async {
  final input = File(path);
  final utf8Data =
      await CharsetConverter.decode(charset, input.readAsBytesSync());
  return const CsvToListConverter(shouldParseNumbers: false).convert(utf8Data);
}

Future<Map<String, String>> importYamato(String path) async {
  try {
    final csv2list = await importCsv(path, 'Shift_JIS');
    Map<String, String> result = {};
    for (var e in csv2list) {
      if (e[0].toString().isEmpty) continue;
      result[e[0].toString()] = e[3].toString();
    }
    return result;
  } catch (e) {
    print(e.toString());
    return {'error': e.toString()};
  }
}

Future<Map<String, String>> importSagawa(String path) async {
  try {
    final csv2list = await importCsv(path, 'utf-8');
    Map<String, String> result = {};
    for (var e in csv2list) {
      if (e.length > 83) {
        if (e[0].toString().isEmpty) continue;
        if (e[19].toString().isEmpty) continue;
        if (e[84] == '0') {
          result[e[19].toString()] = e[0].toString();
        }
      } else {
        print(e.toString());
      }
    }
    return result;
  } catch (e) {
    print(e.toString());
    return {'error': e.toString()};
  }
}

Future<Map<String, String>> importPacket(String path) async {
  try {
    final csv2list = await importCsv(path, 'Shift_JIS');
    Map<String, String> result = {};
    for (var e in csv2list) {
      if (e[0].toString().isEmpty || e[9].toString().isEmpty) continue;
      result[e[9].toString()] = e[0].toString();
    }
    return result;
  } catch (e) {
    print(e.toString());
    return {'error': e.toString()};
  }
}
