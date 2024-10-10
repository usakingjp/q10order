import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';

final getItemDetailModelsView =
    StateProvider<List<GetItemDetailModel>>((ref) => []);
final getItemDetailModels =
    StateNotifierProvider<GetItemDetailModels, List<GetItemDetailModel>>(
        (ref) => GetItemDetailModels());

class GetItemDetailModels extends StateNotifier<List<GetItemDetailModel>> {
  GetItemDetailModels() : super([]);
  void set(List<GetItemDetailModel> models) {
    state = [...models];
  }

  void change(GetItemDetailModel model) {
    state = [
      for (final m in state) (m.itemCode != model.itemCode) ? m : model,
    ];
  }

  List<GetItemDetailModel> select(String keyWord) {
    if (keyWord.isEmpty) {
      return state;
    }
    return state
        .where((element) =>
            element.itemTitle.contains(keyWord) ||
            element.itemCode.contains(keyWord) ||
            element.sellerCode.contains(keyWord))
        .toList();
  }
}

final allItemEditText = StateProvider<String>((ref) => '');
