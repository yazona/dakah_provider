import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_states.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/info_item_with_title_and_icon_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerProfileInfoScreen extends StatelessWidget {
  const PlayerProfileInfoScreen({
    super.key,
    required this.model,
  });

  final UserData model;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationsCubit(),
      child: BlocConsumer<ReservationsCubit, ReservationsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: BodyWithAppHeader(
                fromHome: false,
                appBar: CustomAppBar(
                  rightType: ButtonAppBarType.none,
                  leftType: ButtonAppBarType.backButton,
                  title: Image.asset(
                    AssetsManager.kDakehLogoIconPNG,
                    width: 65,
                    height: 35,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 58,
                    ),
                    CachedNetworkImage(
                      imageUrl: '${AppConstants.kBaseURL}${model.image}',
                      imageBuilder: (context, imageProvider) => Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsManager.kPrimaryColor.withAlpha(1)),
                        child: const Icon(
                          Icons.error,
                          color: ColorsManager.kPrimaryColor,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsManager.kPrimaryColor.withAlpha(1)),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kUserDrawerIconSVG,
                      size: 28,
                      borderRadius: BorderRadius.circular(50),
                      colorFilter: const ColorFilter.mode(
                        ColorsManager.kPrimaryColor,
                        BlendMode.screen,
                      ),
                      title: 'userName'.tr(),
                      subTitleAR: model.name,
                      subTitleEN: model.name,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kEmailIconSVG,
                      title: 'email'.tr(),
                      subTitleAR: model.email,
                      subTitleEN: model.email,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kPhoneIconSVG,
                      title: 'phoneNumber'.tr(),
                      subTitleAR: model.phone,
                      subTitleEN: model.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'favoriteGame'.tr(),
                      subTitleAR: model.favGame == null
                          ? 'none'.tr()
                          : AppFunctions.getGameNameByID(
                              gameID: int.parse(model.favGame!),
                            ),
                      subTitleEN: model.favGame == null
                          ? 'none'.tr()
                          : AppFunctions.getGameNameByID(
                              gameID: int.parse(model.favGame!),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'ratingOfLevel'.tr(),
                      subTitleEN: model.level == null
                          ? 'none'.tr()
                          : AppConstants.rateLevel
                              .firstWhere(
                                  (element) => element.id == model.level!)
                              .titleEN,
                      subTitleAR: model.level == null
                          ? 'none'.tr()
                          : AppConstants.rateLevel
                              .firstWhere(
                                  (element) => element.id == model.level!)
                              .titleAR,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'highestLevelCompetedAt'.tr(),
                      subTitleEN: model.highestLevel == null
                          ? 'none'.tr()
                          : AppConstants.highestLevel
                              .firstWhere((element) =>
                                  element.id == model.highestLevel!)
                              .titleEN,
                      subTitleAR: model.highestLevel == null
                          ? 'none'.tr()
                          : AppConstants.highestLevel
                              .firstWhere((element) =>
                                  element.id == model.highestLevel!)
                              .titleAR,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'yearsOfPlaying'.tr(),
                      subTitleEN: model.playedYears == null
                          ? 'none'.tr()
                          : AppConstants.yearsOfPlaying
                              .firstWhere(
                                  (element) => element.id == model.playedYears!)
                              .titleEN,
                      subTitleAR: model.playedYears == null
                          ? 'none'.tr()
                          : AppConstants.yearsOfPlaying
                              .firstWhere(
                                  (element) => element.id == model.playedYears!)
                              .titleAR,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'matchesPerMonth'.tr(),
                      subTitleEN: model.matchesPerMonth == null
                          ? 'none'.tr()
                          : AppConstants.matchesPerMonth
                              .firstWhere((element) =>
                                  element.id == model.matchesPerMonth!)
                              .titleEN,
                      subTitleAR: model.matchesPerMonth == null
                          ? 'none'.tr()
                          : AppConstants.matchesPerMonth
                              .firstWhere((element) =>
                                  element.id == model.matchesPerMonth!)
                              .titleAR,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InfoItemWithIconAndTitle(
                      iconPath: AssetsManager.kFavoriteGameIconSVG,
                      title: 'numberOfChampionships'.tr(),
                      subTitleEN: model.championshipsNum == null
                          ? 'none'.tr()
                          : AppConstants.numOfChampionships
                              .firstWhere((element) =>
                                  element.id == model.championshipsNum!)
                              .titleEN,
                      subTitleAR: model.championshipsNum == null
                          ? 'none'.tr()
                          : AppConstants.numOfChampionships
                              .firstWhere((element) =>
                                  element.id == model.championshipsNum!)
                              .titleAR,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
