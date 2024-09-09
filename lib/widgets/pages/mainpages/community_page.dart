

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/board/board_simp.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/board_widget.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/pageable_listview.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/community_create_page.dart';
import 'package:groundjp/widgets/pages/poppages/login_page.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';

class CommunityWidget extends ConsumerStatefulWidget {
  const CommunityWidget({super.key});

  @override
  createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends ConsumerState<CommunityWidget> with AutomaticKeepAliveClientMixin {

  late Region _region;
  int _refreshKey = 0;

  _selectRegion(Region region) {
    if (_region == region) return;
    setState(() => _region = region);
    _refresh();
  }

  Future<List<BoardSimp>> _fetch(Pageable pageable) async {
    print('_CommunityWidgetState._fetch : page : ${pageable.page}');
    return await BoardService.instance.getBoardList(region: _region, pageable: pageable);
  }

  _refresh() {
    setState(() {
      // Increment the refresh key to trigger a full rebuild of PageableListView
      _refreshKey++;
    });
  }

  @override
  void initState() {
    _region = ref.read(regionProvider.notifier).get() ?? Region.ALL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RegionSelectWidget(onPressed: _selectRegion,);
            },));
          },
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_region.getLocaleName(const Locale('ko', 'KR')),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ]
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    CustomScrollRefresh(
                      onRefresh: _refresh,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      sliver: PageableListView.sliver(
                        key: ValueKey(_refreshKey),  // Use the refreshKey to force a rebuild
                        pageableSize: 20,
                        separatorBuilder: (context, index) => const SpaceHeight(16),
                        future: _fetch,
                        builder: (boardSimp) => BoardWidget(boardSimp: boardSimp),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20, right: 0,
                  child: GestureDetector(
                    onTap: () {
                      bool hasLogin = ref.read(loginProvider.notifier).has();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return hasLogin ? CommunityCreateWidget(refresh: _refresh) : const LoginWidget();
                      }, fullscreenDialog: true));
                    },
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.onSecondary
                      ),
                      child: Center(
                          child: Icon(Icons.add_rounded,
                            color: Colors.white,
                            size: 35,
                          )
                      ),
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
