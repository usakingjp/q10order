class UpdateGoodsModel {
  String itemCode;
  String secondSubCat;
  String drugtype;
  String itemTitle;
  String promotionName;
  String sellerCode;
  String industrialCodeType;
  String industrialCode;
  String brandNo;
  String manufactureDate;
  String modelNm;
  String material;
  String productionPlaceType;
  String productionPlace;
  String retailPrice;
  String adultYN;
  String contactInfo;
  String shippingNo;
  String optionShippingNo1;
  String optionShippingNo2;
  String? weight;
  String desiredShippingDate;
  String availableDateType;
  String availableDateValue;
  String keyword;
  UpdateGoodsModel({
    required this.itemCode,
    required this.secondSubCat,
    required this.drugtype,
    required this.itemTitle,
    required this.promotionName,
    required this.sellerCode,
    required this.industrialCodeType,
    required this.industrialCode,
    required this.brandNo,
    required this.manufactureDate,
    required this.modelNm,
    required this.material,
    required this.productionPlaceType,
    required this.productionPlace,
    required this.retailPrice,
    required this.adultYN,
    required this.contactInfo,
    required this.shippingNo,
    required this.optionShippingNo1,
    required this.optionShippingNo2,
    this.weight,
    required this.desiredShippingDate,
    required this.availableDateType,
    required this.availableDateValue,
    required this.keyword,
  });

  Map<String, String> toMap() {
    Map<String, String> result = {
      "returnType": "application/json",
      "ItemCode": itemCode,
      "SecondSubCat": secondSubCat,
      "Drugtype": drugtype,
      "ItemTitle": itemTitle,
      "PromotionName": promotionName,
      "SellerCode": sellerCode,
      "IndustrialCodeType": industrialCodeType,
      "IndustrialCode": industrialCode,
      "BrandNo": brandNo,
      "ModelNm": modelNm,
      "Material": material,
      "ProductionPlaceType": productionPlaceType,
      "ProductionPlace": productionPlace,
      "RetailPrice": retailPrice,
      "AdultYN": adultYN,
      "ContactInfo": contactInfo,
      "ShippingNo": shippingNo,
      "OptionShippingNo1": optionShippingNo1,
      "OptionShippingNo2": optionShippingNo2,
      "Weight": weight ?? "0",
      "DesiredShippingDate": desiredShippingDate,
      "AvailableDateType": availableDateType,
      "AvailableDateValue": availableDateValue,
      "Keyword": keyword,
    };
    if (manufactureDate.isNotEmpty) {
      result.addAll({"ManufactureDate": manufactureDate});
    }

    return result;
  }
}
