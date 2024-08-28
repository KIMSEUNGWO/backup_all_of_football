
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/domain/cash/kakao_ready_response.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenApp {

  // 테스트용
  static const String homeLat = "35.757721";
  static const String homeLng = "139.527805";

  openMaps({required double lat, required double lng}) async {

    String openApp = 'comgooglemaps://';
    print(await canLaunchUrl(Uri.parse(openApp)));
    // await launchUrl(Uri.parse(openApp));
    Uri googleMap = _google(lat, lng);
    if (await canLaunchUrl(googleMap)) {
      await launchUrl(googleMap);
    }

    Uri appleMap = _apple(lat, lng);
    if (await canLaunchUrl(appleMap)) {
      launchUrl(appleMap);
      return;
    }

  }

  kakaoOpenUrl(BuildContext context, KakaoReady kakao) async {
    if (Platform.isAndroid && await canLaunchUrl(Uri.parse(kakao.android_app_scheme))) {
      await launchUrl(Uri.parse(kakao.android_app_scheme));
      return;
    } else if (Platform.isIOS && await canLaunchUrl(Uri.parse(kakao.ios_app_scheme))) {
      await launchUrl(Uri.parse(kakao.ios_app_scheme));
      return;
    } else {
      Alert.of(context).message(
        message: '카카오톡이 설치되어있지 않습니다.'
      );
    }
  }

  _google(double lat, double lng) {
    return Uri.parse('comgooglemaps://?q=$lat,$lng');
  }

  _apple(double lat, double lng) {
    return Uri.parse('maps://?q=$lat,$lng');
  }
}
