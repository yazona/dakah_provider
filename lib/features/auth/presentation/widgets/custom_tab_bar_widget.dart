import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.isLoginSelected,
    required this.loginOnTap,
    required this.registerOnTap,
  });

  final bool isLoginSelected;
  final void Function()? loginOnTap;
  final void Function()? registerOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          AssetsManager.kDakehLogoIconPNG,
          width: 153,
          height: 82,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: loginOnTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: isLoginSelected
                          ? ColorsManager.kPrimaryColor
                          : ColorsManager.kWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: context.locale.languageCode == 'en'
                            ? const Radius.circular(50)
                            : Radius.zero,
                        topRight: context.locale.languageCode == 'en'
                            ? Radius.zero
                            : const Radius.circular(50),
                        bottomLeft: context.locale.languageCode == 'en'
                            ? const Radius.circular(50)
                            : Radius.zero,
                        bottomRight: context.locale.languageCode == 'en'
                            ? Radius.zero
                            : const Radius.circular(50),
                      ),
                    ),
                    child: Text(
                      'login'.tr(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isLoginSelected
                              ? ColorsManager.kWhite
                              : ColorsManager.kBlack),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: registerOnTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      color: !isLoginSelected
                          ? ColorsManager.kPrimaryColor
                          : ColorsManager.kWhite,
                      borderRadius: BorderRadius.only(
                        topRight: context.locale.languageCode == 'en'
                            ? const Radius.circular(50)
                            : Radius.zero,
                        topLeft: context.locale.languageCode == 'en'
                            ? Radius.zero
                            : const Radius.circular(50),
                        bottomRight: context.locale.languageCode == 'en'
                            ? const Radius.circular(50)
                            : Radius.zero,
                        bottomLeft: context.locale.languageCode == 'en'
                            ? Radius.zero
                            : const Radius.circular(50),
                      ),
                    ),
                    child: Text(
                      'register'.tr(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: !isLoginSelected
                              ? ColorsManager.kWhite
                              : ColorsManager.kBlack),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
