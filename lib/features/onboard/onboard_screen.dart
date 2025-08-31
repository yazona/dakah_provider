import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: AlignmentDirectional.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .65,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AssetsManager.kOnBoardHeaderImage,
                ),
              ),
            ),
            child: Image.asset(
              AssetsManager.kDakehLogoIconPNG,
              width: 270,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CustomButton(
              onPressed: () {
                if (CacheHelper.getData(key: AppConstants.kIsOnBoardingSharedPref) == null) {
                  CacheHelper.saveData(key: AppConstants.kIsOnBoardingSharedPref, value: true);
                }
                AppFunctions.navToWithoutBack(context, screen: const AuthScreen());
              },
              title: 'start'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
