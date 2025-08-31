
class User {
  late String token;
  late UserData data;

  User.fromJson(Map<String, dynamic> json) {
    token = json['access_token'];
    data = UserData.fromJson(json['provider']);
  }

  Map<String, dynamic> toMap() {
    return {
      'access_token': token,
      'provider': data.toMap(),
    };
  }
}

class UserData {
  late int id;
  late String name;
  late String phone;
  late String email;
  late int cityID;
  late String image;
  String? iban;
  String? bank;
  String? level;
  String? highestLevel;
  String? playedYears;
  String? matchesPerMonth;
  String? championshipsNum;
  String? favGame;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['mobile'];
    cityID = json['city_id'] is String
        ? int.parse(json['city_id'])
        : json['city_id'];
    image = json['img'];
    bank = json['bank'];
    iban = json['iban'];
    level = json['level'];
    highestLevel = json['highest_level_competed_at'];
    playedYears = json['played_years'];
    matchesPerMonth = json['matches_per_month'];
    championshipsNum = json['championships_num'];
    favGame = json['favorite_game'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': phone,
      'city_id': cityID,
      'img': image,
      'bank': bank,
      'iban': iban,
    };
  }
}
