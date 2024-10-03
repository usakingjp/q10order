class CategoryItemModel {
  final String itemCode;
  final String sellerCode;
  final String? brandName;
  final String itemTitle;
  int? categoryId1;
  int? categoryId2;
  int? categoryId3;
  int? categoryId4;
  int? categoryId5;
  int? categoryId6;
  CategoryItemModel({
    required this.itemCode,
    required this.sellerCode,
    this.brandName,
    required this.itemTitle,
    this.categoryId1,
    this.categoryId2,
    this.categoryId3,
    this.categoryId4,
    this.categoryId5,
    this.categoryId6,
  });
  Map<String, dynamic> toMap() {
    return {
      "itemCode": itemCode,
      "sellerCode": sellerCode,
      "brandName": brandName,
      "itemTitle": itemTitle,
      "categoryId1": categoryId1,
      "categoryId2": categoryId2,
      "categoryId3": categoryId3,
      "categoryId4": categoryId4,
      "categoryId5": categoryId5,
      "categoryId6": categoryId6,
    };
  }

  factory CategoryItemModel.fromMap(
      {Map<String, dynamic>? apiResponse, Map<String, dynamic>? queryMap}) {
    try {
      if (apiResponse != null) {
        return CategoryItemModel(
          itemCode: apiResponse["ItemCode"] as String,
          sellerCode: apiResponse["SellerCode"] as String,
          itemTitle: apiResponse["ItemTitle"] as String,
        );
      }
      if (queryMap != null) {
        return CategoryItemModel(
          itemCode: queryMap["itemCode"] as String,
          sellerCode: queryMap["sellerCode"] as String,
          brandName: queryMap["brandName"] as String?,
          itemTitle: queryMap["itemTitle"] as String,
          categoryId1: queryMap["categoryId1"] as int?,
          categoryId2: queryMap["categoryId2"] as int?,
          categoryId3: queryMap["categoryId3"] as int?,
          categoryId4: queryMap["categoryId4"] as int?,
          categoryId5: queryMap["categoryId5"] as int?,
          categoryId6: queryMap["categoryId6"] as int?,
        );
      }
      throw Exception(
          'Data not found. Please provide Map<String, dynamic> data.');
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
