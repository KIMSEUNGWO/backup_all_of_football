
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/component/svg_icon.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:groundjp/widgets/pages/poppages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWidget extends ConsumerWidget {
  const LoginWidget({super.key});

  _onTryLogin(BuildContext context, WidgetRef ref, SocialProvider provider) async {
    final result = await ref.read(loginProvider.notifier).login(context, ref, provider);
    print('result : ${result.resultCode}');
    if (context.mounted) {
      Navigator.pop(context);
    }
    if (result.resultCode == ResultCode.OK) {
      print('로그인 성공');
    } else  if (result.resultCode == ResultCode.REGISTER) {
      print('회원가입 시도');
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterWidget(social: result.data,)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 170, bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: SvgIcon.asset(
              sIcon: SIcon.logo,
              style: SvgIconStyle(
                width: 300
              )
            )),

            Column(
              children: [
                _SocialBtn(
                  title: '라인으로 계속하기',
                  fontColor: Colors.white,
                  color: const Color(0xFF08BF5B),
                  sIcon: SIcon.lineLogo,
                  onPressed: () {
                    _onTryLogin(context, ref, SocialProvider.LINE);
                  },
                ),
                const SizedBox(height: 12,),
                _SocialBtn(
                  title: '카카오로 계속하기',
                  fontColor: const Color(0xFF181602),
                  color: const Color(0xFFF3DA01),
                  sIcon: SIcon.kakaoLogo,
                  onPressed: () {
                    _onTryLogin(context, ref, SocialProvider.KAKAO);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF666666).withOpacity(0.5)
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text('다른 계정으로 계속하기'),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF666666).withOpacity(0.5)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _SmallSocialBtn(
                  icon: const Icon(Icons.apple, color: Colors.white, size: 25,),
                  color: const Color(0xFF434343),
                  onPressed: () {
                    _onTryLogin(context, ref, SocialProvider.APPLE);
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {

  final String title;
  final Color color;
  final Color fontColor;
  final SIcon sIcon;
  final Function() onPressed;

  const _SocialBtn({required this.title, required this.color, required this.fontColor, required this.sIcon, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Row(
          children: [
            SvgIcon.asset(sIcon: sIcon, style: SvgIconStyle(
              width: 20, height: 20, color: fontColor
            )),
            Expanded(
              child: Center(
                child: Text(title,
                  style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.w700,
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SmallSocialBtn extends StatelessWidget {
  
  final Icon icon;
  final Color color;
  final Function() onPressed;

  const _SmallSocialBtn({required this.icon, required this.color, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}


