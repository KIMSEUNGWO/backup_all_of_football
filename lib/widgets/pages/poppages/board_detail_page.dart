

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/datetime_formatter.dart';
import 'package:groundjp/domain/board/board.dart';
import 'package:groundjp/widgets/component/board_match_view.dart';
import 'package:groundjp/widgets/component/board_user_profile.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:intl/intl.dart';

class BoardDetailWidget extends StatefulWidget {
  final int boardId;
  const BoardDetailWidget({super.key, required this.boardId});

  @override
  createState() => _BoardDetailWidgetState();
}

class _BoardDetailWidgetState extends State<BoardDetailWidget> {
  
  late Board _board;
  bool _isLoading = true;

  _init() async {
    ResponseResult result = await BoardService.instance.getBoardDetail(boardId: widget.boardId);
    
    if (result.resultCode == ResultCode.OK) {
      setState(() {
        _board = Board.fromJson(result.data);
        _isLoading = false;
      });
    } else if (result.resultCode == ResultCode.BOARD_NOT_EXISTS) {
      Alert.of(context).message(
        message: '존재하지 않는 게시글입니다.',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }
  
  @override
  void initState() {
    _init();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: (_isLoading) ? const SizedBox()
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceHeight(26),
                    Text(_board.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SpaceHeight(4),
                    Row(
                      children: [
                        BoardUserProfileWidget(user: _board.user),
                        const SpaceWidth(10),
                        Text(DateTimeFormatter.formatDate(_board.createDate),),
                        if (_board.isEdit)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('(수정됨)'),
                          ),
                      ],
                    ),
                    const SpaceHeight(26),
                    Text(_board.content,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                    if (_board.match != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: DetailDefaultFormWidget(
                          title: '${DateFormat.MMMd('ko_KR').format(_board.match!.matchDate)} ${DateFormat.H('ko_KR').format(_board.match!.matchDate)}에 경기가 있어요',
                          child: BoardMatchViewWidget(match: _board.match!),
                        ),
                      ),

                    SpaceHeight(MediaQuery.paddingOf(context).bottom + 60),
                  ],
                ),
              ),
          ),
        ),

        if (_isLoading)
          const Positioned(
            child: Center(
              child: CupertinoActivityIndicator(radius: 13,),
            ),
          ),
      ],
    );
  }
}
