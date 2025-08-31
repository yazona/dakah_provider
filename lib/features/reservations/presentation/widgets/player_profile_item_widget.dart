import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/features/auth/data/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerProfileItem extends StatelessWidget {
  const PlayerProfileItem({
    super.key,
    required this.model,
    this.onTap,
    this.showRateButton = false,
    this.rateOnTap,
  });

  final UserData model;
  final bool showRateButton;
  final void Function()? onTap;
  final void Function()? rateOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: '${AppConstants.kBaseURL}${model.image}',
            imageBuilder: (context, imageProvider) => Container(
              width: 71,
              height: 71,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              width: 71,
              height: 71,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.kPrimaryColor.withAlpha(1),
              ),
              child: const SpinKitCubeGrid(
                color: ColorsManager.kPrimaryColor,
                size: 18,
              ),
            ),
            errorWidget: (context, url, error) {
              return Container(
                width: 71,
                height: 71,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.kPrimaryColor.withAlpha(1),
                ),
                child: const Icon(
                  Icons.error,
                  color: ColorsManager.kPrimaryColor,
                  size: 18,
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Text(
              model.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (showRateButton)
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: rateOnTap,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        color: ColorsManager.kPrimaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: ColorsManager.kGold,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          'addYourRate'.tr(),
                          style: const TextStyle(
                              color: ColorsManager.kWhite, fontSize: 9),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
