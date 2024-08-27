
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/match_service.dart';
import 'package:groundjp/component/account_format.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/open_app.dart';
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/enums/field_enums.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/field/address.dart';
import 'package:groundjp/domain/field/field.dart';
import 'package:groundjp/domain/field/field_data.dart';
import 'package:groundjp/widgets/component/bottom_bar_widget.dart';
import 'package:groundjp/widgets/component/image_detail_view.dart';
import 'package:groundjp/widgets/form/detail_field_form.dart';
import 'package:groundjp/widgets/form/detail_match_form.dart';
import 'package:groundjp/widgets/form/detail_role_form.dart';
import 'package:groundjp/widgets/form/field_image_preview.dart';
import 'package:groundjp/widgets/pages/poppages/field_detail_page.dart';
import 'package:groundjp/widgets/pages/poppages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:groundjp/domain/match/match.dart';
import 'package:intl/intl.dart';

import 'package:skeletonizer/skeletonizer.dart';

class MatchDetailWidget extends StatefulWidget {

  final int matchId;

  const MatchDetailWidget({super.key, required this.matchId});

  @override
  State<MatchDetailWidget> createState() => _MatchDetailWidgetState();
}

class _MatchDetailWidgetState extends State<MatchDetailWidget> {
  
  Match? match;
  bool _loading = true;
  bool _disabled = false;

  _fetchMatch() async {
    final response = await MatchService.getMatch(matchId: widget.matchId);
    ResultCode result = response.resultCode;
    if (result == ResultCode.OK) {
      setState(() {
        match = Match.fromJson(response.data);
        _disabled = match!.alreadyJoin;
        _loading = false;
      });
    } else if (result == ResultCode.MATCH_NOT_EXISTS) {
      Alert.of(context).message(
        message: '존재하지 않는 경기입니다..',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
  }
  // _fetchMatch() async {
  //   match = Match(1, DateTime.now(), null, 6, 3, 2, MatchStatus.OPEN,
  //       Field(2, '안양대학교 SKY 풋살파크 C구장',
  //           Address('서울 마포구 독막로 2', Region.TAITO, 0, 0),
  //           FieldData(Parking.FREE, Shower.Y, Toilet.N, 123, 40, 10000),
  //           false,
  //           '뭐가 없고~ 뭐가 있고~',
  //           [
  //             Image.asset('assets/구장예제사진1.jpeg', fit: BoxFit.fill,),
  //             Image.asset('assets/구장예제사진2.jpg', fit: BoxFit.fill,),
  //             Image.asset('assets/구장예제사진3.jpg', fit: BoxFit.fill,)
  //           ])
  //   );
  // }

  submit() async {

  }
  
  @override
  void initState() {
    _fetchMatch();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Skeletonizer(
          enabled: _loading,
          child: _loading ? const Text('') : Text(match!.field.title),
        ),
      ),
      body: Skeletonizer(
        enabled: _loading,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlider(
                  images: _loading ? [] : match!.field.images.map((image) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ImageDetailView(image: image)
                                ,fullscreenDialog: true
                            ));
                      },
                      child: image,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 19,),
                Text(_loading ? '' :  DateFormat('M월 d일 EEEE HH:mm', 'ko_KR').format(match!.matchDate),
                  style: TextStyle(
                    color: const Color(0xFF686868),
                    fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 5,),
                Text(_loading ? '' : match!.field.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.displayMedium!.fontSize
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!_loading) {
                      OpenApp().openMaps(lat: match!.field.address.lat, lng: match!.field.address.lng);
                    }
                  },
                  child: Text(_loading ? '' : match!.field.address.address,
                    style: TextStyle(
                      color: const Color(0xFF686868),
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline
                    ),
                  ),
                ),


                const SizedBox(height: 35,),
                MatchDetailFormWidget(match: match),
                const SizedBox(height: 30,),
                FieldDetailFormWidget(field: match?.field),
                const SizedBox(height: 30,),
                const Skeleton.ignore(
                  child: DetailRoleFormWidget(),
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                      child: Text('이 구장에서 다음 경기를 찾으시나요?',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        if (!_loading) {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return FieldDetailWidget(fieldId: match!.field.fieldId, field: match!.field,);
                            },)
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text('더보기',
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary
                            ),
                          ),
                          const SizedBox(width: 2,),
                          Icon(Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40,),


              ]
            ),
          ),
        ),
      ),
      bottomNavigationBar: Skeletonizer(
        enabled: _loading,
        child: CustomBottomBar(
          height: 80,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('신청하고 게임을 즐겨보세요',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(_loading ? '' : AccountFormatter.format(match!.matchHour * match!.field.fieldData.hourPrice),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                        ),
                      ),
                      Skeleton.ignore(
                        child: Text(_loading ? '' : ' / ${match!.matchHour}시간',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(width: 32,),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_disabled) return;
                    submit();
                    if (!_loading) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return OrderWidget(matchId: match!.matchId);
                      },));
                    }
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _disabled
                        ? const Color(0xFFD9D9D9)
                        : Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Center(
                      child: Skeleton.ignore(
                        child: Text(!_loading && match!.alreadyJoin ? '신청완료' :'신청하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.displaySmall!.fontSize
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

