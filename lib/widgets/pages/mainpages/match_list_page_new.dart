
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/domain/search_condition.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/component/search_data.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchListPageWidget extends ConsumerStatefulWidget {
  const MatchListPageWidget({super.key});

  @override
  ConsumerState<MatchListPageWidget> createState() => _MatchListPageWidgetState();
}

class _MatchListPageWidgetState extends ConsumerState<MatchListPageWidget> with AutomaticKeepAliveClientMixin {

  final _dateRange = 30;
  int _currentDateIndex = 0;
  bool _loading = false;
  
  late List<MatchView> _items = [];
  int _pageNumber = 0;
  final int _pageSize = 10;
  bool _hasMoreData = true;


  late SearchCondition _condition;

  _selectRegion(Region region) async {
    ref.read(regionProvider.notifier).setRegion(context, region);
    Region newRegion = await ref.read(regionProvider.notifier).get();
    if (_condition.region == newRegion) return;
    _search(
      SearchCondition(
        date: _condition.date,
        sexType: _condition.sexType,
        region: newRegion
      )
    );
  }

  _search(SearchCondition condition) async {
    _condition = condition;
    List<MatchView> response = await MatchService.search(_condition);
    setState(() {
      _items = response;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RegionSelectWidget(
                onPressed: _selectRegion,
              );
            },));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ref.watch(regionProvider).getLocaleName(const Locale('ko', 'KR')),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Icon(Icons.keyboard_arrow_down_rounded)
            ]
          ),
        ),

      ),

      body: Column(
        children: [
          SearchData(search: _search, dateRange: _dateRange, selectedDateIndex: _currentDateIndex),

          Expanded(
            child: Skeletonizer(
              enabled: _loading,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: _items.isEmpty
                ? Center(
                 child: Text('매치가 없어요',
                   style: TextStyle(
                     fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                   ),
                 ),
                )
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      CustomScrollRefresh(onRefresh: () {
                      },),

                      const SliverPadding(padding: EdgeInsets.only(top: 32)),

                      SliverList.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 16,);
                        },
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return MatchListWidget(match: _items[index]);
                        },
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

