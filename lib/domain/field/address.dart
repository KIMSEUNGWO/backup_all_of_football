
import 'package:groundjp/component/region_data.dart';

class Address {
   
  final String address;
  final Region region;
  final double lat;
  final double lng;

  Address.fromJson(Map<String, dynamic> json):
    address = json['address'],
    region = Region.findByName(json['region']),
    lat = json['lat'],
    lng = json['lng'];

  Address(this.address, this.region, this.lat, this.lng);
}