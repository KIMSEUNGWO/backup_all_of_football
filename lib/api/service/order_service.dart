

import 'dart:convert';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';

class OrderService {

  static Future<ResponseResult> getOrderSimp({required int matchId}) async {
    return await ApiService.get(uri: '/order/match/$matchId', authorization: true);
  }

  static Future<ResponseResult> postOrder({required int matchId, required int? couponId}) async {
    Map<String, String> body = {'matchId' : '$matchId'};
    if (couponId != null) body.addAll({'couponId' : '$couponId'});
    return await ApiService.post(
      uri: '/order',
      authorization: true,
      header: ApiService.contentTypeJson,
      body: jsonEncode(body)
    );
  }

  static Future<ResponseResult> cancelOrder({required int matchId}) async {
    return await ApiService.post(
      uri: '/cancel',
      authorization: true,
      header: ApiService.contentTypeJson,
      body: jsonEncode({"matchId" : matchId}),
    );
  }
}