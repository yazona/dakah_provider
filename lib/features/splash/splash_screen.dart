import 'dart:convert';
import 'package:dakeh_service_provider/core/api/end_points.dart';
import 'package:dakeh_service_provider/core/api/update_service.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/home_layout.dart';
import 'package:dakeh_service_provider/features/splash/data/nav_rule_model.dart';
import 'package:dakeh_service_provider/features/splash/update_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../onboard/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _version = '';

  void navToHome() async {
    try {
      final updateService = UpdateService(
          configURL: 'https://dakkah1.com/${EndPoints.getSetting}');
      final updateAvailable = await updateService.needsUpdate();
      final onBoardingIsNotSkipped =
          CacheHelper.getData(key: AppConstants.kIsOnBoardingSharedPref) ==
              null;
      final rules = <NavRule>[
        NavRule(
            condition: () => updateAvailable,
            screen: const UpdateScreen(),
            usePopUntil: true),
        NavRule(
            condition: () => onBoardingIsNotSkipped,
            screen: const OnBoardScreen(),
            usePopUntil: false),
        NavRule(
          condition: () => userIsLoggedIn(),
          screen: const HomeLayout(),
          usePopUntil: true,
          onNavigate: () {
            AppConstants.user =
                User.fromJson(jsonDecode(CacheHelper.getData(key: 'user')!));
          },
        ),
        NavRule(
            condition: () => true,
            screen: const AuthScreen(),
            usePopUntil: true),
      ];
      final rule = rules.firstWhere(
            (element) => element.condition(),
      );
      rule.onNavigate?.call();
      _navigateTo(rule.screen, usePopUntil: rule.usePopUntil);
    } on UpdateServiceException catch (e) {
      if (!mounted) return;
      AppFunctions.buildErrorAnimatedDialog(
          closeApp: true, context: context, message: e.message);
    } catch (e) {
      if (!mounted) return;
      AppFunctions.buildErrorAnimatedDialog(
          context: context,
          closeApp: true,
          message: 'unknown_error'.tr(namedArgs: {'error': e.toString()}));
    }
  }

  void _navigateTo(Widget screen, {required bool usePopUntil}) {
    if (usePopUntil) {
      AppFunctions.navPopUntil(context,
          screen: screen, predicate: (route) => false);
    } else {
      AppFunctions.navToWithoutBack(context, screen: screen);
    }
  }

  bool userIsLoggedIn() {
    return CacheHelper.getData(key: 'user') != null;
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVersion();
    navToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              AssetsManager.kDakehLogoIconPNG,
              width: 200,
              height: 200,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                _version,
                style: const TextStyle(
                    letterSpacing: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
