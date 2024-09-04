
import 'package:flutter/cupertino.dart';

class CustomScrollRefresh extends StatelessWidget {

  final Function onRefresh;

  const CustomScrollRefresh({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 150.0,
      refreshIndicatorExtent: 100.0,
      onRefresh: () async {
        // 위로 새로고침
        await Future.delayed(const Duration(seconds: 1), onRefresh());
        await Future.delayed(const Duration(seconds: 1));
      },
    );
  }
}
