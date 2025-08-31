import 'dart:io';
import 'package:dakeh_service_provider/core/api/dio_helper.dart';
import 'package:dakeh_service_provider/core/api/end_points.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/features/halls/data/hall_model.dart';
import 'package:dakeh_service_provider/features/halls/data/image_model.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HallsCubit extends Cubit<HallsStates> {
  HallsCubit() : super(HallsInitState());

  static HallsCubit get(context) => BlocProvider.of(context);

  int hallsPageIndex = 1;
  bool hallsHasMore = true;
  List<Hall> halls = [];

  // GlobalKey<ScaffoldState> hallsScreenScaffoldKey = GlobalKey<ScaffoldState>();

  void getHalls({
    bool fromPagination = false,
  }) {
    if (!fromPagination) {
      halls.clear();
      hallsPageIndex = 1;
      hallsHasMore = true;
      emit(GetHallsLoadingState());
    }
    int limit = 20;
    DioHelper.getData(
      endPoint: '${EndPoints.getHalls}?page=$hallsPageIndex',
      token: AppConstants.user!.token,
    ).then((value) {
      debugPrint(value.data.toString());
      final List<Hall> newList =
          (value.data['data'] as List).map((e) => Hall.fromJson(e)).toList();
      if (fromPagination) hallsPageIndex++;
      if (newList.length < limit) hallsHasMore = false;
      halls.addAll(newList);
      emit(GetHallsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {
      }
      emit(GetHallsErrorState());
    });
  }

  List<File> hallImages = [];

  void pickHallImages() {
    ImagePicker().pickMultiImage().then((value) {
      if (value.isNotEmpty) {
        for (var element in value) {
          hallImages.add(File(element.path));
          emit(PickHallImagesState());
        }
      }
    }).catchError((error) {});
  }

  void deleteHallImage(index) {
    hallImages.removeAt(index);
    emit(PickHallImagesState());
  }

  bool allowSmoking = false;

  void changeAllowSmoking(value) {
    allowSmoking = value;
    emit(AllowSmokingState());
  }

  void addNewHall({
    required String nameAR,
    required String nameEN,
    required String billiardPrice,
    required String balootPrice,
    required String chessPrice,
    required String startTime,
    required String endTime,
    required String address,
    required String phone,
    required double lat,
    required double long,
  }) async {
    emit(AddNewHallLoadingState());
    FormData formData = FormData.fromMap({
      'name_ar': nameAR,
      'name_en': nameEN,
      'billiard_price': billiardPrice,
      'baloot_price': balootPrice,
      'chess_price': chessPrice,
      'start_time': startTime,
      'close_time': endTime,
      'phone': phone,
      'place': address,
      'latitude': lat,
      'longitude': long,
      'smoking_allowed': allowSmoking ? '1' : '0',
    });
    for (int i = 0; i < hallImages.length; i++) {
      formData.files.add(
        MapEntry(
          'images[$i]',
          await MultipartFile.fromFile(hallImages[i].path,
              filename: hallImages[i].path.split('/').last),
        ),
      );
    }
    DioHelper.postData(
            endPoint: EndPoints.addNewHall,
            data: formData,
            token: AppConstants.user!.token)
        .then((value) {
      hallImages.clear();
      userPickedLocation = null;
      userPickedLocationMarker.clear();
      emit(AddNewHallSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(AddNewHallErrorState());
    });
  }

  late Hall hallInfo;

  Future<void> getHallInfo({required int hallID}) async {
    emit(GetHallInfoLoadingState());
    await DioHelper.getData(
            endPoint: '${EndPoints.getHallInfo}/$hallID',
            token: AppConstants.user!.token)
        .then((value) {
      hallInfo = Hall.fromJson(value.data['data']);
      emit(GetHallInfoSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(GetHallInfoErrorState());
    });
  }

  int smoothPageIndex = 0;

  void changeSmoothPageIndex(int value) {
    smoothPageIndex = value;
  }

  void deleteHall({required int hallID}) {
    emit(DeleteHallLoadingState());
    DioHelper.postData(
      endPoint: '${EndPoints.deleteHall}/$hallID',
      token: AppConstants.user!.token,
    ).then((value) {
      emit(DeleteHallSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(DeleteHallErrorState());
    });
  }

  bool balootBooking = false;
  bool chessBooking = false;
  bool billiardBooking = false;

  void changeBalootBookingValue(bool value) {
    balootBooking = value;
    emit(ChangeSwitchValueState());
  }

  void changeChessBookingValue(bool value) {
    chessBooking = value;
    emit(ChangeSwitchValueState());
  }

  void changeBilliardBookingValue(bool value) {
    billiardBooking = value;
    emit(ChangeSwitchValueState());
  }

  Future<void> changeGameStatus(
      {required int hallID, required int gameID, required bool status}) async {
    try {
      emit(GetHallInfoLoadingState());
      await DioHelper.postData(
          endPoint: '${EndPoints.changeGameStatus}/$hallID',
          token: AppConstants.user!.token,
          data: {
            'game': gameID,
            'status': status ? 1 : 0,
          });
      await getHallInfo(hallID: hallID);
      emit(GetHallInfoSuccessState());
    } catch (error) {
      emit(GetHallInfoErrorState());
    }
  }

  void editHall(
      {required String nameAR,
      required String nameEN,
      required int billiardPrice,
      required int balootPrice,
      required int chessPrice,
      required String startTime,
      required String endTime,
      required String address,
      required String phone,
      required int hallID,
      required LatLng location}) async {
    emit(EditHallLoadingState());
    FormData formData = FormData.fromMap({
      'name_ar': nameAR,
      'name_en': nameEN,
      'billiard_price': billiardPrice,
      'baloot_price': balootPrice,
      'chess_price': chessPrice,
      'start_time': startTime,
      'close_time': endTime,
      'place': address,
      'phone': phone,
      'latitude': userPickedLocation?.latitude ?? location.latitude,
      'longitude': userPickedLocation?.longitude ?? location.longitude,
      'smoking_allowed': allowSmoking ? '1' : '0',
      'billiard': billiardBooking ? '1' : '0',
      'baloot': balootBooking ? '1' : '0',
      'chess': chessBooking ? '1' : '0',
    });
    if (editHallImages.isNotEmpty) {
      for (int i = 0; i < editHallImages.length; i++) {
        formData.files.add(MapEntry(
          'images[$i]',
          await MultipartFile.fromFile(editHallImages[i].path,
              filename: editHallImages[i].path.split('/').last),
        ));
      }
    }
    if (deletedHallImages.isNotEmpty) {
      for (int i = 0; i < deletedHallImages.length; i++) {
        formData.fields.add(MapEntry(
          'deleted_imgs[$i]',
          '${deletedHallImages[i]}',
        ));
      }
    }
    DioHelper.postData(
            endPoint: '${EndPoints.editHall}/$hallID',
            data: formData,
            token: AppConstants.user!.token)
        .then((value) {
      hallImages.clear();
      userPickedLocationMarker.clear();
      userPickedLocation = null;
      editHallImages.clear();
      deletedHallImages.clear();
      emit(EditHallSuccessState());
    }).catchError((error) {
      if (error is DioException) {
      } else {}
      emit(EditHallErrorState());
    });
  }

  List<File> editHallImages = [];

  void deleteNewImagesOnEditHall(int index) {
    editHallImages.removeAt(index);
    emit(DeleteImageState());
  }

  void pickHallImageOnEditHall() {
    ImagePicker().pickMultiImage(limit: 3).then((value) {
      if (value.isNotEmpty) {
        for (var element in value) {
          editHallImages.add(File(element.path));
        }
        emit(PickHallImagesState());
      }
    });
  }

  List<int> deletedHallImages = [];

  void deleteNetworkImage(List<HallImage> images, int index) {
    deletedHallImages.add(images[index].id);
    images.removeAt(index);
    emit(DeleteImageState());
  }

  late bool hallActive;

  void changeHallActivation(int hallID, {required int activeStatus}) {
    emit(GetHallInfoLoadingState());
    DioHelper.postData(
        endPoint: '${EndPoints.changeHallActivation}/$hallID',
        token: AppConstants.user!.token,
        data: {'status': activeStatus}).then((value) {
      getHallInfo(hallID: hallID);
    }).catchError((error) {});
  }

  LatLng? userPickedLocation;
  Set<Marker> userPickedLocationMarker = {};

  void pickUserLocation(LatLng latLng) {
    userPickedLocation = latLng;
    userPickedLocationMarker.clear();
    userPickedLocationMarker.add(
      Marker(
          markerId: MarkerId(latLng.longitude.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: latLng),
    );
    emit(PickUserLocationState());
  }
}
