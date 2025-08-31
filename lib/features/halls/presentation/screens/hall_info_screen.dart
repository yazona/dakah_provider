// ignore_for_file: prefer_const_constructors
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_states.dart';
import 'package:dakeh_service_provider/features/halls/presentation/screens/edit_hall_screen.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/custom_icon_with_title_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/custom_switch_with_title_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/delete_hall_dialog_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/hall_info_map_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/images_slider_widget.dart';
import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HallInfoScreen extends StatelessWidget {
  const HallInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HallsCubit, HallsStates>(
      listener: (context, state) {
        if (state is DeleteHallSuccessState) {
          HallsCubit.get(context).getHalls();
          Navigator.pop(context);
          AppFunctions.buildSnackBar(context,
              text: 'hallDeletedSuccessfully'.tr(),
              showCloseIcon: true,
              icon: Icons.verified);
        }
      },
      builder: (context, state) {
        var cubit = HallsCubit.get(context);
        return PopScope(
          onPopInvoked: (didPop) {
            cubit.deletedHallImages.clear();
          },
          child: Scaffold(
            body: state is GetHallInfoLoadingState ||
                    state is DeleteHallLoadingState
                ? const CustomLoading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ImagesSlider(),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TranslateText(
                                    textAR: cubit.hallInfo.nameAR,
                                    textEN: cubit.hallInfo.nameEN,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CustomSwitchWithTitle(
                                    title: '',
                                    switchValue: cubit.hallInfo.hallActive,
                                    onToggle: (value) {
                                      if (value) {
                                        cubit.changeHallActivation(
                                            cubit.hallInfo.id,
                                            activeStatus: 1);
                                      } else {
                                        cubit.changeHallActivation(
                                            cubit.hallInfo.id,
                                            activeStatus: 0);
                                      }
                                    },
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      AppFunctions.buildAppDialog(
                                        context,
                                        child: DeleteHallDialog(),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      AssetsManager.kDeleteIconSVG,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => AppFunctions.navTo(context,
                                        screen: EditHallScreen(
                                            model: cubit.hallInfo)),
                                    child: SvgPicture.asset(
                                      AssetsManager.kEditIconSVG,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kHourPriceIconSVG,
                                title:
                                    '${cubit.hallInfo.billiardPrice} ${'srPerHour'.tr()}',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kHourPriceIconSVG,
                                title:
                                    '${cubit.hallInfo.balootPrice} ${'srPerHour'.tr()}',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kHourPriceIconSVG,
                                title:
                                    '${cubit.hallInfo.chessPrice} ${'srPerHour'.tr()}',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kClockIconVG,
                                title:
                                    '${'workTime'.tr()}: ${'from'.tr()} ${AppFunctions.convertTime(cubit.hallInfo.openTime)} ${'to'.tr()} ${AppFunctions.convertTime(cubit.hallInfo.closeTime)}',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kPhoneIconSVG,
                                titleStyle: TextStyle(
                                    shadows: const [
                                      Shadow(
                                          color: ColorsManager.kPrimaryColor,
                                          offset: Offset(0, -3))
                                    ],
                                    decorationColor:
                                        ColorsManager.kPrimaryColor,
                                    color: Colors.transparent,
                                    decoration: TextDecoration.underline),
                                onTap: () => launchUrlString(
                                    'tel://${cubit.hallInfo.phone}'),
                                title: cubit.hallInfo.phone,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kAllowSmokingIconSVG,
                                title: cubit.hallInfo.smokingAllowed
                                    ? 'smokingAllowed'.tr()
                                    : 'smokingNotAllowed'.tr(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomIconWithTitle(
                                iconPathSVG: AssetsManager.kLocationSVG,
                                title: cubit.hallInfo.place,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const HallInfoMap(),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomSwitchWithTitle(
                                title: 'balootBookings'.tr(),
                                switchValue: cubit.hallInfo.balootActive!,
                                onToggle: (value) => cubit.changeGameStatus(
                                  hallID: cubit.hallInfo.id,
                                  gameID: 2,
                                  status: value,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomSwitchWithTitle(
                                title: 'chessBookings'.tr(),
                                switchValue: cubit.hallInfo.chessActive!,
                                onToggle: (value) => cubit.changeGameStatus(
                                  hallID: cubit.hallInfo.id,
                                  gameID: 3,
                                  status: value,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomSwitchWithTitle(
                                title: 'billiardBookings'.tr(),
                                switchValue: cubit.hallInfo.billiardActive!,
                                onToggle: (value) => cubit.changeGameStatus(
                                  hallID: cubit.hallInfo.id,
                                  gameID: 1,
                                  status: value,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
