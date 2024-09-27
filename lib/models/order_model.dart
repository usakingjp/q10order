import 'oreder_item_model.dart';

class OrderModel {
  bool check;
  int statusId; //0:新規,1:発送準備,2:指定日,3:発送完了
  final List<String> orderNos;
  final String packNo;
  final String orderDate;
  final String paymentDate;
  String estimatedShippingDate;
  bool estimatedShippingDateLock;
  String receiverName;
  final String receiverZipcode;
  final String receiverAddress1;
  String receiverAddress2;
  String receiverAddress3;
  final String receiverTel;
  final String receiverMobile;
  final String desiredDeliveryDate; //希望日時
  final String shippingMessage; //配送メッセージ
  final String senderName;
  final String senderTel;
  final String senderNation;
  final String senderZipcode;
  final String senderAddress;
  String coment;
  String deliveryCompany;
  String trackingNo;
  bool trackingNoLock;
  bool invoiceIssue;
  bool isError;
  final List<OrderItemModel> itemModels;
  OrderModel({
    this.check = false,
    this.statusId = 0,
    required this.orderNos,
    required this.packNo,
    required this.orderDate,
    required this.paymentDate,
    required this.receiverName,
    required this.receiverZipcode,
    required this.receiverAddress1,
    required this.receiverAddress2,
    this.receiverAddress3 = '',
    required this.receiverTel,
    required this.receiverMobile,
    required this.desiredDeliveryDate, //希望日時
    required this.shippingMessage, //配送メッセージ
    required this.senderName,
    required this.senderTel,
    required this.senderNation,
    required this.senderZipcode,
    required this.senderAddress,
    required this.deliveryCompany,
    required this.estimatedShippingDate,
    required this.estimatedShippingDateLock,
    required this.trackingNo,
    required this.trackingNoLock,
    this.coment = "",
    this.invoiceIssue = false,
    this.isError = false,
    required this.itemModels,
  });
}
//Gift
//VoucherCode
//PackingNo
//SellerDeliveryNo

List<OrderModel> toOrderModels(List<dynamic> res) {
  List<OrderModel> orderModels = [];
  List<OrderItemModel> itemModels = [];
  for (Map<String, dynamic> order in res) {
    itemModels.add(toOrderItemModel(order));
  }
  for (Map<String, dynamic> order in res) {
    if (order['PaymentDate'].toString().isEmpty) continue;
    int statusId = 0;
    bool estimatedShippingDateLock = false;
    bool trackingNoLock = false;
    List<OrderItemModel> thisItemModels = [];
    for (var item in itemModels) {
      if (order['PackNo'].toString() == item.packNo) {
        thisItemModels.add(item);
      }
    }
    if (order['TrackingNo'].toString().isNotEmpty) {
      trackingNoLock = true;
    }
    if (order['EstimatedShippingDate'].toString().isNotEmpty) {
      estimatedShippingDateLock = true;
      statusId = 1;
      if (DateTime.now().isBefore(
          DateTime.parse(order['EstimatedShippingDate'].toString()))) {
        statusId = 2;
      }
      if (estimatedShippingDateLock && trackingNoLock) {
        statusId = 3;
      }
    }
    orderModels.add(OrderModel(
        statusId: statusId,
        orderNos: order['RelatedOrder'].toString().split(','),
        packNo: order['PackNo'].toString(),
        orderDate: order['OrderDate'],
        paymentDate: order['PaymentDate'],
        receiverName: order['Receiver'],
        receiverZipcode: order['ZipCode'],
        receiverAddress1: order['Address1'],
        receiverAddress2: order['Address2'],
        receiverTel: (order['ReceiverTel'] as String)
            .replaceAll('+81--', '')
            .replaceAll('+81-', ''),
        receiverMobile: (order['ReceiverMobile'] as String)
            .replaceAll('+81--', '')
            .replaceAll('+81-', ''),
        desiredDeliveryDate: order['DesiredDeliveryDate'],
        shippingMessage: order['ShippingMessage'],
        senderName: order['SenderName'],
        senderTel: order['SenderTel'],
        senderNation: order['SenderNation'],
        senderZipcode: order['SenderZipCode'],
        senderAddress: order['SenderAddress'],
        deliveryCompany: order['DeliveryCompany'],
        estimatedShippingDate: order['EstimatedShippingDate'] ?? '',
        estimatedShippingDateLock: estimatedShippingDateLock,
        trackingNo: order['TrackingNo'] ?? '',
        trackingNoLock: trackingNoLock,
        itemModels: thisItemModels));
  }
  orderModels.sort((a, b) =>
      DateTime.parse(b.paymentDate).compareTo(DateTime.parse(a.paymentDate)));
  return orderModels;
}
