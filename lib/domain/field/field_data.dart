
import 'package:groundjp/domain/enums/field_enums.dart';

class FieldData {

  final Parking parking;
  final Shower shower;
  final Toilet toilet;
  final int sizeX;
  final int sizeY;
  final int hourPrice;

  FieldData.fromJson(Map<String, dynamic> json):
    parking = Parking.valueOf(json['parking']),
    shower = Shower.valueOf(json['shower']),
    toilet = Toilet.valueOf(json['toilet']),
    sizeX = json['sizeX'],
    sizeY = json['sizeY'],
    hourPrice = json['hourPrice'];

  FieldData(this.parking, this.shower, this.toilet, this.sizeX, this.sizeY,
      this.hourPrice);
}