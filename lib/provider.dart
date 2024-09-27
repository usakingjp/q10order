import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/models/item_name.dart';
import 'package:q10order/workers/usagi/item_name.dart';

import 'models/order_model.dart';
import 'models/update_model.dart';

final workingProvider = StateProvider<bool>((ref) => false);
final status = StateProvider<int>((ref) => 0);
final checkers = StateProvider<List<int>>((ref) => []);
final sakP = StateProvider<String>((ref) => '');

final updates = StateNotifierProvider<UpdateModels, List<UpdateModel>>(
    (ref) => UpdateModels());

class UpdateModels extends StateNotifier<List<UpdateModel>> {
  UpdateModels() : super([]);
  void add(UpdateModel model) {
    state = [...state, model];
  }

  void remove() {
    state = [];
  }
}

final itemNames =
    StateNotifierProvider<ItemNames, List<ItemName>>((ref) => ItemNames());

class ItemNames extends StateNotifier<List<ItemName>> {
  ItemNames() : super([]);
  void set(List<ItemName> models) {
    state = [...models];
  }

  void add(ItemName model) {
    state = [...state, model];
  }

  void remove() {
    state = [];
  }

  void replaceModel(ItemName model) {
    state = [
      for (final m in state) (m.shopCord != model.shopCord) ? m : model,
    ];
  }

  void sort({required String column, required bool asc}) {
    List<ItemName> c = [...state];
    switch (column) {
      case 'q10cord':
        c.sort((a, b) => (asc)
            ? a.q10cord.compareTo(b.q10cord)
            : b.q10cord.compareTo(a.q10cord));
        break;
      case 'shopCord':
        c.sort((a, b) => (asc)
            ? a.shopCord.compareTo(b.shopCord)
            : b.shopCord.compareTo(a.shopCord));
        break;
      case 'displayName':
        c.sort((a, b) => (asc)
            ? a.displayName.compareTo(b.displayName)
            : b.displayName.compareTo(a.displayName));
        break;
    }
    state = c;
  }
}

final orders = StateNotifierProvider<OrderModels, List<OrderModel>>(
    (ref) => OrderModels());

class OrderModels extends StateNotifier<List<OrderModel>> {
  OrderModels() : super([]);
  void addModel(OrderModel model) {
    state = [...state, model];
  }

  void replaceModel(OrderModel model) {
    state = [
      for (final m in state) (m.packNo != model.packNo) ? m : model,
    ];
  }

  void removeModel(OrderModel model) {
    state = [
      for (final m in state)
        if (m.packNo != model.packNo) m,
    ];
  }

  void refresh() {
    state = [...state];
  }

  bool isContain(OrderModel model) {
    var contain = state.where((element) {
      if (element.packNo == model.packNo) {
        return true;
      }
      return false;
    });
    return contain.isNotEmpty;
  }
}
