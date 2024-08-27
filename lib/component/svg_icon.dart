import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:skeletonizer/skeletonizer.dart';

class SvgIcon extends StatelessWidget {

  final Skeleton svgPicture;

  SvgIcon.privateConstructor(SvgPicture svgPicture):
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
  SIcon({required this.picture});

  static SIcon pen = SIcon(picture: 'assets/icons/pen.svg');

  static SIcon bell = SIcon(picture: 'assets/icons/bell.svg');
  static SIcon bookmark = SIcon(picture: 'assets/icons/bookmark.svg');
  static SIcon bookmarkFill = SIcon(picture: 'assets/icons/bookmarkFill.svg');
  static SIcon car = SIcon(picture: 'assets/icons/car.svg');
  static SIcon check = SIcon(picture: 'assets/icons/check.svg');
  static SIcon clipboard = SIcon(picture: 'assets/icons/clipboard.svg');
  static SIcon coupon = SIcon(picture: 'assets/icons/coupon.svg');
  static SIcon gender = SIcon(picture: 'assets/icons/gender.svg');
  static SIcon home = SIcon(picture: 'assets/icons/home.svg');

  static SIcon manager = SIcon(picture: 'assets/icons/manager.svg');
  static SIcon megaphone = SIcon(picture: 'assets/icons/megaphone.svg');
  static SIcon person = SIcon(picture: 'assets/icons/person.svg');
  static SIcon personFill = SIcon(picture: 'assets/icons/person_fill.svg');
  static SIcon search = SIcon(picture: 'assets/icons/search.svg');
  static SIcon settings = SIcon(picture: 'assets/icons/settings.svg');
  static SIcon shower = SIcon(picture: 'assets/icons/shower.svg');
  static SIcon soccer = SIcon(picture: 'assets/icons/soccer.svg');
  static SIcon star = SIcon(picture: 'assets/icons/star.svg');
  static SIcon success = SIcon(picture: 'assets/icons/success.svg');
  static SIcon toilet = SIcon(picture: 'assets/icons/toilet.svg');
  static SIcon more = SIcon(picture: 'assets/icons/more.svg');
  static SIcon moreClose = SIcon(picture: 'assets/icons/moreClose.svg');

  static SIcon logo = SIcon(picture: 'assets/icons/logo.svg');
  static SIcon lineLogo = SIcon(picture: 'assets/icons/line_logo.svg');
  static SIcon kakaoLogo = SIcon(picture: 'assets/icons/kakao_logo.svg');

  static SIcon kakaoPay = SIcon(picture: 'assets/icons/kakao_pay.svg');
  static SIcon linePay = SIcon(picture: 'assets/icons/line_pay.svg');
  static SIcon applePay = SIcon(picture: 'assets/icons/apple_pay.svg');


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