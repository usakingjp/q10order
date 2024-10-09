class PageSettingModel {
  int? id;
  int listOrTile;
  int rowQty;
  int accentColor;
  int subColor;
  String titleLength;
  List<String> exclusions;
  String imageUrl;
  int imageFormat;
  bool dispTitle;
  bool dispBrand;
  bool dispImage;
  bool dispPrice;
  bool dispPromotion;
  String sampleWidth;
  PageSettingModel({
    this.id,
    this.listOrTile = 0,
    this.rowQty = 3,
    this.accentColor = 4284955319,
    this.subColor = 4286336511,
    this.titleLength = '20',
    this.exclusions = const [],
    this.imageUrl = '',
    this.imageFormat = 0,
    this.dispTitle = true,
    this.dispBrand = true,
    this.dispImage = true,
    this.dispPrice = true,
    this.dispPromotion = true,
    this.sampleWidth = '700',
  });
}
