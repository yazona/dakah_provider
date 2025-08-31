import 'dart:convert';

import 'package:dakeh_service_provider/core/api/dio_helper.dart';
import 'package:dakeh_service_provider/core/api/end_points.dart';
import 'package:dakeh_service_provider/core/data/cities_model.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/features/auth/data/new_user_model.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isLoginSelected = true;

  void changeIsLoginSelected(bool value) {
    isLoginSelected = value;
    emit(ChangeIsLoginSelectedState());
  }

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

  IconData registerPasswordPrefixIcon = Icons.visibility_outlined;
  bool registerIsPassword = true;

  void showRegisterPassword() {
    registerIsPassword = !registerIsPassword;
    registerPasswordPrefixIcon = registerIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowRegisterPasswordState());
  }

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppFunctions.buildSnackBar(
        context,
        icon: Icons.error,
        text: 'الرجاء تفعيل خدمات الموقع ثم المحاولة مرة اخرى',
        title: 'حدث خطأ',
      );
      emit(GetUserLocationErrorState());
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppFunctions.buildSnackBar(
          context,
          icon: Icons.error,
          text: 'الرجاء السماح للتطبيق بالوصول الى خدمات الموقع',
          title: 'حدث خطأ',
        );
        emit(GetUserLocationErrorState());
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppFunctions.buildSnackBar(
        context,
        icon: Icons.error,
        text: 'الرجاء السماح للتطبيق بالوصول الى خدمات الموقع',
        title: 'حدث خطأ',
        actionTitle: 'الإعدادات',
        showCloseIcon: false,
        actionOnPressed: () async {
          await Geolocator.openAppSettings();
        },
      );
      emit(GetUserLocationErrorState());
      return false;
    }
    emit(GetUserLocationSuccessState());
    return true;
  }

  NewUser? newUser;

  void getVerificationCode({
    String? name,
    String? email,
    String? phone,
    String? password,
    int? cityID,
    bool fromResend = false,
  }) {
    newUser = NewUser(
      name: name!,
      email: email!,
      phone: phone!,
      password: password!,
      cityID: cityID!,
    );
    emit(GetVerificationCodeLoadingState());
    DioHelper.postData(endPoint: EndPoints.getVerificationCode, data: {
      'type': 'register',
      'email': email,
      'mobile': phone,
    }).then((value) {
      emit(
        GetVerificationCodeSuccessState(
          fromResend: fromResend,
        ),
      );
    }).catchError((error) {
      bool emailError = false;
      bool phoneError = false;
      if (error is DioException) {
        phoneError = error.response?.data['errors']['mobile'] != null;
        emailError = error.response?.data['errors']['email'] != null;
      } else {
       
      }
      emit(
        GetVerificationCodeErrorState(
          emailError: emailError,
          phoneError: phoneError,
        ),
      );
    });
  }

  String? resetPasswordPhoneNumber;

  void getVerificationCodeResetPassword({
    required String phone,
    bool fromResend = false,
  }) {
    if (!fromResend) resetPasswordPhoneNumber = phone;
    emit(GetVerificationCodeResetPasswordLoadingState());
    DioHelper.postData(endPoint: EndPoints.getVerificationCode, data: {
      'type': 'reset',
      'mobile': resetPasswordPhoneNumber ?? phone,
    }).then((value) {
     
      emit(
        GetVerificationCodeResetPasswordSuccessState(
          fromResend: fromResend,
        ),
      );
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(
        GetVerificationCodeResetPasswordErrorState(),
      );
    });
  }

  void createNewAccount(String verificationCode) {
    Map<String, dynamic> data = newUser!.toMap();
    data['code'] = verificationCode;
    emit(CreateNewAccountLoadingState());
    DioHelper.postData(
      endPoint: EndPoints.createNewAccount,
      data: data,
    ).then((value) {
      if (value.data is String && value.data.contains('code is incorrect')) {
        emit(CreateNewAccountErrorState());
      } else {
        newUser = null;
        verificationCode = '';
        emit(CreateNewAccountSuccessState());
      }
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
    });
  }

  IconData resetPasswordPrefixIcon = Icons.visibility_outlined;
  bool resetIsPassword = true;

  void showResetPassword() {
    resetIsPassword = !resetIsPassword;
    resetPasswordPrefixIcon = resetIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowRegisterPasswordState());
  }

  IconData confirmResetPasswordPrefixIcon = Icons.visibility_outlined;
  bool confirmResetIsPassword = true;

  void showConfirmResetPassword() {
    confirmResetIsPassword = !confirmResetIsPassword;
    confirmResetPasswordPrefixIcon = confirmResetIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowRegisterPasswordState());
  }

  IconData loginPasswordPrefixIcon = Icons.visibility_outlined;
  bool loginIsPassword = true;

  void showLoginPassword() {
    loginIsPassword = !loginIsPassword;
    loginPasswordPrefixIcon = loginIsPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShowRegisterPasswordState());
  }

  void resetPassword({
    required String password,
  }) {
    emit(ResetPasswordLoadingState());
    DioHelper.postData(endPoint: EndPoints.resetPassword, data: {
      'password': password,
      'password_confirmation': password,
      'mobile': resetPasswordPhoneNumber,
      'code': resetPasswordCode,
    }).then((value) {
      if (value.data is String && value.data.contains('code is incorrect')) {
        emit(ResetPasswordErrorState());
      } else {
        resetPasswordPhoneNumber = null;
        resetPasswordCode = '';
        emit(ResetPasswordSuccessState());
      }
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(ResetPasswordErrorState());
    });
  }

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoadingState());
    DioHelper.postData(
      endPoint: EndPoints.login,
      data: {
        'mobile': phone,
        'password': password,
      },
    ).then((value) {
      AppConstants.user = User.fromJson(value.data);
      CacheHelper.saveData(key: 'user', value: jsonEncode(value.data));
      sendFCMToken(AppConstants.user!.token)
          .then((value) => emit(LoginSuccessState()));
    }).catchError((error) {
      if (error is DioException) {
      } else {
       
      }
      emit(LoginErrorState());
    });
  }

  Future<void> sendFCMToken(String userToken) async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      await DioHelper.postData(
          endPoint: EndPoints.sendFCMToken,
          data: {
            'token': '$token',
          },
          token: userToken);
     
    } catch (e) {
      sendFCMToken(userToken);
    }
  }

  late String resetPasswordCode;

  void checkCode({required String code}) {
    resetPasswordCode = code;
   
   
    emit(CheckVerificationCodeLoadingState());
    DioHelper.postData(endPoint: EndPoints.checkCode, data: {
      'code': code,
      'mobile': resetPasswordPhoneNumber,
    }).then((value) {
     
      emit(CheckVerificationCodeSuccessState());
    }).catchError((error) {
      if (error is DioException) {
       
      } else {
       
      }
      emit(CheckVerificationCodeErrorState());
    });
  }

  bool registerAgreeTermsAndConditions = false;

  void changeAcceptedRegisterTermsAndConditions(bool value){
    registerAgreeTermsAndConditions = value;
    emit(ChangeCheckboxState());
  }
}
