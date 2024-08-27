
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/match/match_search_view.dart';
import 'package:groundjp/notifier/region_notifier.dart';
import 'package:groundjp/widgets/component/match_list.dart';
import 'package:groundjp/widgets/pages/poppages/region_select_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegionMatchDisplay extends ConsumerStatefulWidget {
  const RegionMatchDisplay({super.key});

  @override
  ConsumerState<RegionMatchDisplay> createState() => _RegionMatchDisplayState();
}

class _RegionMatchDisplayState extends ConsumerState<RegionMatchDisplay> {

  List<MatchView> result = [
    MatchView(1, MatchStatus.OPEN, '안양대학교 SKY 풋살파크 C구장', DateTime.now(), MatchData(null, Region.BUNKYO, 5, 3)),
    MatchView(2, MatchStatus.CLOSING_SOON, '안양대학교 SKY 풋살파크 C구장', DateTime.now(), MatchData(SexType.MALE, Region.BUNKYO, 5, 2)),
    MatchView(3, MatchStatus.CLOSED, '안양대학교 SKY 풋살파크 C구장안양대학교 SKY 풋살파크 C구장안양대학교 SKY 풋살파크 C구장', DateTime.now(), MatchData(SexType.FEMALE, Region.BUNKYO, 6, 3)),
    MatchView(4, MatchStatus.FINISHED, '어딘가의 구장', DateTime(2024, 01, 1, 1,1), MatchData(null, Region.BUNKYO, 6, 2)),
  ];

  void _changeRegion(Region region) {
    ref.read(regionProvider.notifier).setRegion(context, region);
  }
  @override
  Widget build(BuildContext context) {

    Region region = ref.watch(regionProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Text('오늘 ',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RegionSelectWidget(onPressed: _changeRegion);
                    },));
                  },
                  child: Text(region.ko,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(' 일정이에요.',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10,),

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12,),
            itemCount: result.length,
            itemBuilder: (context, index) => MatchListWidget(
              match: result[index],
              formatType: DateFormatType.TIME,
            ),
          )

        ],
      ),
    );
  }
}
