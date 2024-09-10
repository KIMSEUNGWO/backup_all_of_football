
import 'dart:convert';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/board/board_simp.dart';

class BoardService {

  static const BoardService instance = BoardService();
  const BoardService();

  Future<List<BoardSimp>> getBoardList({required Region region, required Pageable pageable }) async {
    String uri = '/search/board?&page=${pageable.page}&size=${pageable.size}';
    if (region != Region.ALL) uri += '&region=${region.name}';
    final response = await ApiService.instance.get(
      uri: uri,
      authorization: false,
    );
    if (response.resultCode == ResultCode.OK) {
      return List.from(response.data.map( (x) => BoardSimp.fromJson(x)));
    }
    return [];
  }

  Future<ResponseResult> getBoardDetail({required int boardId}) async {
    return await ApiService.instance.get(
      uri: '/board/$boardId',
      authorization: false,
    );
  }

  Future<ResponseResult> postBoard({required String title, required String content, int? matchId, Region? region}) async {
    final body = {
      'title' : title,
      'content' : content
    };
    if (matchId != null) {
      body.addAll({'matchId' : '$matchId'});
    }
    if (region != null && region != Region.ALL) {
      body.addAll({'region' : region.name});
    }
    return await ApiService.instance.post(
      uri: '/board/method',
      authorization: true,
      header: ApiService.contentTypeJson,
      body: jsonEncode(body)
    );
  }

  Future<ResponseResult> patchBoard({required String title, required String content, int? matchId, Region? region, required int boardId}) async {
    final body = {
      'boardId' : boardId,
      'title' : title,
      'content' : content
    };
    if (matchId != null) {
      body.addAll({'matchId' : '$matchId'});
    }
    if (region != null && region != Region.ALL) {
      body.addAll({'region' : region.name});
    }
    return await ApiService.instance.patch(
        uri: '/board/method',
        authorization: true,
        header: ApiService.contentTypeJson,
        body: jsonEncode(body)
    );
  }

  Future<ResponseResult> deleteBoard({required int boardId}) async {
    return await ApiService.instance.delete(
        uri: '/board/method',
        authorization: true,
        header: ApiService.contentTypeJson,
        body: jsonEncode({'boardId' : boardId})
    );
  }
}