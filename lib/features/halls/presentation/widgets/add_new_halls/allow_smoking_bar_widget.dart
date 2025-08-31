import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllowSmokingRadioBar extends StatelessWidget {
  const AllowSmokingRadioBar({
    super.key,
    required this.cubit,
  });

  final HallsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                AssetsManager.kAllowSmokingIconSVG,
                width: 32,
                height: 32,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'allowSmoking'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: cubit.allowSmoking,
                  onChanged: (value) => cubit.changeAllowSmoking(value),
                ),
                Text(
                  'yes'.tr(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: cubit.allowSmoking,
                  onChanged: (value) => cubit.changeAllowSmoking(value),
                ),
                Text(
                  'no'.tr(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
