import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/reservations/data/reservation_model.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_states.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/player_profile_info_screen.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/rate_details_screen.dart' show RateDetailsScreen;
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/details_info_row_widget.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/player_profile_item_widget.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/widgets/rate_player_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReservationDetailsScreen extends StatelessWidget {
  const ReservationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationsCubit, ReservationsStates>(
      listener: (context, state) {
        if (state is AcceptReservationSuccessState) {
          Navigator.pop(context);
          ReservationsCubit.get(context).getAwaitPaymentReservations();
          ReservationsCubit.get(context).getReservationsDetails(
              reservationID:
                  ReservationsCubit.get(context).reservationDetails.id);
          AppFunctions.buildSnackBar(
            context,
            text: 'reservationAccepted'.tr(),
            showCloseIcon: true,
            icon: Icons.verified,
          );
        }
        if (state is RatePlayersSuccessState) {
          ReservationsCubit.get(context).getReservationsDetails(
              reservationID:
                  ReservationsCubit.get(context).reservationDetails.id);
        }
      },
      builder: (context, state) {
        var cubit = ReservationsCubit.get(context);
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () {
              return Future(() => cubit.getReservationsDetails(
                  reservationID: cubit.reservationDetails.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics()
                  .applyTo(const ClampingScrollPhysics()),
              child: state is GetReservationDetailsLoadingState ||
                      state is AcceptReservationLoadingState ||
                      state is RatePlayersLoadingState
                  ? const CustomLoading()
                  : PopScope(
                      onPopInvoked: (didPop) {
                        cubit.playersRate.clear();
                      },
                      child: BodyWithAppHeader(
                        fromHome: false,
                        appBar: CustomAppBar(
                          rightType: ButtonAppBarType.none,
                          leftType: ButtonAppBarType.backButton,
                          title:
                              '- ${AppFunctions.getGameNameByID(gameID: cubit.reservationDetails.gameID)} -',
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              '${'bookingDetails'.tr()}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            CachedNetworkImage(
                              imageUrl:
                                  '${AppConstants.kBaseURL}${cubit.reservationDetails.hallImage}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 175,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsManager.kPrimaryColor
                                      ..withAlpha(1),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 175,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      ColorsManager.kPrimaryColor.withAlpha(1),
                                ),
                                child: const Icon(
                                  Icons.error,
                                  size: 30,
                                  color: ColorsManager.kPrimaryColor,
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 175,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      ColorsManager.kPrimaryColor.withAlpha(1),
                                ),
                                child: const SpinKitCubeGrid(
                                  color: ColorsManager.kPrimaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kDiscordGameIconSVG,
                              title: AppFunctions.getGameNameByID(
                                  gameID: cubit.reservationDetails.gameID),
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kUser2IconSVG,
                              title: cubit.reservationDetails.hallNameProvider,
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kHallIconSVG,
                              title: TranslateText(
                                textAR: cubit.reservationDetails.hallNameAR,
                                textEN: cubit.reservationDetails.hallNameEN,
                                textStyle: const TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kLocationSVG,
                              title: cubit.reservationDetails.hallAddress,
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kHashIconSVG,
                              title:
                                  '${'reservationNumber'.tr()}: ${cubit.reservationDetails.id}',
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kWalletIconSVG,
                              title:
                                  '${cubit.reservationDetails.hallGamePrice} ${'sr'.tr()}',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontColor: ColorsManager.kPrimaryColor,
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            DetailsInfoRow(
                              iconPath: AssetsManager.kHashIconSVG,
                              title: 'players'.tr(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (cubit.reservationDetails.users.isNotEmpty)
                              SizedBox(
                                height: 130,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      PlayerProfileItem(
                                    showRateButton: showRateBTN(context,
                                        index: index,
                                        reservation: cubit.reservationDetails),
                                    model:
                                        cubit.reservationDetails.users[index],
                                    rateOnTap: () {
                                      AppFunctions.buildAppDialog(
                                        context,
                                        allowCloseWithBackButton: true,
                                        child: BlocProvider.value(
                                          value: cubit,
                                          child: BlocConsumer<ReservationsCubit,
                                              ReservationsStates>(
                                            listener: (context, state) {},
                                            builder: (context, state) {
                                              return RatePlayerDialog(
                                                player: cubit.reservationDetails
                                                    .users[index],
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    onTap: () => AppFunctions.navTo(
                                      context,
                                      screen: PlayerProfileInfoScreen(
                                        model: cubit
                                            .reservationDetails.users[index],
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 15,
                                  ),
                                  itemCount:
                                      cubit.reservationDetails.users.length,
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            buildDetailsButton(
                                context, cubit.reservationDetails),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDetailsButton(BuildContext context, Reservation res) {
    switch (res.status) {
      case ReservationsStatus.providerApproval:
        return CustomButton(
          onPressed: () => ReservationsCubit.get(context).acceptReservation(
              reservationID:
                  ReservationsCubit.get(context).reservationDetails.id),
          title: 'acceptReservation'.tr(),
        );
      case ReservationsStatus.awaitPayment:
        return Center(
          child: Text(
            'paymentAwait'.tr(),
            style: const TextStyle(
                fontSize: 24, color: ColorsManager.kPrimaryColor),
          ),
        );
      case ReservationsStatus.reservedSuccessfully:
        return ReservationsCubit.get(context).reservationDetails.rateProvider ==
                null
            ? ReservationsCubit.get(context).playersRate.isEmpty
                ? const SizedBox()
                : CustomButton(
                    onPressed: () =>
                        ReservationsCubit.get(context).sendPlayersRate(
                      reservationID:
                          ReservationsCubit.get(context).reservationDetails.id,
                    ),
                    title: 'rate'.tr(),
                  )
            : InkWell(
                onTap: () {
                  AppFunctions.navTo(context,
                      screen: RateDetailsScreen(
                        rate: ReservationsCubit.get(context).reservationDetails.rateProvider!,
                      ));
                },
                child: Center(
                  child: Container(
                    width: double.infinity,
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorsManager.kPrimaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: ColorsManager.kPrimaryColor,
                          size: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'reservationRated'.tr(),
                          style: const TextStyle(
                              color: ColorsManager.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      default:
        return const SizedBox();
    }
  }

  bool showRateBTN(BuildContext context,
      {required int index, required Reservation reservation}) {
    if (reservation.status != ReservationsStatus.reservedSuccessfully) {
      return false;
    }

    bool isPlayerRated = ReservationsCubit.get(context).playersRate.any(
          (element) => element.playerID == reservation.users[index].id,
        );
    if (isPlayerRated) {
      return false;
    }

    if (reservation.rateProvider == null) {
      return true;
    }

    bool isCurrentPlayerRated = reservation.rateProvider!.players.any(
      (element) => element.id != reservation.users[index].id,
    );
    if (isCurrentPlayerRated) {
      return false;
    }
    return true;
  }
}
