
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/permission_handler.dart';
import 'package:groundjp/domain/refund/refund.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationNotifier extends StateNotifier<FlutterLocalNotificationsPlugin> {
  NotificationNotifier() : super(FlutterLocalNotificationsPlugin());

  init() async {
    await PermissionHandler().init();
    AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings = InitializationSettings(android: android, iOS: ios);
    await state.initialize(settings);
  }

  _notificationDetails() {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "GroundJP",
        "show_test",
        channelDescription: "Test Local notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }


  show({required int id, required String title, required String body}) async {
    await state.show(id, title, body, _notificationDetails());
  }

  scheduleMatchDate({required int matchId,  required DateTime matchDate}) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    int notificationId = NotificationType.MATCH.idGenerator(matchId);

    show(id: notificationId, title: '신청 완료', body: '매치 신청이 완료되었습니다.');

    DateTime oneHourBefore = matchDate.subtract(const Duration(hours: 1));
    DateTime twoHoursBefore = matchDate.subtract(const Duration(hours: 2));
    DateTime thirtyMinutesBefore = matchDate.subtract(const Duration(minutes: 30));

    _addSchedule(id: notificationId + 1, title: '경기알림', body: '경기시작 2시간 전이에요.', time: oneHourBefore);
    _addSchedule(id: notificationId + 2, title: '경기알림', body: '경기시작 1시간 전이에요.', time: twoHoursBefore);
    _addSchedule(id: notificationId + 3, title: '경기알림', body: '경기시작 30분 전이에요. 곧 게잉이 시작됩니다.', time: thirtyMinutesBefore);

  }

  matchCancel({required int matchId, required Refund refund}) {
    const type = NotificationType.MATCH;
    int notificationId = type.idGenerator(matchId);

    show(id: notificationId, title: '매치 취소', body: '매치가 취소되었습니다.');
    show(id: notificationId + 1, title: '개인사유로 인한 환불', body: '결제금액 : ${AccountFormatter.format(refund.payAmount)}\n환불금액 : ${AccountFormatter.format(refund.refundAmount)}');

    type.forEach(notificationId, (id) {
      state.cancel(id);
    },);
  }


  _addSchedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) {
    if (time.isBefore(DateTime.now())) {
      return;
    }
    state.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      _notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}

final notificationNotifier = StateNotifierProvider<NotificationNotifier, FlutterLocalNotificationsPlugin>((ref) => NotificationNotifier());


enum NotificationType {

  MATCH;

  int idGenerator(int matchId) {
    return switch (this) {
      MATCH => matchId * 10,
    };
  }

  void forEach(int id, Function(int) run) {
    for (int i=id+1;i<=id+9;i++) {
      run(i);
    }
  }

}