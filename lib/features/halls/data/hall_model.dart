import 'package:dakeh_service_provider/features/halls/data/image_model.dart';

class Hall {
  late int id;
  late String nameAR;
  late String nameEN;
  late int providerID;
  late dynamic billiardPrice;
  late dynamic balootPrice;
  late dynamic chessPrice;
  late String openTime;
  late String closeTime;
  late String place;
  late double lat;
  late double long;
  late String phone;
  late bool smokingAllowed;
  bool? billiardActive;
  bool? balootActive;
  bool? chessActive;
  late bool hallActive;
  List<HallImage> images = [];

  Hall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAR = json['name_ar'];
    nameEN = json['name_en'];
    providerID = int.parse(json['provider_id']);
    balootPrice = json['baloot_price_per_one'];
    billiardPrice = json['billiard_price_per_one'];
    chessPrice = json['chess_price_per_one'];
    openTime = json['start_time'];
    phone = json['phone'];
    closeTime = json['close_time'];
    place = json['place'];
    lat = double.parse(json['latitude']);
    long = double.parse(json['longitude']);
    smokingAllowed = json['smoking_allowed'] == "1" ? true : false;
    if ((json['images'] as List).isNotEmpty) {
      for (var element in (json['images'] as List)) {
        images.add(HallImage.fromJson(element));
      }
    }
    billiardActive = json['billiard'] != null
        ? json['billiard'] == '1'
            ? true
            : false
        : null;
    chessActive = json['chess'] != null
        ? json['chess'] == '1'
            ? true
            : false
        : null;
    balootActive = json['baloot'] != null
        ? json['baloot'] == '1'
            ? true
            : false
        : null;
    hallActive = balootActive! && chessActive! && balootActive!;
  }
}
