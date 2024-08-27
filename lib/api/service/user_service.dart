
import 'dart:convert';
import 'dart:async';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/secure_strage.dart';
import 'package:groundjp/domain/cash/receipt.dart';
import 'package:groundjp/domain/coupon/coupon.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/domain/user/user_profile.dart';
import 'package:intl/intl.dart';

class UserService {

  static Future<ResultCode> login(SocialResult result) async {
    final response = await ApiService.post(
      uri: '/social/login',
      authorization: false,
      header: ApiService.contentTypeJson,
      body: jsonEncode({
        "socialId" : result.socialId,
        "provider" : result.provider.name,
        "accessToken" : result.accessToken
      }),
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.saveAccessToken(response.data['accessToken']);
      await SecureStorage.saveRefreshToken(response.data['refreshToken']);
      print('LINE LOGIN SUCCESS !!!');
    }
    return response.resultCode;
  }

  static Future<UserProfile?> getProfile() async {

    final response = await ApiService.get(
      uri: '/user/profile',
      authorization: true,
    );

    if (response.resultCode == ResultCode.OK) {
      return UserProfile.fromJson(response.data);
    }
    return null;
  }

  static Future<ResultCode> register({required SexType sex, required DateTime birth, required SocialResult social}) async {

    final response = await ApiService.post(
        uri: '/register',
        authorization: false,
        header: ApiService.contentTypeJson,
        body: jsonEncode({
          "sex" : sex.name,
          "birth" : DateFormat('yyyy-MM-dd').format(birth),
          "socialId" : social.socialId,
          "provider" : social.provider.name,
          "accessToken" : social.accessToken
        })
    );

    if (response.resultCode == ResultCode.OK) {
      await SecureStorage.saveAccessToken(response.data['accessToken']);
      await SecureStorage.saveRefreshToken(response.data['refreshToken']);
      print('REGISTER SUCCESS !!!');
    }
    return response.resultCode;
  }

  static Future<ResponseResult> getCash() async {
    return await ApiService.get(
      uri: '/user/cash',
      authorization: true,
    );
  }

  static Future<List<Receipt>> getReceipt() async {
    final response = await ApiService.get(
      uri: '/user/receipt',
      authorization: true,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<Receipt>.from(response.data.map( (x) => Receipt.fromJson(x) ));
    } else {
      return [];
    }
  }

  static Future<Map<int, List<MatchView>>> getHistory(DateTime date) async {
    final String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date);

    final response = await ApiService.get(
      uri: '/user/history?date=$formattedDate',
      authorization: true,
    );
    if (response.resultCode == ResultCode.OK) {
      Map<int, List<MatchView>> result = {};

      response.data.forEach((key, value) {
        final int intKey = int.parse(key);
        final List<MatchView> matchList = (value as List)
            .map((item) => MatchView.fromJson(item))
            .toList();
        result[intKey] = matchList;
      });

      return result;
    } else {
      return {};
    }
  }

  static Future<List<FieldSimp>> getFavorites() async {
    final response = await ApiService.get(
      uri: '/user/favorite',
      authorization: true,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<FieldSimp>.from(response.data.map((x) => FieldSimp.fromJson(x)));
    } else {
      return [];
    }
  }

  static void test() async {
    final response = await ApiService.get(
      uri: '/test',
      authorization: true,
    );
  }

  static editFavorite(int fieldId, bool toggle) async {
    final response = await ApiService.post(
        uri: '/user/favorite',
        authorization: true,
        header: ApiService.contentTypeJson,
        body: jsonEncode({
          "fieldId" : fieldId,
          "toggle" : toggle,
        })
    );
    return response.resultCode;
  }

  static Future<List<Coupon>> getCoupons() async {
    final response = await ApiService.get(
      uri: '/user/coupon',
      authorization: true,
    );
    if (response.resultCode == ResultCode.OK) {
      return List<Coupon>.from(response.data.map((x) => Coupon.fromJson(x)));
    } else {
      return [];
    }
  }

  static Future<bool> distinctNickname(String nickname) async {
    String encodedNickname = Uri.encodeComponent(nickname);
    final response = await ApiService.get(
      uri: '/user/distinct/nickname?nickname=$encodedNickname',
      authorization: true,
    );
    if (response.resultCode == ResultCode.OK) {
      return response.data;
    } else {
      return true;
    }
  }

}