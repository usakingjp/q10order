class CategoryModel {
  final int? id;
  final String name;
  final int? parentId;
  String headerImageUrl;
  CategoryModel(
      {this.id, required this.name, this.parentId, this.headerImageUrl = ''});
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "parentId": parentId,
      "headerImageUrl": headerImageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map["id"] as int,
      name: map["name"] as String,
      parentId: map["parentId"] as int?,
      headerImageUrl: map["headerImageUrl"] as String,
    );
  }
}
