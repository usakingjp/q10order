import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/setting/models/config_model.dart';
import 'package:q10order/pages/setting/models/seller_authorization_key_model.dart';

import 'apis/certification_api.dart';
import 'providers/config_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: const Color.fromARGB(255, 230, 230, 230),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity / 2,
                padding: const EdgeInsets.all(20),
                child: const LeftBody(),
              ),
            ),
            // Expanded(
            //   child: Container(
            //     width: double.infinity / 2,
            //     padding: const EdgeInsets.all(20),
            //     child: const LeftBody(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class RightBody extends HookConsumerWidget {
  const RightBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}

class LeftBody extends HookConsumerWidget {
  const LeftBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final sak = useState('');
    // final sak_limit = useState('');
    final sakState = ref.watch(sellerAuthKey);
    final Future<ConfigModel> _readStorage = Future.sync(() async {
      // sak.value = await storage.read(key: 'sak') ?? '';
      // sak_limit.value = await storage.read(key: 'sak_limit') ?? '';
      ref.read(sellerAuthKey.notifier).state =
          await SellerAuthorizationKey().get();
      // ConfigModel config = ConfigModel();
      return ConfigModel().get();
      // return {
      //   'useAgent': await storage.read(key: 'useAgent') ?? '',
      //   'apiKey': await storage.read(key: 'apiKey') ?? '',
      //   'userId': await storage.read(key: 'userId') ?? '',
      //   'userPwd': await storage.read(key: 'userPwd') ?? '',
      // };
    });

    Widget listForm(
        {required String title, required TextEditingController ctrl}) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              child: Text(title),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: ctrl,
              ),
            ),
          ],
        ),
      );
    }

    final useAgent = useTextEditingController(text: '');
    final apiKey = useTextEditingController(text: '');
    final userId = useTextEditingController(text: '');
    final userPwd = useTextEditingController(text: '');
    final sakVal = useState(sakState.value);
    final sakLimit = useState(sakState.limit);
    return FutureBuilder(
      future: _readStorage,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var snap = snapshot.data;
          if (snap != null) {
            // useAgent.text = snap['useAgent'] ?? '';
            // apiKey.text = snap['apiKey'] ?? '';
            // userId.text = snap['userId'] ?? '';
            // userPwd.text = snap['userPwd'] ?? '';
            useAgent.text = snap.useAgent;
            apiKey.text = snap.apiKey;
            userId.text = snap.userId;
            userPwd.text = snap.userPwd;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            listForm(title: 'useAgent', ctrl: useAgent),
            listForm(title: 'apiKey', ctrl: apiKey),
            listForm(title: 'id', ctrl: userId),
            listForm(title: 'pwd', ctrl: userPwd),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    child: const Text('sak'),
                  ),
                  Container(
                    width: 300,
                    child: Text(sakVal.value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    child: const Text('sak_limit'),
                  ),
                  Container(
                    width: 300,
                    child: Text(sakLimit.value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                  onPressed: () async {
                    ConfigModel model = ConfigModel(
                        useAgent: useAgent.text,
                        apiKey: apiKey.text,
                        userId: userId.text,
                        userPwd: userPwd.text);
                    bool writeResult = await model.set();
                    String writeResultText = "保存に失敗しました";
                    if (writeResult) {
                      writeResultText = "保存しました";
                    }
                    // await storage.write(key: 'useAgent', value: useAgent.text);
                    // await storage.write(key: 'apiKey', value: apiKey.text);
                    // await storage.write(key: 'userId', value: userId.text);
                    // await storage.write(key: 'userPwd', value: userPwd.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(writeResultText),
                      ),
                    );
                    SellerAuthorizationKey? sak =
                        await certificationAPI(configModel: model);
                    // sak.value = await storage.read(key: 'sak') ?? '';
                    // sak_limit.value =
                    //     await storage.read(key: 'sak_limit') ?? '';
                    if (sak != null) {
                      ref.read(sellerAuthKey.notifier).state = sak;
                      sakVal.value = sak.value;
                      sakLimit.value = sak.limit;
                      try {
                        sak.set();
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: const Text('保存')),
            ),
          ],
        );
      },
    );
  }
}
