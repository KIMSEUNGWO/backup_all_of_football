
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/field/field.dart';

class Match {

  final int matchId;
  final DateTime matchDate;
  final SexType? sexType;
  final int person;
  final int matchCount;
  final int matchHour;
  final MatchStatus matchStatus;
  final Field field;
  final bool alreadyJoin;

  Match.fromJson(Map<String, dynamic> json):
    matchId = json['matchId'],
    matchDate = DateTime.parse(json['matchDate']),
    sexType = SexType.valueOf(json['sexType']),
    person = json['person'],
    matchCount = json['matchCount'],
    matchHour = json['matchHour'],
    matchStatus = MatchStatus.valueOf(json['matchStatus']),
    alreadyJoin = json['alreadyJoin'],
    field = Field.fromJson(json['field']);

  Match(this.matchId, this.matchDate, this.sexType, this.person,
      this.matchCount, this.matchHour, this.matchStatus, this.field, this.alreadyJoin);
}