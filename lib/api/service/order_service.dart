

import 'dart:convert';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/service/pipe_buffer.dart';

class OrderService extends PipeBuffer<OrderService> {

  static final OrderService instance = OrderService();
  OrderService();

  Future<ResponseResult> getOrderSimp({required int matchId}) async {
    return await ApiService.instance.get(uri: '/order/match/$matchId', authorization: true);
  }

  Future<ResponseResult> postOrder({required int matchId, required int? couponId}) async {
    Map<String, String> body = {'matchId' : '$matchId'};
    if (couponId != null) body.addAll({'couponId' : '$couponId'});
    return await ApiService.instance.post(
      uri: '/order',
      authorization: true,
      header: ApiService.contentTypeJson,
      body: jsonEncode(body)
    );
  }

  Future<ResponseResult> cancelOrder({required int matchId}) async {
    return await ApiService.instance.post(
      uri: '/cancel',
      authorization: true,
      header: ApiService.contentTypeJson,
      body: jsonEncode({"matchId" : matchId}),
    );
  }

  @override
  OrderService getService() {
    return this;
  }
}