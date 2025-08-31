import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: cubit.bottomNavIndex,
      onTap: (value) {
        cubit.changeBottomNavIndex(value);
        if (value == 0) {
          ReservationsCubit.get(context).getCurrentReservations();
        }
        if(value ==1){
          cubit.scannerController.start();
        }
        if (value == 2) {
          HomeCubit.get(context)
              .getNotifications(fromPagination: false, sortByNewest: true);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AssetsManager.kHomeIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kBottomNavTextGrey,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            AssetsManager.kHomeIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
          label: 'home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AssetsManager.kScanBarcodeIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kBottomNavTextGrey,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            AssetsManager.kScanBarcodeIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
          label: 'scanBarcode'.tr(),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AssetsManager.kNotificationsIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kBottomNavTextGrey,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            AssetsManager.kNotificationsIconSVG,
            colorFilter: const ColorFilter.mode(
              ColorsManager.kPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
          label: 'notifications'.tr(),
        ),
      ],
    );
  }
}
