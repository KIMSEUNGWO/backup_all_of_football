

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/widgets/component/bottom_bar_widget.dart';
import 'package:groundjp/widgets/pages/mainpages/home_page.dart';
import 'package:groundjp/widgets/pages/mainpages/match_list_page_new.dart';
import 'package:groundjp/widgets/pages/mainpages/mypage_page.dart';
import 'package:groundjp/widgets/pages/mainpages/search_page.dart';
import 'package:groundjp/widgets/pages/poppages/login_page.dart';


class App extends ConsumerStatefulWidget {

  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {

  late PageController _pageController;

  int _currentIndex = 0;

  onChangePage(int index) {
    setState(() { _currentIndex = index;});
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeWidget(),
          const MatchListPageWidget(),
          MyPageWidget(onChangePage: onChangePage),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        height: 57,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomIcon(
              sIcon: SIcon.home,
              callback: () => onChangePage(0),
              isPressed: _currentIndex == 0,
            ),
            BottomIcon(
              sIcon: SIcon.search,
              callback: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return SearchWidget();
                },));
              },
              isPressed: false,
            ),
            BottomIcon(
              sIcon: SIcon.clipboard,
              callback: () => onChangePage(1),
              isPressed: _currentIndex == 1,
            ),
            BottomIcon(
              sIcon: SIcon.person,
              callback: () {
                bool hasLogin = ref.read(loginProvider.notifier).has();
                if (hasLogin) {
                  onChangePage(2);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return const LoginWidget();
                  },fullscreenDialog: true));
                }
              },
              isPressed: _currentIndex == 2,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {

  final SIcon sIcon;
  final GestureTapCallback callback;
  final bool isPressed;

  const BottomIcon({super.key, required this.sIcon, required this.callback, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(),
        child: SvgIcon.asset(
          sIcon: sIcon,
          style: isPressed
            ? SvgIconStyle(color: Theme.of(context).colorScheme.onPrimary)
            : null
        ),
      ),
    );
  }
}

