import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/home/data/notification_model.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.model});

  final NotificationData model;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) async {
        return AppFunctions.buildAppDialog(
          allowCloseWithBackButton: true,
          context,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'deleteNotification'.tr(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'confirmDeleteNotification'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal
                ),
              ),
              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'deleteNotification'.tr(),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: ColorsManager.kWhite,
                      borderColor: ColorsManager.kPrimaryColor,
                      fontColor: ColorsManager.kBlack,
                      title: 'cancel'.tr(),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        HomeCubit.get(context).deleteNotification(model.id);
      },
      key: Key(model.id.toString()),
      child: ListTile(
        title: TranslateText(
          textAR: model.titleAR,
          textEN: model.titleEN,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: TranslateText(
          textEN: model.msgEN,
          textAR: model.msgAR,
          textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: ColorsManager.kTextGrey),
        ),
        leading: const Icon(
          Icons.info,
          color: ColorsManager.kPrimaryColor,
          size: 30,
        ),
        trailing: Text(
          model.time,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
      ),
    );
  }
}
