class OrderItemModel {
  final String packNo;
  final String itemCode;
  final String q10code;
  final String itemTitle;
  final String itemOption;
  final String itemOptionCode;
  final String orderQty;
  OrderItemModel({
    required this.packNo,
    required this.itemCode,
    required this.q10code,
    required this.itemTitle,
    required this.itemOption,
    required this.itemOptionCode,
    required this.orderQty,
  });
}

OrderItemModel toOrderItemModel(Map<String, dynamic> res) {
  return OrderItemModel(
    packNo: res['PackNo'].toString(),
    itemCode: res['SellerItemCode'],
    q10code: res['ItemNo'],
    itemTitle: res['ItemTitle'],
    itemOption: res['Option'],
    itemOptionCode: res['OptionCode'],
    orderQty: res['OrderQty'].toString(),
  );
}
