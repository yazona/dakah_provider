import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.isAcceptedSelected,
    this.acceptedOnTap,
    this.paymentOnTap,
  });

  final bool isAcceptedSelected;
  final void Function()? acceptedOnTap;
  final void Function()? paymentOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: acceptedOnTap,
            child: Container(
              // width: 145,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAcceptedSelected
                    ? ColorsManager.kPrimaryColor
                    : ColorsManager.kWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'currentReservations'.tr(),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isAcceptedSelected
                      ? ColorsManager.kWhite
                      : ColorsManager.kTextGrey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: GestureDetector(
            onTap: paymentOnTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              // width: 180,
              decoration: BoxDecoration(
                color: isAcceptedSelected
                    ? ColorsManager.kWhite
                    : ColorsManager.kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'previousReservations'.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isAcceptedSelected
                      ? ColorsManager.kTextGrey
                      : ColorsManager.kWhite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
