import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/custom_rating_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RatePlayerDialog extends StatelessWidget {
  const RatePlayerDialog(
      {super.key, required this.player});

  final UserData player;
  static double rateNum = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomRating(
          textController: TextEditingController(),
          textHint: 'addYourRate'.tr(),
          boxTitle: '${'rate'.tr()} ${player.name}',
          onRatingUpdate: (p0) {
            rateNum = p0;
          },
          rateInit: 1,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  ReservationsCubit.get(context).addRatePlayerToList(
                    id: player.id,
                    rateNum: rateNum,
                    rateText: null,
                  );
                },
                title: 'rate'.tr(),
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
                onPressed: () => Navigator.of(context).pop(true),
                title: 'cancel'.tr(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
