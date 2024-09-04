

import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/user/user_simp.dart';

class Board {

  final int boardId;
  final String title;
  final String content;
  final DateTime createDate;
  final bool isEdit;

  final UserSimp user;
  final MatchView? match;

  Board.fromJson(Map<String, dynamic> json):
    boardId = json['boardId'],
    title = json['title'],
    content = json['content'],
    createDate = DateTime.parse(json['createDate']),
    user = UserSimp.fromJson(json['user']),
    isEdit = json['isEdit'],
    match = json['match'] == null ? null : MatchView.fromJson(json['match']);

  Board({required this.boardId, required this.title, required this.content, required this.createDate, required this.isEdit, this.match, required this.user});
}