
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/coupon_calculator.dart';
import 'package:groundjp/component/open_app.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/component/snack_bar.dart';
import 'package:groundjp/domain/coupon/coupon.dart';
import 'package:groundjp/domain/coupon/coupon_result.dart';
import 'package:groundjp/domain/field/address.dart';
import 'package:groundjp/domain/order/order_result.dart';
import 'package:groundjp/domain/order/order_simp.dart';
import 'package:groundjp/widgets/component/custom_container.dart';
import 'package:groundjp/widgets/form/detail_default_form.dart';
import 'package:groundjp/widgets/pages/poppages/coupon_list_page.dart';
import 'package:groundjp/widgets/pages/poppages/order_complete_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:skeletonizer/skeletonizer.dart';

class OrderWidget extends StatefulWidget {

  final int matchId;

  const OrderWidget({super.key, required this.matchId});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {

  late OrderSimp orderSimp;
  Coupon? _coupon;
  bool _loading = false;
  bool _policy1 = false;
  bool _policy2 = false;

  void _policy1Toggle() {
    setState(() {
      _policy1 = !_policy1;
    });
  }
  void _policy2Toggle() {
    setState(() {
      _policy2 = !_policy2;
    });
  }
  void _setCoupon(Coupon? coupon) {
    print('쿠폰 선택함 : ${coupon?.title}');
    CustomSnackBar.message(context, '쿠폰이 적용되었습니다.');
    setState(() {
      _coupon = coupon;
    });
  }

  submit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return OrderCompleteWidget(orderResult: OrderResult(20000, CouponResult('첫결제 이벤트 50% 할인', 10000), 10000, 90000),);
    }, fullscreenDialog: true));
  }
  
  @override
  void initState() {
    orderSimp = OrderSimp(
      title: '경기장 이름 경기장 이름 경기장 이름',
      matchHour: 2,
      totalPrice: 20000, 
      address: Address('서울 마포구 독막로 2', Region.BUNKYO, 0, 0),
      matchDate: DateTime.now(),
      cash: 100000, 
      couponCount: 2,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('경기신청'),
        centerTitle: true,
      ),
      body: Skeletonizer(
        enabled: _loading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32,),
                DetailDefaultFormWidget(
                  title: '구장정보',
                  child: CustomContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    radius: BorderRadius.circular(10),
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderSimp.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                        const SizedBox(height: 2,),
                        GestureDetector(
                          onTap: () {
                            OpenApp().openMaps(lat: orderSimp.address.lat, lng: orderSimp.address.lng);
                          },
                          child: Text(orderSimp.address.address,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ),
                const SizedBox(height: 25,),
                DetailDefaultFormWidget(
                    title: '경기시간',
                    child: CustomContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      radius: BorderRadius.circular(10),
                      child: Text(
                        '${DateFormat('yyyy년 M월 d일 EEEE HH:mm', 'ko_KR').format(orderSimp.matchDate)} ~ ${DateFormat('HH:mm').format(orderSimp.matchDate.add(Duration(hours: orderSimp.matchHour)))}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                            color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 25,),
                DetailDefaultFormWidget(
                    title: '캐시',
                    child: CustomContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      radius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Skeleton.ignore(
                            child: Container(
                              width: 3,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).colorScheme.onPrimary
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('쿠폰',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return CouponListWidget(
                                            readOnly: false, onPressed: _setCoupon,
                                          );
                                        },));
                                      },
                                      child: Row(
                                        children: [
                                          Text(_coupon == null ? '${orderSimp.couponCount}개 보유' : _coupon!.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                                color: Theme.of(context).colorScheme.primary
                                            ),
                                          ),
                                          Skeleton.ignore(
                                            child: Icon(Icons.arrow_forward_ios_rounded,
                                              color: Theme.of(context).colorScheme.primary,
                                              size: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('캐시',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                          color: Theme.of(context).colorScheme.primary
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(AccountFormatter.format(orderSimp.cash),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                              color: Theme.of(context).colorScheme.primary
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Skeleton.ignore(
                                          child: Text('충전',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.secondary,
                                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 25,),
                DetailDefaultFormWidget(
                    title: '약관',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          radius: BorderRadius.circular(10),
                          child: Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이것만은 꼭!',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                                ),
                              ),
                              Skeleton.ignore(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("""
플랩 매치는 10명 이상 모여서 진행해요. 매치 시작 90분 전까지 팀 구성이 어려우면, 취소 안내 드립니다. 

출발 전에 카카오톡 알림을 꼭 확인해 주세요.  

참여가 어려울 경우, 마이 플랩에서 미리 취소를 해주세요. 무단 불참하거나 매치 시작 90분 이내에 취소하면 패널티를 받을 수 있습니다. 

갑작스러운 인원 부족으로 경기 진행에 문제가 생길 수 있기 때문에 플랩에서는 시간 약속을 중요한 매너로 보고 있습니다.  

반드시 풋살화(TF) 혹은 운동화를 신어 주세요. 축구화를 착용하면 다른 사람이 크게 다칠 수 있어 참여를 제한하고 있습니다. 

매너 점수가 내려가는 점도 유의해 주세요. 레벨 데이터로 팀을 나누면 막상막하로 더 재밌을 거예요. 

레벨 차이가 크거나 늦는 친구가 있으면, 서로 다른 팀이 될 수 있습니다.  

이용자 부주의로 시설을 파손하면, 손해배상을 청구할 수 있어요. 이 점 주의 부탁 드립니다.  

안전상의 이유로 고등학생 이상 (만 16세) 참여 가능하며 만 16세 미만인 경우 현장에서 귀가 조치 될 수 있습니다.
                                """,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _policy1Toggle,
                              child: Icon(
                                Icons.check_box_rounded,
                                size: 23,
                                color: _policy1
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Color(0xFFDDDDDD),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('동의합니다',
                                style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        CustomContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          radius: BorderRadius.circular(10),
                          child: Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('부상의 위험',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                                ),
                              ),
                              Skeleton.ignore(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("""
모두의 풋볼은 상대를 배려하고, 나를 지키는 안전한 플레이를 권장합니다.  

거친 플레이를 하는 참가자에게 매너 카드를 발급하여 안전하고 즐거운 매치 문화를 만들어 나갑니다.  

다른 사람에게 피해를 끼치는 경우 이용이 정지될 수 있습니다.  

축구, 풋살 등 부상의 위험성이 내재된 경기 규칙 안에서 발생한 부상 대부분이 개인에게 책임이 있음을 판단하고 있습니다.
                                """,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _policy2Toggle,
                              child: Icon(
                                Icons.check_box_rounded,
                                size: 23,
                                color: _policy2
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Color(0xFFDDDDDD),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('동의합니다',
                                style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 25,),
                DetailDefaultFormWidget(
                    title: '결제정보',
                    child: CustomContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      radius: BorderRadius.circular(10),
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('이용금액',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                              Text(AccountFormatter.format(orderSimp.totalPrice),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                              )
                            ],
                          ),
                          if (_coupon != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_coupon!.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                        color: Theme.of(context).colorScheme.primary
                                    ),
                                  ),
                                  Text(AccountFormatter.format(-1 * CouponCalculator.discount(orderSimp.totalPrice, (_coupon!.per / 100))),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                  )
                                ],
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 25, bottom: 15),
                            width: double.infinity,
                            height: 1,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('결제금액',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                              Text(_coupon == null
                                ? AccountFormatter.format(orderSimp.totalPrice)
                                : AccountFormatter.format(CouponCalculator.total(orderSimp.totalPrice, (_coupon!.per / 100))),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                                    color: Theme.of(context).colorScheme.primary
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 36,),
                GestureDetector(
                  onTap: () => submit(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.onPrimary
                    ),
                    child: Center(
                      child: Text('결제하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
