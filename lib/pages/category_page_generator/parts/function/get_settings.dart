import 'package:shared_preferences/shared_preferences.dart';

import '../../models/page_setting_model.dart';

Future<PageSettingModel> getSettings({bool isMob = false}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (isMob) {
    return PageSettingModel(
      listOrTile: prefs.getInt('listOrTileM') ?? 0,
      rowQty: prefs.getInt('rowQtyM') ?? 2,
      accentColor: prefs.getInt('accentColorM') ?? 4284955319,
      subColor: prefs.getInt('subColorM') ?? 4286336511,
      titleLength: prefs.getString('titleLengthM') ?? '20',
      exclusions: prefs.getStringList('exclusionsM') ?? [],
      dispTitle: prefs.getBool('dispTitleM') ?? true,
      dispBrand: prefs.getBool('dispBrandM') ?? true,
      dispImage: prefs.getBool('dispImageM') ?? true,
      dispPrice: prefs.getBool('dispPriceM') ?? true,
      dispPromotion: prefs.getBool('dispPromotionM') ?? false,
      sampleWidth: prefs.getString('sampleWidthM') ?? '400',
    );
  } else {
    return PageSettingModel(
      listOrTile: prefs.getInt('listOrTile') ?? 0,
      rowQty: prefs.getInt('rowQty') ?? 3,
      accentColor: prefs.getInt('accentColor') ?? 4284955319,
      subColor: prefs.getInt('subColor') ?? 4286336511,
      titleLength: prefs.getString('titleLength') ?? '20',
      exclusions: prefs.getStringList('exclusions') ?? [],
      dispTitle: prefs.getBool('dispTitle') ?? true,
      dispBrand: prefs.getBool('dispBrand') ?? true,
      dispImage: prefs.getBool('dispImage') ?? true,
      dispPrice: prefs.getBool('dispPrice') ?? true,
      dispPromotion: prefs.getBool('dispPromotion') ?? true,
      sampleWidth: prefs.getString('sampleWidth') ?? '700',
    );
  }
}
