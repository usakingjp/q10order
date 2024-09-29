import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SellerAuthorizationKey {
  final String value;
  String limit;
  SellerAuthorizationKey({this.value='',this.limit=''}){
    if(value.isNotEmpty&&limit.isEmpty){
      final now = DateTime.now();
      limit=DateFormat('yyyy/MM/dd').format(DateTime(now.year + 1, now.month, now.day));
    }
  }
  Future<SellerAuthorizationKey> get()async{
    const storage = FlutterSecureStorage();
    return SellerAuthorizationKey(
      // value: await storage.read(key: 'sakValue') ?? '',
      value:'S5bnbfynQvM5pElyWVv6oNjiUzBwKv8qwfPiFcvaSCdghfEM1_g_1_dBaheHwddDMPPSu_g_2_yHnU8C_g_1_rmXTzbitK8BHNABVymU1eaogubGYIzsFCGAIqJxlooccO9E57H8PhVi',
      limit: await storage.read(key: 'sakLimit') ?? '',
    );
  }
  Future<bool> set()async{
    const storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'sakValue', value: value);
      await storage.write(key: 'sakLimit', value: limit);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}