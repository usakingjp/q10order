class ApiResultModel {
  final String packNo;
  final bool result;
  final String message;
  ApiResultModel(
      {required this.packNo, this.result = true, this.message = '成功'});
}

String apiErrorMessage(String errorCode) {
  switch (errorCode) {
    case '0':
      return '成功';
    case '-10000':
      return '販売者認証キーを確認してください。';
    case '-10001':
      return '注文番号フォーマットエラー';
    case '-10002':
      return 'パラメーター”ShippingCorp”がありません。';
    case '-10003':
      return 'パラメーター ”TrackingNo”がありません。';
    case '-10004':
      return '販売者に関連する注文番号ではありません。';
    case '-10005':
      return '顧客番号フォーマットのエラーです。';
    case '-10010':
      return '更新に失敗しました。';
    case '-10100':
      return '更新に失敗しました。';
    case '-90001':
      return 'APIが存在しません';
    case '-90002':
      return '当該メソッドの実行権限が許可されていません。';
    case '-90003':
      return '当該メソッドの実行権限が許可されていません。';
    case '-90004':
      return '販売者認証キーが期限切れです。新しいキーを使用してください。';
    case '-90005':
      return '販売者認証キーが期限切れです。新しいキーを使用してください。';
    default:
      return '想定外エラー';
  }
}
