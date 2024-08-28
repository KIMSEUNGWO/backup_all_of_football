
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/domain/coupon/coupon.dart';

class CouponNotifier extends StateNotifier<List<Coupon>> {
  CouponNotifier() : super([]);

  init() async {
    state = await UserService.getCoupons();
  }

  logout() {
    state = [];
  }

  List<Coupon> get() {
    return state;
  }



}

final couponNotifier = StateNotifierProvider<CouponNotifier, List<Coupon>>((ref) => CouponNotifier());