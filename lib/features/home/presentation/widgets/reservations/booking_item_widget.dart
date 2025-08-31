import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/features/reservations/data/reservation_model.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/reservation_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingItem extends StatelessWidget {
  const BookingItem({super.key, required this.model});

  final Reservation model;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: '${AppConstants.kBaseURL}${model.hallImage}',
          imageBuilder: (context, imageProvider) => Container(
            width: 75,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: imageProvider)),
          ),
          placeholder: (context, url) => Container(
            width: 75,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          ),
          errorWidget: (context, url, error) => Container(
            width: 75,
            height: 60,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor.withAlpha(1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(
              Icons.error,
              color: ColorsManager.kPrimaryColor,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppFunctions.getGameNameByID(gameID: model.gameID),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // ReservationsCubit.get(context)
                      //     .getReservationsDetails(reservationID: model.id);
                      AppFunctions.navTo(context,
                          screen: BlocProvider(
                            create: (context) => ReservationsCubit()
                              ..getReservationsDetails(reservationID: model.id),
                            child: const ReservationDetailsScreen(),
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: ColorsManager.kPrimaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'bookingDetails'.tr(),
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: ColorsManager.kWhite),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.kUserWithoutBackgroundIconSVG,
                    width: 10,
                    height: 10,
                    fit: BoxFit.fill,
                    colorFilter: const ColorFilter.mode(
                      ColorsManager.kTextGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    model.users.isEmpty ? '' : model.users[0].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: ColorsManager.kTextGrey),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.kWalletIconSVG,
                    width: 10,
                    height: 10,
                    fit: BoxFit.fill,
                    colorFilter: const ColorFilter.mode(
                      ColorsManager.kPrimaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${model.hallGamePrice} ${'sr'.tr()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: ColorsManager.kPrimaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
