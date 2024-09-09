
import 'dart:convert';

import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/board/board_simp.dart';
import 'package:groundjp/domain/user/user_simp.dart';

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
    return ResponseResult(
      ResultCode.OK,
      {
        'boardId': boardId,
        'title': '⚽️フットサル、サッカー好きな人！⚽️🌟フットサル仲間募集',
        'content': """
🍀⚽️フットサル仲間募集⚽️🍀 

※上記以外の日程も開催しております！！✨

 初めて参加される方も、 
初心者の方も、 
女性の方も みんなかま楽しめるような イベントにしておりますっ！🐱✨ 

楽しくスポーツできる方募集します🙆‍♀️🌸

 大阪市内のコートにてフットサルをしています🙋‍♀️⚽
️
 未経験者多数の男女混合のチームです👫🌟 

⭐詳細について⭐
️ 応募のメッセージをいただいた方に、個別にお送りしております！ 

⭐︎イベントの価格帯⭐
️ 1,000円〜2,000円くらいですっ👼🏻✨ 

⭐︎男女比 ⭐️ 
半々で20代がメインですっ👯‍♂️🌼👯‍♀️ 

⭐️活動場所 ⭐️ 
大阪市内、会場によって変わります🎊💫 

⭐️皆様のご参加、 楽しみにしております！ 宜しくお願い致します🤲✨ 興味のある方は...🌟

 お気軽にメッセージくださいっっ😊📩✨
        """,
        'createDate': '2024-09-01T11:20:20',
        'isEdit' : true,
        'user': {'userId': 1, 'nickname': '닉네임임ㅋ', 'profile': null},
        'match' : {
          'matchId' : 1,
          'matchStatus' : 'OPEN',
          'title' : '안양대학교 SKY 풋살파크 C구장',
          'matchDate' : '2024-09-30T14:00',
          'matchData' : {
            'region' : 'HOKKAIDO',
            'person' : 5,
            'matchCount' : 3,
          },
        },
      },
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
}