import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q10order/pages/setting/models/seller_authorization_key_model.dart';

final sellerAuthKey = StateProvider<SellerAuthorizationKey>((ref)=>SellerAuthorizationKey());