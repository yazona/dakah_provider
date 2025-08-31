import 'dart:convert';
import 'dart:io';

import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/home_layout.dart';
import 'package:dakeh_service_provider/features/onboard/onboard_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppFunctions {
  static Future<void> buildErrorAnimatedDialog(
      {required BuildContext context,
        required String message,
        bool closeApp = false}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'errorOccurred'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12)),
                      onPressed: () => closeApp ? exit(0) : Navigator.of(context).pop(),
                      child: Text(
                        'accept'.tr(),
                        style:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ))
                ],
              ),
            ).animate().fade(duration: 300.ms).scale(
                begin: const Offset(0.8, 0.8),
                duration: 300.ms,
                curve: Curves.easeOut),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: .8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
              child: child,
            ),
          ),
    );
  }
  static navPopUntil(context,
          {required Widget screen, RoutePredicate? predicate}) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        predicate ?? (route) => route.isFirst,
      );

  static navTo(context, {required Widget screen}) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ));

  static navToWithoutBack(context, {required Widget screen}) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (Route<dynamic> route) => false,
      );

  static navPushUntil(context, {required Widget screen}) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => route.isFirst,
      );

  static buildSnackBar(
    context, {
    IconData? icon,
    required String text,
    String? title,
    String? actionTitle,
    void Function()? actionOnPressed,
    bool showCloseIcon = true,
    Color backgroundColor = ColorsManager.kPrimaryColor,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: actionTitle != null && actionOnPressed != null
              ? SnackBarAction(
                  onPressed: actionOnPressed,
                  label: actionTitle,
                )
              : null,
          showCloseIcon: showCloseIcon,
          content: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: ColorsManager.kWhite,
                  size: 30,
                ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  static Widget getHomeWidget() {
    if (CacheHelper.getData(key: AppConstants.kIsOnBoardingSharedPref) !=
        null) {
      if (CacheHelper.getData(key: 'user') != null) {
        AppConstants.user =
            User.fromJson(jsonDecode(CacheHelper.getData(key: 'user')));
        return const HomeLayout();
      } else {
        return const AuthScreen();
      }
    } else {
      return const OnBoardScreen();
    }
  }

  static Future<bool> buildAppDialog(
    context, {
    required Widget child,
    bool allowCloseWithBackButton = false,
  }) async =>
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: allowCloseWithBackButton,
          child: AlertDialog(
            surfaceTintColor: Colors.grey.shade100,
            insetPadding: const EdgeInsets.all(20),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        ),
      );

  static String convertTime(String time) {
    DateFormat originalTime = DateFormat('HH:mm:ss', 'en');
    DateFormat desiredFormat = DateFormat('ha', 'en');
    DateTime dateTime = originalTime.parse(time);
    return desiredFormat.format(dateTime);
  }

  static String getGameNameByID({required int gameID}) {
    switch (gameID) {
      case (1):
        return 'billiard'.tr();
      case (2):
        return 'baloot'.tr();
      default:
        return 'chess'.tr();
    }
  }
}
