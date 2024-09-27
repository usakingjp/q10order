class ItemName {
  final String q10cord;
  final String shopCord;
  final String displayName;
  ItemName(
      {required this.shopCord,
      required this.q10cord,
      required this.displayName});
  Map<String, String> toMap() {
    return {
      'q10cord': q10cord,
      'shopCord': shopCord,
      'displayName': displayName
    };
  }
}
