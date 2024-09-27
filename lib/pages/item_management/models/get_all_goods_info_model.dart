class GetAllGoodsInfoModel {
  final String itemCode;
  final String sellerCode;
  final String itemStatus;
  GetAllGoodsInfoModel({
    required this.itemCode,
    required this.sellerCode,
    required this.itemStatus,
  });
  factory GetAllGoodsInfoModel.fromMap(Map<String, dynamic> map) {
    return GetAllGoodsInfoModel(
      itemCode: map["ItemCode"].toString(),
      sellerCode: map["SellerCode"].toString(),
      itemStatus: map["ItemStatus"].toString(),
    );
  }
}
