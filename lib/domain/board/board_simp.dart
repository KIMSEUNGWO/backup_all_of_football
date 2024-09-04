
import 'package:groundjp/domain/user/user_simp.dart';

class BoardSimp {

  final int boardId;
  final String title;
  final DateTime createDate;

  final UserSimp user;

  BoardSimp.fromJson(Map<String, dynamic> json):
    boardId = json['boardId'],
    title = json['title'],
    createDate = DateTime.parse(json['createDate']),
    user = UserSimp.fromJson(json['user']);

  BoardSimp({required this.boardId, required this.title, required this.createDate, required this.user});
}