
import 'dart:io';

import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: ColorsManager.kPrimaryColor.withValues(alpha: .2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsManager.kDakehLogoIconPNG,
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'newUpdateIsAvailable'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              'versionUnsupported'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
              onPressed: () {
                String googleURL = 'https://play.google.com/store/apps/details?id=com.goldensoft.dakeh.sp.dakeh_service_provider';
                String appleURL = 'https://apps.apple.com/us/app/dakehprovider/id6737767773';
                launchUrl(Uri.parse(Platform.isAndroid ? googleURL : appleURL));
              },
              title: 'updateNow'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
