import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CancelReservationDialog extends StatelessWidget {
  const CancelReservationDialog({super.key, required this.reservationID});

  final int reservationID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationsCubit(),
      child: BlocConsumer<ReservationsCubit, ReservationsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is CancelReservationLoadingState
              ? Container(
            height: 100,
            alignment: AlignmentDirectional.center,
            child: const SpinKitCubeGrid(
              size: 25,
              color: ColorsManager.kPrimaryColor,
            ),
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'sureCancelReservation'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'cancelBooking'.tr(),
                      onPressed: () {
                        // ReservationsCubit.get(context)
                        //     .cancelReservation(reservationID: reservationID)
                        //     .then((value) => Navigator.pop(context));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: ColorsManager.kWhite,
                      borderColor: ColorsManager.kPrimaryColor,
                      fontColor: ColorsManager.kPrimaryColor,
                      title: 'cancel'.tr(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
