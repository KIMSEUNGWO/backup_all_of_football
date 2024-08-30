
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:groundjp/domain/match/match_simp.dart';

class FieldService {

  static const FieldService instance = FieldService();
  const FieldService();

  Future<ResponseResult> getField({required int fieldId}) async {
    return await ApiService.instance.get(
        uri: '/field/$fieldId',
        authorization: true
    );
  }

  Future<List<MatchSimp>> getSchedule(int fieldId, Pageable pageable) async {
    final response = await ApiService.instance.get(
        uri: '/field/$fieldId/schedule?page=${pageable.page}&size=${pageable.size}',
        authorization: false
    );

    if (response.resultCode == ResultCode.OK) {
      return List<MatchSimp>.from(response.data.map((x) => MatchSimp.fromJson(x)));
    } else {
      return [];
    }
  }

  Future<List<FieldSimp>> searchFields(String word) async {
    final response = await ApiService.instance.get(
        uri: '/search/field?word=$word',
        authorization: false
    );
    if (response.resultCode == ResultCode.OK) {
      return List<FieldSimp>.from(response.data.map((x) => FieldSimp.fromJson(x)));
    } else {
      return [];
    }
  }

}