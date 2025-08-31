import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/empty_widget.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/reservations/booking_item_widget.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/reservations/custom_tab_bar_widget.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationsCubit, ReservationsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ReservationsCubit.get(context);
        return BodyWithAppHeader(
          appBar: CustomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            leftType: ButtonAppBarType.none,
            scaffoldKey: HomeCubit.get(context).homeLayoutScaffoldKey,
            rightType: ButtonAppBarType.menuButton,
            title: Image.asset(
              AssetsManager.kDakehLogoIconPNG,
              width: 63,
              height: 34,
              fit: BoxFit.contain,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTabBar(
                isAcceptedSelected: cubit.currentSelected,
                acceptedOnTap: state is GetReservationsLoadingState
                    ? null
                    : () => cubit.getCurrentReservations(),
                paymentOnTap: state is GetReservationsLoadingState
                    ? null
                    : () => cubit.getAwaitPaymentReservations(),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'reservations'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: state is GetReservationsLoadingState
                    ? const CustomLoading(
                        backgroundColor: Colors.transparent,
                      )
                    : cubit.reservationsList.isEmpty
                        ? RefreshIndicator(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: EmptyWidget(
                                withExpanded: false,
                                text: 'noReservations'.tr(),
                              ),
                            ),
                            onRefresh: () {
                              return Future(() {
                                if (cubit.currentSelected) {
                                  cubit.getCurrentReservations();
                                } else {
                                  cubit.getAwaitPaymentReservations();
                                }
                              });
                            })
                        : NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels ==
                                      notification.metrics.maxScrollExtent &&
                                  notification is ScrollUpdateNotification) {
                                if (cubit.reservationsHasMore) {
                                  if (cubit.currentSelected) {
                                    cubit.getCurrentReservations(
                                        fromPagination: true);
                                  } else {
                                    cubit.getAwaitPaymentReservations(
                                        fromPagination: true);
                                  }
                                }
                              }
                              return true;
                            },
                            child: RefreshIndicator(
                              onRefresh: () {
                                return Future(() {
                                  if (cubit.currentSelected) {
                                    cubit.getCurrentReservations();
                                  } else {
                                    cubit.getAwaitPaymentReservations();
                                  }
                                });
                              },
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  if (index < cubit.reservationsList.length) {
                                    return BookingItem(
                                      model: cubit.reservationsList[index],
                                    );
                                  } else {
                                    return Center(
                                      child: cubit.reservationsHasMore
                                          ? const LinearProgressIndicator()
                                          : Text(
                                              'noMoreReservation'.tr(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: ColorsManager
                                                      .kPrimaryColor),
                                            ),
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  indent: 12,
                                  endIndent: 12,
                                  color: ColorsManager.kBottomNavTextGrey,
                                ),
                                itemCount: cubit.reservationsList.length + 1,
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
