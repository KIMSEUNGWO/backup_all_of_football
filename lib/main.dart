import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/widgets/init.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  const String channelId = '2005763087';
  WidgetsFlutterBinding.ensureInitialized();
  // LINE Login API 연동
  LineSDK.instance.setup(channelId).then((_) => print('LineSDK Prepared'));
  KakaoSdk.init(
    nativeAppKey: '846cc1cb59dc2342563d230f78e577cd',
    javaScriptAppKey: '037e9d8910b3cbec6a1e2e16b22dfb29',
  );
  // 로케일 데이터 를 초기화 합니다.
  await initializeDateFormatting();


  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData(),
      color: const Color(0xFFF1F3F5),
      home: const InitApp(),
    );
  }
}


themeData() {
  return ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: const Color(0xFFF1F3F5),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xFFF1F3F5),
      titleTextStyle: TextStyle(
        color: Color(0xFF292929),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),

    colorScheme: const ColorScheme.light(

      onPrimary: Color(0xFF2F69DD), // 메인 컬러 1
      onSecondary: Color(0xFF77C0F4), // 메인 컬러 2
      onTertiary: Color(0xFFE9F1FA), // 메인 컬러 3

      primary: Color(0xFF292929), // 폰트 컬러 1
      secondary: Color(0xFF767676), // 폰트 컬러 2
      tertiary: Color(0xFF999999), // 폰트 컬러 2

      error: Color(0xFFFF5D5D)
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        color: Color(0xFF292929),
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        color: Color(0xFF292929),
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        color: Color(0xFF292929)
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        color: Color(0xFF292929)
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        color: Color(0xFF797979)
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        color: Color(0xFF797979)
      ),
    ),

  );
}
