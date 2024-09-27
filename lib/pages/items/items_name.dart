import 'package:flutter/material.dart';

import 'parts/csv_upload_button.dart';
import 'parts/item_name_body.dart';

class ItemsName extends StatelessWidget {
  const ItemsName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [CsvUploadButton()],
      ),
      body: Container(
        color: const Color.fromARGB(255, 230, 230, 230),
        child: const Center(
          child: ItemsNameBody(),
        ),
      ),
    );
  }
}
