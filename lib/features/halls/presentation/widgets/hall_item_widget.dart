import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/halls/data/hall_model.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/presentation/screens/hall_info_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HallItem extends StatelessWidget {
  const HallItem({super.key, required this.model});

  final Hall model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsManager.kWhite, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: '${AppConstants.kBaseURL}${model.images[0].url}',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  )),
            ),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor.withAlpha(1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              height: 170,
              width: double.infinity,
              child: const SpinKitCubeGrid(
                color: ColorsManager.kPrimaryColor,
                size: 35,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor.withAlpha(1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              height: 170,
              width: double.infinity,
              child: const Icon(
                Icons.error,
                size: 35,
                color: ColorsManager.kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TranslateText(
                      textAR: model.nameAR,
                      textEN: model.nameEN,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${model.billiardPrice} ${'sr'.tr()}',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.kPrimaryColor),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 17,
                      color: ColorsManager.kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      model.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.kBlack,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      size: 17,
                      color: ColorsManager.kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${'from'.tr()} ${AppFunctions.convertTime(model.openTime)} ${'to'.tr()} ${AppFunctions.convertTime(model.closeTime)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.kBlack,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  btnWidth: 150,
                  btnHeight: 45,
                  onPressed: () {
                    HallsCubit.get(context).getHallInfo(hallID: model.id);
                    AppFunctions.navTo(
                      context,
                      screen: const HallInfoScreen(),
                    );
                  },
                  title: 'management'.tr(),
                ),
                const SizedBox(
                  height: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
