import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_widget.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/custom_bottom_nav_bar_widget.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationsCubit()..getCurrentReservations(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is ChangeLanguageSuccessState) {
            Navigator.of(context).pop(true);
            context.setLocale(Locale(state.langCode));
            HomeCubit.get(context)
                .homeLayoutScaffoldKey
                .currentState!
                .closeDrawer();
            ReservationsCubit.get(context).getCurrentReservations();
            HallsCubit.get(context).getHalls();
          }
        },
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            key: cubit.homeLayoutScaffoldKey,
            drawer: AppDrawer(
              screenContext: context,
              user: AppConstants.user,
              scaffoldKey: cubit.homeLayoutScaffoldKey,
            ),
            body: state is LogoutLoadingState
                ? const CustomLoading()
                : cubit.screens[cubit.bottomNavIndex],
            bottomNavigationBar: state is LogoutLoadingState ||
                    state is GetNotificationsLoadingState
                ? null
                : CustomBottomNavBar(
                    cubit: cubit,
                  ),
          );
        },
      ),
    );
  }
}
