import 'package:dakeh_service_provider/core/utils/functions.dart' show AppFunctions;
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart' show BodyWithAppHeader;
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart' show ButtonAppBarType, CustomAppBar;
import 'package:dakeh_service_provider/core/widgets/custom_button.dart' show CustomButton;
import 'package:dakeh_service_provider/features/reservations/data/rate_details_model.dart' show RateDetails;
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/player_profile_item_widget.dart' show PlayerProfileItem;
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/rate_details_view_widget.dart' show RateDetailsView;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RateDetailsScreen extends StatelessWidget {
  const RateDetailsScreen({super.key, required this.rate});

  final RateDetails rate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BodyWithAppHeader(
          appBar: CustomAppBar(
            rightType: ButtonAppBarType.none,
            leftType: ButtonAppBarType.backButton,
            padding: const EdgeInsets.all(20),
            title: '${'rateReservation'.tr()} #${rate.reserveID}',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
                width: double.infinity,
              ),
              Text(
                'ratePlayers'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => PlayerProfileItem(
                    model: rate.players[index].user,
                    onTap: () {
                      AppFunctions.buildAppDialog(
                        allowCloseWithBackButton: true,
                        context,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RateDetailsView(
                                rateTitle:
                                    '${'rate'.tr()} ${rate.players[index].user.name}',
                                rateNum: rate.players[index].playerRateNum,
                                rateText: rate.players[index].playerRateText,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                title: 'cancel'.tr(),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount: rate.players.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
