class CategoryModel {
  final int? id;
  final String name;
  final int? parentId;
  CategoryModel({this.id, required this.name, this.parentId});
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "parentId": parentId,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map["id"] as int,
      name: map["name"] as String,
      parentId: map["parentId"] as int?,
    );
  }
}
