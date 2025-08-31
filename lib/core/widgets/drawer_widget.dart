import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_item_widget.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/presentation/screens/my_halls_screen.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/contact_us_screen.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/home_layout.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/privacy_policy_screen.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/profile_screen.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/terms_and_conditions_screen.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.user,
    required this.scaffoldKey,
    required this.screenContext,
    this.myAccountOnTap,
  });

  final User? user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext screenContext;
  final void Function()? myAccountOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: ColorsManager.kWhite,
          borderRadius: BorderRadius.only(
            topRight: context.locale.languageCode == 'en'
                ? const Radius.circular(60)
                : Radius.zero,
            bottomRight: context.locale.languageCode == 'en'
                ? const Radius.circular(60)
                : Radius.zero,
            topLeft: context.locale.languageCode == 'en'
                ? Radius.zero
                : const Radius.circular(60),
            bottomLeft: context.locale.languageCode == 'en'
                ? Radius.zero
                : const Radius.circular(60),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 55,
              ),
              Image.asset(
                AssetsManager.kDakehLogoIconPNG,
                width: 75,
              ),
              const SizedBox(
                height: 33,
              ),
              CachedNetworkImage(
                imageUrl: '${AppConstants.kBaseURL}${user!.data.image}',
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundColor: ColorsManager.kWhite,
                  backgroundImage: imageProvider,
                  radius: 48,
                ),
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: ColorsManager.kWhite,
                  radius: 48,
                  child: SpinKitCubeGrid(
                    size: 25,
                    color: ColorsManager.kPrimaryColor,
                  ),
                ),
                errorWidget: (context, url, error) {
                  return const CircleAvatar(
                    backgroundColor: ColorsManager.kWhite,
                    radius: 48,
                    child: Icon(
                      Icons.error_outline,
                      size: 25,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user!.data.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerItem(
                iconPath: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: ColorsManager.kBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.home_filled,
                    color: ColorsManager.kWhite,
                    size: 18,
                  ),
                ),
                title: 'home'.tr(),
                onTap: () {
                  if (ModalRoute.of(context)!.isFirst) {
                    scaffoldKey.currentState!.closeDrawer();
                    ReservationsCubit.get(context).getCurrentReservations();
                  } else {
                    HomeCubit.get(context)
                        .homeLayoutScaffoldKey
                        .currentState!
                        .closeDrawer();
                    Navigator.of(context).popUntil((route) {
                      if (route.isFirst) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  ReservationsCubit()..getCurrentReservations(),
                              child: const HomeLayout(),
                            ),
                          ),
                        );
                        return true;
                      }
                      return false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DrawerItem(
                iconPath: AssetsManager.kUserDrawerIconSVG,
                title: 'myAccount'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                  AppFunctions.navTo(context, screen: const ProfileScreen());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DrawerItem(
                iconPath: AssetsManager.kHallsDrawerIconSVG,
                title: 'myHalls'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  HallsCubit.get(context).getHalls();
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                  AppFunctions.navTo(context, screen: const MyHallsScreen());
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              DrawerItem(
                iconPath: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: ColorsManager.kBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.language,
                    color: ColorsManager.kWhite,
                    size: 18,
                  ),
                ),
                title: 'chooseLanguage'.tr(),
                onTap: () {
                  AppFunctions.buildAppDialog(
                    context,
                    child: BlocConsumer<HomeCubit, HomeStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return state is ChangeLanguageLoadingState
                            ? const SizedBox(
                                height: 200,
                                child: SpinKitCubeGrid(
                                  color: ColorsManager.kPrimaryColor,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${'chooseLanguage'.tr()}:',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: ColorsManager.kPrimaryColor),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        icon: const Icon(
                                          Icons.close,
                                          color: ColorsManager.kPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      HomeCubit.get(context)
                                          .changeLanguage(langCode: 'en');
                                    },
                                    leading: const Icon(
                                      Icons.language,
                                    ),
                                    title: Text(
                                      'englishLanguage'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      HomeCubit.get(context)
                                          .changeLanguage(langCode: 'ar');
                                    },
                                    leading: const Icon(
                                      Icons.language,
                                    ),
                                    title: Text(
                                      'arabicLanguage'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  );
                  // if (ModalRoute.of(context)!.isFirst) {
                  //   scaffoldKey.currentState!.closeDrawer();
                  //   ReservationsCubit.get(context).getCurrentReservations();
                  // } else {
                  //   scaffoldKey.currentState!.closeDrawer();
                  //   HallsCubit.get(context).getHalls();
                  // }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DrawerItem(
                iconPath: AssetsManager.kContactUSDrawerIconSVG,
                title: 'contactUS'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  HomeCubit.get(context).getSocialMediaInfo();
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                  AppFunctions.navTo(context, screen: const ContactUSScreen());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DrawerItem(
                iconPath: Image.asset(
                  AssetsManager.kTermsAndConditionsDrawerIconPNG,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                title: 'termsAndConditions'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  HomeCubit.get(screenContext).getTermsAndConditions();
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                  AppFunctions.navTo(context,
                      screen: const TermsAndConditionsScreen());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DrawerItem(
                iconPath: Image.asset(
                  AssetsManager.kPrivacyPolicyDrawerIconPNG,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
                title: 'privacyAndPolicy'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  HomeCubit.get(context).getPrivacyPolicy();
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                  AppFunctions.navTo(context,
                      screen: const PrivacyPolicyScreen());
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              DrawerItem(
                iconPath: AssetsManager.kLogoutDrawerIconSVG,
                title: 'logout'.tr(),
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();
                  HomeCubit.get(context).logout(screenContext);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
