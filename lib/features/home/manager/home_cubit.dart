import 'dart:convert';
import 'dart:io';

import 'package:dakeh_service_provider/core/api/dio_helper.dart';
import 'package:dakeh_service_provider/core/api/end_points.dart';
import 'package:dakeh_service_provider/core/data/cities_model.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:dakeh_service_provider/features/home/data/notification_model.dart';
import 'package:dakeh_service_provider/features/home/data/privacy_policy_model.dart';
import 'package:dakeh_service_provider/features/home/data/social_media_model.dart';
import 'package:dakeh_service_provider/features/home/data/terms_and_conditions_model.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/notifications_screen.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/reservations_screen.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/scan_barcode_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 0;

  void changeBottomNavIndex(int value) {
    bottomNavIndex = value;
    emit(ChangeBottomNavIndexState());
  }

  List<Widget> screens = [
    const ReservationsScreen(),
    const ScanBarcodeScreen(),
    const NotificationsScreen(),
  ];

  GlobalKey<ScaffoldState> homeLayoutScaffoldKey = GlobalKey<ScaffoldState>();

  // var profileScreenScaffoldKey = GlobalKey<ScaffoldState>();

  void getCities() {
    AppConstants.cities = [];
    emit(GetCitiesLoadingState());
    DioHelper.getData(
      endPoint: EndPoints.getCities,
    ).then((value) {
      for (var element in value.data['data']) {
        AppConstants.cities.add(City.fromJson(element));
      }
      emit(GetCitiesSuccessState());
    }).catchError((error) {
      getCities();
      // emit(GetCitiesErrorState());
    });
  }

  File? profileImage;

  void pickProfileImage(ImageSource source) {
    ImagePicker().pickImage(source: source).then((value) {
      if (value != null) {
        profileImage = File(value.path);
        emit(PickProfileImageState());
      }
    });
  }

  void editProfile({
    required String name,
    required String email,
    required String phone,
    required String bank,
    required String iban,
    required int cityID,
  }) async {
    emit(EditProfileLoadingState());
    FormData data = FormData.fromMap({
      'name': name,
      'email': email,
      'mobile': phone,
      'city_id': cityID,
      'bank': bank,
      'iban': iban,
    });
    if (profileImage != null) {
      data.files.add(MapEntry(
        'img',
        await MultipartFile.fromFile(profileImage!.path,
            filename: profileImage!.path.split('/').last),
      ));
    }
    DioHelper.postData(
            endPoint: EndPoints.editProfile,
            token: AppConstants.user!.token,
            data: data)
        .then((value) {
      profileImage = null;
     
      AppConstants.user!.data = UserData.fromJson(value.data['provider']);
      CacheHelper.saveData(
          key: 'user', value: jsonEncode(AppConstants.user!.toMap()));
      profileImage = null;
      emit(EditProfileSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      profileImage = null;
      emit(EditProfileErrorState());
    });
  }

  void logout(context) async {
    emit(LogoutLoadingState());
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    DioHelper.postData(
        endPoint: EndPoints.logout,
        token: AppConstants.user!.token,
        data: {'token_fcm': fcmToken}).then((value) {
     
      AppFunctions.navToWithoutBack(context, screen: const AuthScreen());
      bottomNavIndex = 0;
      AppConstants.user = null;
      CacheHelper.deleteData(key: 'user');
      emit(LogoutSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(LogoutErrorState());
    });
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    await DioHelper.postData(
      endPoint: EndPoints.deleteAccount,
      token: AppConstants.user!.token,
    ).then(
          (value) {
       
        emit(DeleteAccountSuccessState());
      },
    ).catchError((error) {
     
      emit(DeleteAccountErrorState());
    });
  }


  bool oldIsPassword = true;
  IconData oldPasswordSuffixIcon = Icons.visibility_outlined;

  void showOldPassword() {
    oldIsPassword = !oldIsPassword;
    oldPasswordSuffixIcon = oldIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowPasswordState());
  }

  bool newIsPassword = true;
  IconData newPasswordSuffixIcon = Icons.visibility_outlined;

  void showNewPassword() {
    newIsPassword = !newIsPassword;
    newPasswordSuffixIcon = newIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowPasswordState());
  }

  bool confirmIsPassword = true;
  IconData confirmPasswordSuffixIcon = Icons.visibility_outlined;

  void showConfirmPassword() {
    confirmIsPassword = !confirmIsPassword;
    confirmPasswordSuffixIcon = confirmIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowPasswordState());
  }

  void editPassword({
    required String oldPassword,
    required String newPassword,
  }) {
    emit(EditPasswordLoadingState());
    DioHelper.postData(
        endPoint: EndPoints.editPassword,
        token: AppConstants.user!.token,
        data: {
          'old_password': oldPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
        }).then((value) {
      if (value.data is String &&
          value.data == 'The old password is incorrect') {
        emit(EditPasswordErrorState());
      } else {
        emit(EditPasswordSuccessState());
      }
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(EditPasswordErrorState());
    });
  }

  late TermsAndConditions termsAndConditions;

  void getTermsAndConditions() {
    emit(GetTermsAndConditionsLoadingState());
    DioHelper.getData(endPoint: EndPoints.getTermsAndConditions).then((value) {
     
      termsAndConditions = TermsAndConditions.fromJson(value.data);
      emit(GetTermsAndConditionsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(GetTermsAndConditionsErrorState());
    });
  }

  late PrivacyPolicy privacyPolicy;

  void getPrivacyPolicy() {
    emit(GetPrivacyPolicyLoadingState());
    DioHelper.getData(endPoint: EndPoints.getPrivacyPolicy).then((value) {
     
      privacyPolicy = PrivacyPolicy.fromJson(value.data);
      emit(GetPrivacyPolicySuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(GetPrivacyPolicyErrorState());
    });
  }

  void contactUS({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  }) {
    emit(ContactUSLoadingState());
    DioHelper.postData(
            endPoint: EndPoints.contactUS,
            data: {
              'type': 'provider',
              'name': name,
              'mobile': phone,
              'email': email,
              'subject': subject,
              'message': message,
            },
            token: AppConstants.user!.token)
        .then((value) {
     
      emit(ContactUSSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(ContactUSErrorState());
    });
  }

  int notificationsPageIndex = 1;
  bool notificationsHasMore = true;
  List<NotificationData> notifications = [];

  void getNotifications(
      {required bool fromPagination, required bool sortByNewest}) {
    if (!fromPagination) {
      notificationsPageIndex = 1;
      notificationsHasMore = true;
      notifications.clear();
      emit(GetNotificationsLoadingState());
    }
    int limit = 20;
    DioHelper.getData(
      endPoint: EndPoints.getNotifications,
      parameters: {'page': notificationsPageIndex},
      token: AppConstants.user!.token,
    ).then((value) {
      final List<NotificationData> newList = (value.data['data'] as List)
          .map((e) => NotificationData.formJson(e))
          .toList();
      if (fromPagination) notificationsPageIndex++;
      if (newList.length < limit) notificationsHasMore = false;
      notifications.addAll(newList);
      notifications.sort((a, b) {
        if (sortByNewest) {
          return b.createdAt.compareTo(a.createdAt);
        } else {
          return a.createdAt.compareTo(b.createdAt);
        }
      });
      emit(GetNotificationsSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(GetNotificationsErrorState());
    });
  }

  void deleteNotification(int notificationID) {
    emit(GetNotificationsLoadingState());
    DioHelper.postData(
            endPoint: '${EndPoints.deleteNotifications}/$notificationID',
            token: AppConstants.user!.token)
        .then((value) {
      getNotifications(fromPagination: false, sortByNewest: true);
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
    });
  }

  void deleteAllNotification() {
    emit(GetNotificationsLoadingState());
    DioHelper.postData(
            endPoint: EndPoints.deleteAllNotifications,
            token: AppConstants.user!.token)
        .then((value) {
      getNotifications(fromPagination: false, sortByNewest: true);
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(GetNotificationsErrorState());
    });
  }

  final MobileScannerController scannerController = MobileScannerController();

  late SocialMediaInfo socialMediaInfo;

  void getSocialMediaInfo() {
    emit(GetSocialMediaInfoLoadingState());
    DioHelper.getData(
      endPoint: EndPoints.getSetting,
      token: AppConstants.user!.token,
    ).then((value) {
      socialMediaInfo = SocialMediaInfo.fromJson(value.data['data']);
      emit(GetSocialMediaInfoSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(GetSocialMediaInfoErrorState());
    });
  }

  void changeLanguage({required String langCode}) {
    emit(ChangeLanguageLoadingState());
    DioHelper.postData(
        endPoint: EndPoints.changeLanguage,
        token: AppConstants.user!.token,
        data: {
          'language': langCode,
        }).then(
      (value) {
       
        emit(ChangeLanguageSuccessState(langCode: value.data['provider']['language']));
      },
    ).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(ChangeLanguageErrorState());
    });
  }
}
