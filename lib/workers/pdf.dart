import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart' as pd;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:collection/collection.dart';
import 'package:q10order/provider.dart';

import '../models/order_model.dart';
import '../models/oreder_item_model.dart';

class PickingPdf {
  final List<OrderModel> updateModels;
  const PickingPdf({required this.updateModels});

  static Future<Document> createList(
      List<OrderModel> updateModels, WidgetRef ref) async {
    List<OrderItemModel> items = [];
    for (var element in updateModels) {
      items.addAll(element.itemModels);
    }
    items.sort((a, b) => a.itemCode.compareTo(b.itemCode));
    List<OrderItemModel> enditem = [];
    List<Map<String, String>> newItems = [];
    for (var element in items) {
      int check = enditem
          .where((e) =>
              e.itemCode == element.itemCode &&
              e.itemOptionCode == element.itemOptionCode)
          .length;
      if (check > 0) continue;
      var sel = items.where((e) =>
          e.itemCode == element.itemCode &&
          e.itemOptionCode == element.itemOptionCode);
      if (sel.isNotEmpty) {
        String qty = sel.first.orderQty;
        if (sel.length > 1) {
          int c = 0;
          for (var element in sel) {
            c += int.tryParse(element.orderQty) ?? 0;
          }
          qty = c.toString();
        }
        enditem.add(element);
        // String itemName = element.itemTitle;
        // var itemNames = itemNameList.where((e) => e.num == element.itemCode);
        // if (itemNames.isNotEmpty) {
        //   itemName = itemNames.first.name;
        // }
        String itemName = element.itemTitle;
        var itemnames = ref
            .watch(itemNames)
            .where((name) => name.q10cord == element.q10code);
        if (itemnames.isNotEmpty) {
          itemName = itemnames.first.displayName;
        }
        newItems.add({
          "cord": element.itemCode,
          "optionCord": element.itemOptionCode,
          "name": itemName,
          "qty": qty
        });
      }
    }
    final Font font = await PdfGoogleFonts.zenKakuGothicAntiqueLight();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: font),
    );
    void addPageFunc(List<Map<String, String>> funcitems) {
      pdf.addPage(pw.Page(
          pageFormat: pd.PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 18),
                    child: pw.Text(
                      'Qoo10 ピッキングリスト',
                      style: pw.TextStyle(fontSize: 22),
                    ),
                  ),
                  pw.ListView.builder(
                    itemBuilder: (context, index) {
                      Map<String, String> tar = funcitems[index];
                      return pw.Container(
                        color: (index % 2 == 0)
                            ? pd.PdfColors.grey100
                            : pd.PdfColors.white,
                        padding: pw.EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 80,
                              child: pw.Text(tar['cord']!),
                            ),
                            pw.Container(
                              width: 80,
                              child: pw.Text(tar['optionCord']!),
                            ),
                            pw.Container(
                              width: 250,
                              child: pw.Text(tar['name']!,
                                  maxLines: 1,
                                  overflow: pw.TextOverflow.visible),
                            ),
                            pw.Container(
                              width: 80,
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(tar['qty']!),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: funcitems.length,
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 18),
                    child: pw.Text(
                      '${DateTime.now()}',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ); // Center
          }));
    }

    if (newItems.length > 17) {
      final sliced = newItems.slices(17);
      for (List<Map<String, String>> element in sliced) {
        addPageFunc(element);
      }
    } else {
      addPageFunc(newItems);
    }
    return pdf;
  }

  static Future<Document> createSheet(
      List<OrderModel> updateModels, WidgetRef ref) async {
    final Font font = await PdfGoogleFonts.zenKakuGothicAntiqueRegular();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: font),
    );
    void addPageFunc(
      OrderModel model,
      List<OrderItemModel> items,
    ) {
      pdf.addPage(pw.Page(
          pageFormat: pd.PdfPageFormat.a6,
          margin: pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${model.receiverName} 様',
                          style: pw.TextStyle(fontSize: 10)),
                      (model.shippingMessage.isNotEmpty)
                          ? pw.Text('備考あり')
                          : pw.Container(),
                    ],
                  ),
                  pw.Divider(height: 30),
                  pw.ListView.builder(
                    itemBuilder: (context, index) {
                      OrderItemModel now = items[index];
                      String itemName = now.itemTitle;
                      var names = ref
                          .watch(itemNames)
                          .where((e) => e.q10cord == now.q10code);
                      if (names.isNotEmpty) {
                        itemName = names.first.displayName;
                      }
                      return pw.Padding(
                        padding: pw.EdgeInsets.only(bottom: 8),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Container(
                              width: 180,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(now.itemCode,
                                      style: pw.TextStyle(fontSize: 8)),
                                  pw.Text(itemName,
                                      maxLines: 1,
                                      overflow: pw.TextOverflow.visible,
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.Text(now.itemOption,
                                      style: pw.TextStyle(fontSize: 8)),
                                ],
                              ),
                            ),
                            pw.Container(
                                // color: pd.PdfColors.amber,
                                width: 25,
                                height: 25,
                                alignment: pw.Alignment.center,
                                decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        color: pd.PdfColors.grey)),
                                child: pw.Text(now.orderQty)),
                          ],
                        ),
                      );
                    },
                    itemCount: items.length,
                  ),
                  pw.Divider(height: 30),
                  pw.Text(model.deliveryCompany,
                      style: pw.TextStyle(fontSize: 10)),
                  pw.Text(model.desiredDeliveryDate,
                      style: pw.TextStyle(fontSize: 10)),
                ],
              ),
            ); // Center
          }));
    }

    for (var model in updateModels) {
      var items = model.itemModels;
      // items.sort((a, b) => a.itemCode.compareTo(b.itemCode));
      if (items.length > 6) {
        final sliced = items.slices(6);
        for (List<OrderItemModel> element in sliced) {
          addPageFunc(model, element);
        }
      } else {
        addPageFunc(model, items);
      }
    }
    return pdf;
  }
}
