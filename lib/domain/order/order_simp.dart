
import 'package:groundjp/domain/field/address.dart';

class OrderSimp {

  final String title;
  final int totalPrice;
  final int matchHour;

  final Address address;
  final DateTime matchDate;

  final int cash;
  final int couponCount;

  OrderSimp.fromJson(Map<String, dynamic> json):
    title = json['title'],
    matchHour = json['matchHour'],
    totalPrice = json['totalPrice'],
    address = Address.fromJson(json['address']),
    matchDate = DateTime.parse(json['matchDate']),
    cash = json['cash'],
    couponCount = json['couponCount'];

  OrderSimp({required this.title, required this.matchHour, required this.totalPrice, required this.address, required this.matchDate, required this.cash, required this.couponCount});


}