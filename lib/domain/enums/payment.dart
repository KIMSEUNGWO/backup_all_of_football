
import 'package:groundjp/component/svg_icon.dart';
import 'package:flutter/material.dart';

enum Payment {

  LINE(Color(0xFF08BF5B), 'line'),
  KAKAO(Color(0xFFF3DA01), 'kakao'),
  APPLE(Colors.black, 'apple');

  final Color backgroundColor;
  final String url;

  const Payment(this.backgroundColor, this.url);

  SIcon getLogo() {
    return switch (this) {
      Payment.LINE => SIcon.linePay,
      Payment.KAKAO => SIcon.kakaoPay,
      Payment.APPLE => SIcon.applePay,
    };
  }
}