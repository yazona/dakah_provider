import 'dart:developer';

import 'package:dakeh_service_provider/core/api/dio_helper.dart';
import 'package:dakeh_service_provider/core/api/end_points.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/features/reservations/data/rate_player_model.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_states.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/reservation_model.dart';

class ReservationsCubit extends Cubit<ReservationsStates> {
  ReservationsCubit() : super(ReservationsInitState());

  static ReservationsCubit get(context) => BlocProvider.of(context);

  bool currentSelected = true;

  List<Reservation> reservationsList = [];
  int currentReservationPageIndex = 1;
  bool reservationsHasMore = true;

  void getCurrentReservations({bool fromPagination = false}) async {
    currentSelected = true;
    if (!fromPagination) {
      currentReservationPageIndex = 1;
      reservationsHasMore = true;
      reservationsList.clear();
      emit(GetReservationsLoadingState());
    }
    int limit = 20;
    await DioHelper.getData(
      endPoint:
          '${EndPoints.getCurrentReservations}?page=$currentReservationPageIndex',
      token: AppConstants.user!.token,
    ).then((value) {
      log(value.data.toString());
      final List<Reservation> newReservations = (value.data['data'] as List)
          .map((e) => Reservation.fromJson(e))
          .toList();
      if (fromPagination) {
        currentReservationPageIndex++;
      }
      if (newReservations.length < limit) {
        reservationsHasMore = false;
      }
      reservationsList.addAll(newReservations);
      emit(GetReservationsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {
      }
      emit(GetReservationsErrorState());
    });
  }

  int previousReservationsIndex = 1;

  void getAwaitPaymentReservations({bool fromPagination = false}) async {
    currentSelected = false;
    if (!fromPagination) {
      previousReservationsIndex = 1;
      reservationsHasMore = true;
      reservationsList.clear();
      emit(GetReservationsLoadingState());
    }
    int limit = 20;
    await DioHelper.getData(
      endPoint:
          '${EndPoints.getPreviousReservations}?page=$previousReservationsIndex',
      token: AppConstants.user!.token,
    ).then((value) {
      final List<Reservation> newReservations = (value.data['data'] as List)
          .map((e) => Reservation.fromJson(e))
          .toList();
      if (fromPagination) {
        previousReservationsIndex++;
      }
      if (newReservations.length < limit) {
        reservationsHasMore = false;
      }
      reservationsList.addAll(newReservations);
      emit(GetReservationsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(GetReservationsErrorState());
    });
  }

  late Reservation reservationDetails;

  void getReservationsDetails({required int reservationID}) {
    emit(GetReservationDetailsLoadingState());
    DioHelper.getData(
            endPoint: '${EndPoints.getReservationDetails}/$reservationID',
            token: AppConstants.user!.token)
        .then((value) {
      reservationDetails = Reservation.fromJson(value.data['data']);
      emit(GetReservationDetailsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {
      }
      emit(GetReservationDetailsErrorState());
    });
  }

  void acceptReservation({required int reservationID}) {
    emit(AcceptReservationLoadingState());
    DioHelper.postData(
      endPoint: '${EndPoints.acceptReservation}/$reservationID',
      token: AppConstants.user!.token,
    ).then((value) {
      emit(AcceptReservationSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(AcceptReservationErrorState());
    });
  }

  List<RatePlayer> playersRate = [];

  void addRatePlayerToList({
    required int id,
    required double rateNum,
    String? rateText,
  }) {
    var player =
        RatePlayer(playerID: id, rateCount: rateNum, rateText: rateText);
    playersRate.add(player);
    emit(RatePlayerState());
  }

  void sendPlayersRate({required int reservationID}) {
    emit(RatePlayersLoadingState());
    FormData formData = FormData.fromMap({});
    for (int i = 0; i < playersRate.length; i++) {
      formData.fields.add(MapEntry(
          'users_rate[$i][user_id]', playersRate[i].playerID.toString()));
      formData.fields.add(MapEntry(
          'users_rate[$i][num_rate]', playersRate[i].rateCount.toString()));
      formData.fields.add(MapEntry(
          'users_rate[$i][text_rate]', playersRate[i].rateText.toString()));
    }
    DioHelper.postData(
      endPoint: '${EndPoints.ratePlayers}/$reservationID',
      token: AppConstants.user!.token,
      data: formData,
    ).then((value) {
      emit(RatePlayersSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(RatePlayersErrorState());
    });
  }
}
