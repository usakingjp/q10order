import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/item_management/models/get_item_detail_model.dart';

final getItemDetailModels =
    StateProvider<List<GetItemDetailModel>>((ref) => []);
final itemManagementIsWorking = StateProvider<bool>((ref) => false);
final allItemEditText = StateProvider<String>((ref) => '');
