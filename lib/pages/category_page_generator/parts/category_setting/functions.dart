import '../../models/category_item_model.dart';

CategoryItemModel categoryIdsOrganize(CategoryItemModel model) {
  List<int?> categoryIds = [
    model.categoryId1,
    model.categoryId2,
    model.categoryId3,
    model.categoryId4,
    model.categoryId5,
    model.categoryId6,
  ];
  categoryIds = categoryIds.toSet().whereType<int>().toList();
  model.categoryId1 = null;
  model.categoryId2 = null;
  model.categoryId3 = null;
  model.categoryId4 = null;
  model.categoryId5 = null;
  model.categoryId6 = null;
  for (var i = 0; i < categoryIds.length; i++) {
    switch (i) {
      case 0:
        model.categoryId1 = categoryIds[i];
        break;
      case 1:
        model.categoryId2 = categoryIds[i];
        break;
      case 2:
        model.categoryId3 = categoryIds[i];
        break;
      case 3:
        model.categoryId4 = categoryIds[i];
        break;
      case 4:
        model.categoryId5 = categoryIds[i];
        break;
      case 5:
        model.categoryId6 = categoryIds[i];
        break;
      default:
        break;
    }
  }
  return model;
}
