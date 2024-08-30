import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skeletonizer/skeletonizer.dart';

class SvgIcon extends StatelessWidget {

  final Skeleton svgPicture;

  SvgIcon.privateConstructor(SvgPicture svgPicture, {super.key}):
    svgPicture = Skeleton.shade(child: svgPicture);

  static SvgIcon asset({required SIcon sIcon, SvgIconStyle? style,}) {
    return _SvgIconBuilder(sIcon: sIcon).build(style);
  }

  @override
  Widget build(BuildContext context) {
    return svgPicture;
  }

}

class SvgIconStyle {

  double? width;
  double? height;
  Color? color;
  BoxFit? fit;
  BlendMode? blendMode;

  SvgIconStyle({this.width, this.height, this.color, this.fit, this.blendMode});

}

class SIcon {

  final String picture;
  const SIcon({required this.picture});

  static const SIcon pen = SIcon(picture: 'assets/icons/pen.svg');

  static const SIcon bell = SIcon(picture: 'assets/icons/bell.svg');
  static const SIcon bookmark = SIcon(picture: 'assets/icons/bookmark.svg');
  static const SIcon bookmarkFill = SIcon(picture: 'assets/icons/bookmarkFill.svg');
  static const SIcon car = SIcon(picture: 'assets/icons/car.svg');
  static const SIcon check = SIcon(picture: 'assets/icons/check.svg');
  static const SIcon clipboard = SIcon(picture: 'assets/icons/clipboard.svg');
  static const SIcon coupon = SIcon(picture: 'assets/icons/coupon.svg');
  static const SIcon gender = SIcon(picture: 'assets/icons/gender.svg');
  static const SIcon home = SIcon(picture: 'assets/icons/home.svg');

  static const SIcon manager = SIcon(picture: 'assets/icons/manager.svg');
  static const SIcon megaphone = SIcon(picture: 'assets/icons/megaphone.svg');
  static const SIcon person = SIcon(picture: 'assets/icons/person.svg');
  static const SIcon personFill = SIcon(picture: 'assets/icons/person_fill.svg');
  static const SIcon search = SIcon(picture: 'assets/icons/search.svg');
  static const SIcon settings = SIcon(picture: 'assets/icons/settings.svg');
  static const SIcon shower = SIcon(picture: 'assets/icons/shower.svg');
  static const SIcon soccer = SIcon(picture: 'assets/icons/soccer.svg');
  static const SIcon star = SIcon(picture: 'assets/icons/star.svg');
  static const SIcon success = SIcon(picture: 'assets/icons/success.svg');
  static const SIcon toilet = SIcon(picture: 'assets/icons/toilet.svg');
  static const SIcon more = SIcon(picture: 'assets/icons/more.svg');
  static const SIcon moreClose = SIcon(picture: 'assets/icons/moreClose.svg');

  static const SIcon logo = SIcon(picture: 'assets/icons/logo.svg');
  static const SIcon lineLogo = SIcon(picture: 'assets/icons/line_logo.svg');
  static const SIcon kakaoLogo = SIcon(picture: 'assets/icons/kakao_logo.svg');

  static const SIcon kakaoPay = SIcon(picture: 'assets/icons/kakao_pay.svg');
  static const SIcon linePay = SIcon(picture: 'assets/icons/line_pay.svg');
  static const SIcon applePay = SIcon(picture: 'assets/icons/apple_pay.svg');


}

class _SvgIconBuilder {

  final SIcon sIcon;

  _SvgIconBuilder({required this.sIcon});

  SvgIcon build(SvgIconStyle? style) {
    return SvgIcon.privateConstructor(SvgPicture.asset(sIcon.picture,
        width: style?.width,
        height: style?.height,
        fit: style?.fit ?? BoxFit.contain,
        colorFilter: style == null || style.color == null ? null : ColorFilter.mode(style.color!, style.blendMode ?? BlendMode.srcIn),
    ));
  }

}