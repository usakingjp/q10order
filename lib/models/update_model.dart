class UpdateModel {
  final String pacNo;
  String estimatedShippingDate;
  String trackingNo;
  UpdateModel({
    required this.pacNo,
    this.estimatedShippingDate = '',
    this.trackingNo = '',
  });
}
