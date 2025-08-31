import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/reservations/data/rate_details_model.dart';

class Reservation {
  late int id;
  late String hallNameAR;
  late String hallNameEN;
  late String hallNameProvider;
  late String hallAddress;
  late String hallImage;
  late int hallGamePrice;
  late int hallID;
  late int gameID;
  late ReservationsStatus status;
  List<UserData> users = [];
  List<RateDetails> rateClient = [];
  RateDetails? rateProvider;

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hallNameAR = json['hall_name_ar'];
    hallNameEN = json['hall_name_en'];
    hallNameProvider = json['hall_provider_name'];
    hallAddress = json['hall_place'];
    hallImage = json['hall_img'];
    hallGamePrice = json['hall_game_price_per_one'] == null
        ? 0
        : int.parse(json['hall_game_price_per_one']);
    hallID = int.parse(json['hall']);
    gameID = int.parse(json['game_type']);
    status = getReservationStatus(int.parse(json['status']));
    if (json['users'] != null) {
      for (var element in json['users']) {
        users.add(UserData.fromJson(element));
      }
    }
    if (json['rate_from_client'] != null) {
      rateClient = (json['rate_from_client'] as List)
          .map((e) => RateDetails.fromJson(e))
          .toList();
    }
    rateProvider = json['rate_from_provider'] != null
        ? RateDetails.fromJson(json['rate_from_provider'])
        : null;
  }
}

enum ReservationsStatus {
  notCompleted,
  providerApproval,
  awaitPayment,
  reservedSuccessfully,
  canceled
}

ReservationsStatus getReservationStatus(int statusID) {
  switch (statusID) {
    case (1):
      return ReservationsStatus.notCompleted;
    case (2):
      return ReservationsStatus.providerApproval;
    case (3):
      return ReservationsStatus.awaitPayment;
    default:
      return ReservationsStatus.reservedSuccessfully;
  }
}
