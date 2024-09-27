import 'update_goods_model.dart';

class GetItemDetailModel {
  GetItemDetailModel({
    required this.itemCode,
    required this.itemStatus,
    required this.itemTitle,
    required this.promotionName,
    required this.mainCatCd,
    required this.mainCatNm,
    required this.firstSubCatCd,
    required this.firstSubCatNm,
    required this.secondSubCatCd,
    required this.secondSubCatNm,
    required this.drugtype,
    required this.sellerCode,
    required this.productionPlaceType,
    required this.productionPlace,
    required this.industrialCodeType,
    required this.industrialCode,
    required this.retailPrice,
    required this.itemPrice,
    required this.taxRate,
    required this.settlePrice,
    required this.itemQty,
    required this.expireDate,
    required this.modelNM,
    required this.manufacturerDate,
    required this.brandNo,
    required this.material,
    required this.adultYN,
    required this.desiredShippingDate,
    required this.availableDateType,
    required this.availableDateValue,
    required this.shippingNo,
    required this.contactInfo,
    required this.itemDetail,
    required this.imageUrl,
    required this.videoURL,
    required this.keyword,
    required this.listedDate,
    required this.changedDate,
    required this.optionShippingNo1,
    required this.optionShippingNo2,
  });

  /// 登録された商品のQoo10商品コード
  final String itemCode;

  /// 商品の取引状況（取引待機= S1、取引可能= S2）
  final String itemStatus;

  /// 商品名
  final String itemTitle;

  /// 広告文
  final String promotionName;

  /// 	Qoo10商品のメインカテゴリーコードです。 （ex.100000001）
  final String mainCatCd;

  /// Qoo10商品のメインカテゴリー名です。 （ex.Women\u0026#39;s Clothing）
  final String mainCatNm;

  /// Qoo10商品のサブカテゴリーコードです。 （ex.200000001）
  final String firstSubCatCd;

  /// Qoo10商品のサブカテゴリー名です。 （ex.Dresses）
  final String firstSubCatNm;

  /// Qoo10商品のセカンドサブカテゴリーコードです。 （ex.300000001）
  final String secondSubCatCd;

  /// Qoo10商品のセカンドサーブカテゴリー名です。 （ex.Casual Dress）
  final String secondSubCatNm;

  /// 医薬品カテゴリーを選択する際は必ず入力してください。 (1C : 第1類医薬品, 2C : 第2類医薬品, 3C : 第3類医薬品, D2 : 指定第2類医薬品, QD : 医薬部外品)
  final String drugtype;

  /// 販売者が管理している商品のコードです。商品登録後、その情報を利用して登録された商品を情報を照会したり、修正することができます。
  final String sellerCode;

  /// 原産地タイプ(国内=1、海外=2、その他=3)
  final String productionPlaceType;

  /// 商品の原産情報（国または地域名）
  final String productionPlace;

  /// 商品識別コード(J: JAN、K: KAN、I: ISBN、U: UPC、E: EAN、H: HS)
  final String industrialCodeType;

  /// 製品の産業コードです。 （JAN、ISBN ...など）標準のコードを入力すると、価格比較サイトにて優先表示されることがあります。
  final String industrialCode;

  /// 供給コスト（精算価格）は、商品の販売時に販売価格から手数料を除いて精算される金額です。
  final String retailPrice;

  /// 商品の販売価格
  final String itemPrice;

  /// 商品に適用された消費税率です。
  final String taxRate;

  /// 供給コスト（精算価格）は、商品の販売時に販売価格から手数料を除いて精算される金額です。
  final String settlePrice;

  ///販売数量
  final String itemQty;

  /// 商品の販売終了日。（yyyy-mm-dd）の形式で入力してください。 Nullを入力すると1年後に設定されます
  final String expireDate;

  /// モデル名
  final String modelNM;

  /// メーカー名
  final String manufacturerDate;

  /// ブランド名
  final String brandNo;

  /// 素材(ex: Polyester50%、Synthetic50%)
  final String material;

  /// アダルトグッズかどうか。（アダルトグッズの場合＝Y、アダルトグッズではない場合＝N）
  final String adultYN;

  /// 希望出荷日。出荷のための最小の準備期間です。設定された準備期間以降の希望出荷日を購入者は注文時に選択することができます。 （無効にする= null、準備期間= 3〜20の間の数字）
  final String desiredShippingDate;

  /// "商品発送可能日タイプです。数字で入力してください。（0,1,2,3）
  /// - 0：一般発送（3営業日内発送可能な商品）
  /// - 1：商品準備日
  /// - 2：発売日
  /// - 3：当日発送
  final String availableDateType;

  /// "商品発送可能日タイプの詳細内容です。
  /// - 時間を入力する場合、即日発送商品となります。 （即日発送時間を入力ex：14:30）
  /// - 1〜3を入力する場合は、通常発送商品となります。（一発発送日を入力ex：1）
  /// - 4〜14を入力する場合は、 商品準備日の設定の商品になります。（商品準備日を入力ex：5）
  /// - 日の形式で入力する場合、発売予定日がされます。（発売日を入力ex：2013/09/26）
  final String availableDateValue;

  /// Qoo10送料コード。QSMの送料管理メニューで、使用する送料のコードを確認してください。 0を入力すると送料無料が設定されます。
  final String shippingNo;

  /// 販売者連絡先
  final String contactInfo;

  /// 商品説明。商品ページに案内されている商品説明です。
  final String itemDetail;

  /// 商品の代表画像。商品画像のURL。 （ex。standardimage = http：//image.qoo10.jo.img.jpg）
  final String imageUrl;

  /// 動画URL
  final String videoURL;

  /// 検索ワード 10個まで設定可能(ex: シャツ、デニムシャツ、デニムのシャツ)
  final String keyword;

  /// 商品登録日
  final String listedDate;

  /// 商品更新日（商品情報が最後に変更された日付）
  final String changedDate;

  final String optionShippingNo1;
  final String optionShippingNo2;

  factory GetItemDetailModel.fromMap(Map<String, dynamic> map) {
    return GetItemDetailModel(
      itemCode: map["ItemCode"].toString(),
      itemStatus: map["ItemStatus"].toString(),
      itemTitle: map["ItemTitle"].toString(),
      promotionName: map["PromotionName"].toString(),
      mainCatCd: map["MainCatCd"].toString(),
      mainCatNm: map["MainCatNm"].toString(),
      firstSubCatCd: map["FirstSubCatCd"].toString(),
      firstSubCatNm: map["FirstSubCatNm"].toString(),
      secondSubCatCd: map["SecondSubCatCd"].toString(),
      secondSubCatNm: map["SecondSubCatNm"].toString(),
      drugtype: map["Drugtype"].toString(),
      sellerCode: map["SellerCode"].toString(),
      productionPlaceType: map["ProductionPlaceType"].toString(),
      productionPlace: map["ProductionPlace"].toString(),
      industrialCodeType: map["IndustrialCodeType"].toString(),
      industrialCode: map["IndustrialCode"].toString(),
      retailPrice: map["RetailPrice"].toString(),
      itemPrice: map["ItemPrice"].toString(),
      taxRate: map["TaxRate"].toString(),
      settlePrice: map["SettlePrice"].toString(),
      itemQty: map["ItemQty"].toString(),
      expireDate: map["ExpireDate"].toString(),
      modelNM: map["ModelNM"].toString(),
      manufacturerDate: map["ManufacturerDate"].toString(),
      brandNo: map["BrandNo"].toString(),
      material: map["Material"].toString(),
      adultYN: map["AdultYN"].toString(),
      desiredShippingDate: map["DesiredShippingDate"].toString(),
      availableDateType: map["AvailableDateType"].toString(),
      availableDateValue: map["AvailableDateValue"].toString(),
      shippingNo: map["ShippingNo"].toString(),
      contactInfo: map["ContactInfo"].toString(),
      itemDetail: map["ItemDetail"].toString(),
      imageUrl: map["ImageUrl"].toString(),
      videoURL: map["VideoURL"].toString(),
      keyword: map["Keyword"].toString(),
      listedDate: map["ListedDate"].toString(),
      changedDate: map["ChangedDate"].toString(),
      optionShippingNo1: map["OptionShippingNo1"].toString(),
      optionShippingNo2: map["OptionShippingNo2"].toString(),
    );
  }

  UpdateGoodsModel toUpdateGoods() {
    return UpdateGoodsModel(
        itemCode: itemCode,
        secondSubCat: secondSubCatCd,
        drugtype: drugtype,
        itemTitle: itemTitle,
        promotionName: promotionName,
        sellerCode: sellerCode,
        industrialCodeType: industrialCodeType,
        industrialCode: industrialCode,
        brandNo: brandNo,
        manufactureDate: manufacturerDate,
        modelNm: modelNM,
        material: material,
        productionPlaceType: productionPlaceType,
        productionPlace: productionPlace,
        retailPrice: retailPrice,
        adultYN: adultYN,
        contactInfo: contactInfo,
        shippingNo: shippingNo,
        optionShippingNo1: optionShippingNo1,
        optionShippingNo2: optionShippingNo2,
        desiredShippingDate: desiredShippingDate,
        availableDateType: availableDateType,
        availableDateValue: availableDateValue,
        keyword: keyword);
  }
}
