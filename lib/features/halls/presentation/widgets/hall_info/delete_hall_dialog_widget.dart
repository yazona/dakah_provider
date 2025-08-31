import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeleteHallDialog extends StatelessWidget {
  const DeleteHallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'deleteHallConfirmation'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                btnHeight: 40,
                title: 'delete'.tr(),
                borderColor: ColorsManager.kPrimaryColor,
                backgroundColor: ColorsManager.kWhite,
                fontColor: ColorsManager.kPrimaryColor,
                onPressed: () {
                  Navigator.pop(context);
                  HallsCubit.get(context)
                      .deleteHall(hallID: HallsCubit.get(context).hallInfo.id);
                },
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: CustomButton(
                btnHeight: 40,
                title: 'cancel'.tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
