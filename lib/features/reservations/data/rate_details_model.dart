
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';

class RateDetails {
  late int id;
  late int reserveID;
  late int providerID;
  List<PlayerRateDetails> players = [];

  RateDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reserveID = int.parse(json['reserve_id']);
    providerID = int.parse(json['provider_id']);
    players = (json['players_rate'] as List)
        .map(
          (e) => PlayerRateDetails.fromJson(e),
        )
        .toList();
  }
}

class PlayerRateDetails {
  late int id;
  late UserData user;
  late double playerRateNum;
  String? playerRateText;

  PlayerRateDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = UserData.fromJson(json['user_id']);
    playerRateNum = double.parse(json['num_rate']);
    playerRateText = json['text_rate'];
  }
}
