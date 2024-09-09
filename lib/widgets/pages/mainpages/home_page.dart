
import 'package:groundjp/api/service/user_service.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/domain/refund/refund.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/notifier/notification_notifier.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/custom_scroll_refresh.dart';
import 'package:groundjp/widgets/component/space_custom.dart';
import 'package:groundjp/widgets/form/field_image_preview.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/favorite_field_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/match_soon_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/recently_visit_match_display.dart';
import 'package:groundjp/widgets/pages/mainDisplayLists/region_match_display.dart';
import 'package:groundjp/widgets/component/chart_donut_painter_widget.dart';
import 'package:groundjp/widgets/pages/poppages/search_page.dart';
import 'package:groundjp/widgets/pages/poppages/login_page.dart';
import 'package:groundjp/widgets/pages/poppages/notification_page.dart';
import 'package:groundjp/widgets/pages/poppages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              padding: const EdgeInsets.only(right: 20),
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

          SliverToBoxAdapter(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const LoginWidget();
                    }, fullscreenDialog: true));
                  },
                  child: const Text('로그인 페이지 이동',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RegisterWidget(social: SocialResult(socialId: 'asdfasdf', provider: SocialProvider.LINE, accessToken: 'accesstokenasdlfkajelfi13'));
                    },));
                  },
                  child: Text('회원가입 페이지 이동',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UserService.instance.test();
                  },
                  child: Text('테스트 데이터 로드',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(notificationNotifier.notifier).show(id: 1, title: '타이틀', body: '내용');
                  },
                  child: Text('알림 테스트',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(notificationNotifier.notifier).scheduleMatchDate(
                      matchId: 1,
                      matchDate: DateTime.now().add(const Duration(seconds: 40)),
                    );
                  },
                  child: Text('스케줄 알림 테스트',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(notificationNotifier.notifier).matchCancel(matchId: 1, refund: Refund(10000, 2000));
                  },
                  child: Text('스케줄 취소 테스트',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return ChartsExample(
                    //     diameter: 100,
                    //     data: [
                    //       ChartData(title: '남자', value: 17, color: Colors.blue),
                    //       ChartData(title: '여자', value: 1, color: Colors.red),
                    //     ],
                    //   );
                    // },));
                  },
                  child: Text('차트 예제',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
              ],
            ),
          )
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
    Image.asset('assets/banners/1.png', fit: BoxFit.cover,),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
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

