
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/refund/refund.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/draw/document.dart';
import 'package:groundjp/widgets/form/field_image_preview.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/favorite_field_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/match_soon_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/recently_visit_match_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/region_match_display.dart';
import 'package:groundjp/widgets/pages/poppages/search_page.dart';
import 'package:groundjp/widgets/pages/poppages/user/login_page.dart';
import 'package:groundjp/widgets/pages/poppages/notification_page.dart';
import 'package:groundjp/widgets/pages/poppages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeWidget> with AutomaticKeepAliveClientMixin {

  UniqueKey _refreshMatchSoon = UniqueKey();

  _refresh() {
    setState(() {
      _refreshMatchSoon = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    if (state != null) _refreshMatchSoon = UniqueKey();
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SearchWidget();
              },));
            },
            child: SvgIcon.asset(sIcon: SIcon.search,
              style: SvgIconStyle(
                color: Theme.of(context).colorScheme.primary
              )
            ),
          ),
          const SpaceWidth(30),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const NotificationWidget();
              },));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: SvgIcon.asset(sIcon: SIcon.bell),
            )
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          CustomScrollRefresh(onRefresh: _refresh),
          SliverToBoxAdapter(child: _Banners(),),
          SliverToBoxAdapter(
            child: MatchSoonDisplay(
              key: _refreshMatchSoon,
            ),
          ),
          const SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FavoriteFieldDisplay(),
                RecentlyVisitMatchDisplay(),
                RegionMatchDisplay(),
                SpaceHeight(36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Banners extends StatelessWidget {
  _Banners();

  final List<Image> _banners = [
    Image.asset('assets/banners/1.png', fit: BoxFit.fitWidth,),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 24.h),
      child: ImageSlider(
        images: _banners,
        option: ImageSliderOption(
          height: 100,
          borderRadius: BorderRadius.circular(16),
          autoplay: false
        ),
      ),
    );
  }
}

