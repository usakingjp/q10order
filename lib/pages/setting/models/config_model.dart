import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfigModel{
  final String useAgent;
  final String apiKey;
  final String userId;
  final String userPwd;
  ConfigModel({this.useAgent='',this.apiKey='',this.userId='',this.userPwd='',});
  Future<ConfigModel> get()async{
    const storage = FlutterSecureStorage();
    return ConfigModel(
      useAgent: await storage.read(key: 'useAgent') ?? '',
      apiKey: await storage.read(key: 'apiKey') ?? '',
      userId: await storage.read(key: 'userId') ?? '',
      userPwd: await storage.read(key: 'userPwd') ?? '',
    );
  }
  Future<bool> set()async{
    const storage = FlutterSecureStorage();
    try {
      await storage.write(key: 'useAgent', value: useAgent);
      await storage.write(key: 'apiKey', value: apiKey);
      await storage.write(key: 'userId', value: userId);
      await storage.write(key: 'userPwd', value: userPwd);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}