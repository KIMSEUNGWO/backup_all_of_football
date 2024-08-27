
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:intl/intl.dart';

class MatchService {
  static Future<List<MatchView>> search(SearchCondition condition) async {

    String queryParam = '?date=${DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(condition.date)}';
    if (condition.region != null && condition.region != Region.ALL) {
      queryParam += '&region=${condition.region!.name}';
    }
    if (condition.sexType != null) {
      queryParam += '&sex=${condition.sexType!.name}';
    }
    final response = await ApiService.get(
      uri: '/search$queryParam',
      authorization: false,
    );
    print(response.data);
    if (response.resultCode == ResultCode.OK) {
      return List<MatchView>.from(response.data.map( (x) => MatchView.fromJson(x)));
    } else {
      return [];
    }
  }

  static Future<ResponseResult> getMatch({required int matchId}) async {
    return await ApiService.get(
      uri: '/match/$matchId',
      authorization: true
    );
  }

  static Future<List<MatchView>> getMatchesSoon() async {
    final response = await ApiService.get(
        uri: '/user/matches',
        authorization: true
    );
    if (response.resultCode == ResultCode.OK) {
      return List<MatchView>.from(response.data.map((x) => MatchView.fromJson(x)));
    } else {
      return [];
    }
  }



}