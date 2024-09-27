import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../models/order_model.dart';

class AddressEdit extends StatelessWidget {
  final List<OrderModel> updateModels;
  const AddressEdit({super.key, required this.updateModels});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'お届け先住所・氏名の修正',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_rounded))
        ],
      ),
      content: Container(
        width: 500,
        height: 500,
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            TextEditingController con1 = TextEditingController(
                text: updateModels[index].receiverAddress2);
            TextEditingController con2 = TextEditingController(
                text: updateModels[index].receiverAddress3);
            TextEditingController con3 =
                TextEditingController(text: updateModels[index].receiverName);
            return Container(
              width: 480,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              color: (index % 2 != 0)
                  ? const Color.fromARGB(255, 247, 247, 247)
                  : Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: con3,
                    decoration: const InputDecoration(
                        labelText: "お届け先名称",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 156, 156, 156),
                            fontSize: 13),
                        floatingLabelStyle:
                            TextStyle(color: Colors.white, fontSize: 10),
                        contentPadding: EdgeInsets.all(10)),
                    onChanged: (v) {
                      // con3.text = v;
                      updateModels[index].receiverName = v;
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        // width: double.infinity / 2.5,
                        width: 180,
                        child: TextField(
                          controller: con1,
                          decoration: const InputDecoration(
                              labelText: "お届け先２",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 156, 156, 156),
                                  fontSize: 13),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              contentPadding: EdgeInsets.all(10)),
                          onChanged: (v) {
                            con1.text = v;
                            updateModels[index].receiverAddress2 = v;
                          },
                        ),
                      ),
                      Container(
                        width: 180,
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: con2,
                          decoration: const InputDecoration(
                              labelText: "お届け先３",
                              hintText: "建物名",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 156, 156, 156),
                                  fontSize: 13),
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 156, 156, 156),
                                  fontSize: 13),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.white, fontSize: 10),
                              contentPadding: EdgeInsets.all(10)),
                          onChanged: (v) {
                            con2.text = v;
                            updateModels[index].receiverAddress3 = v;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          itemCount: updateModels.length,
        ),
      ),
      actions: [
        FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'))
      ],
    );
  }
}
