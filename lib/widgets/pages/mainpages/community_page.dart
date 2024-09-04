

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/service/board_service.dart';
import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/board/board_simp.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/board_widget.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/pageable_listview.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';

class CommunityWidget extends ConsumerStatefulWidget {
  const CommunityWidget({super.key});

  @override
  createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends ConsumerState<CommunityWidget> with AutomaticKeepAliveClientMixin {

  late Region _region;

  _selectRegion(Region region) {
    setState(() => _region = region);
  }

  Future<List<BoardSimp>> _fetch(Pageable pageable) async {
    print('_CommunityWidgetState._fetch');
    return await BoardService.instance.getBoardList(region: _region, pageable: pageable);
  }

  _refresh() {
    setState(() {

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
        child: CustomScrollView(
          slivers: [
            CustomScrollRefresh(
              onRefresh: _refresh,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              sliver: PageableListView.sliver(
                pageableSize: 20,
                separatorBuilder: (context, index) => const SpaceHeight(16),
                future: _fetch,
                builder: (boardSimp) => BoardWidget(boardSimp: boardSimp),
              ),
            ),
          ],
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
