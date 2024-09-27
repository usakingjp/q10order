import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/order_model.dart';
import '../../../workers/pdf.dart';

class PreviewPage extends ConsumerWidget {
  final String fileName;
  final List<OrderModel> updateModels;

  const PreviewPage(
    this.fileName, {
    required this.updateModels,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fileName),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      content: Container(
        width: 600,
        height: 700,
        child: PdfPreview(
          maxPageWidth: 600,
          // enableScrollToPage: true,
          initialPageFormat:
              (fileName == 'Sheets') ? PdfPageFormat.a6 : PdfPageFormat.a4,
          allowPrinting: true,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          loadingWidget: const LinearProgressIndicator(),
          build: (format) async {
            late final pdf;
            if (fileName == 'PickingList') {
              pdf = await PickingPdf.createList(updateModels, ref);
            } else if (fileName == 'Sheets') {
              pdf = await PickingPdf.createSheet(updateModels, ref);
            }

            return await pdf.save();
          },
          onPrinted: (c) {
            Navigator.pop(c);
          },
        ),
      ),
    );
  }
}
